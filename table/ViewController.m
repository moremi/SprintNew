//
//  ViewController.m
//  table
//
//  Created by Vlad on 14.01.16.
//  Copyright © 2016 Vlad. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"
#import "DetailViewController.h"
#import "AddViewController.h"
#import "SyncController.h"

NSString *const dataUrlString = @"https://api.parse.com/1//classes/tableData2";
NSString *const parseAppID = @"b3Hhp5ALpca7UJFnmtfLUxKq4Bpw91YOG5r5chkE";
NSString *const parseAppKey = @"pxLQKjBhCGzu82afMLKFtYYIrppeTErapzRAfH7w" ;

@interface ViewController () <NSURLSessionDataDelegate>
@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic,strong) NSMutableData *fullData;
@property (nonatomic,strong) NSURLSession *session;
@property (nonatomic,strong) SyncController *syncController;
@end

@implementation ViewController

#pragma mark - UIViewController override


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationItem.backBarButtonItem.enabled = NO;
    self.data = [[TableDataController alloc] initWithTableView:self.tableView];
    self.data.user = _user;
    self.syncController = [[SyncController alloc] init];
    self.data.syncController = self.syncController;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 160.0;
    self.tableView.dataSource = self.data;
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    
    [self updateData];
}

#pragma mark - IBAction

- (IBAction)updateTouch:(id)sender
{
    [self.activityIndicator startAnimating];
    [self.syncController syncModelsViewController:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detail"])
    {
        DetailViewController *detailViewController = (DetailViewController *)[segue destinationViewController];
        TableViewCell *tableViewCell = (TableViewCell *) sender;
        detailViewController.cellModel = tableViewCell.cellModel;
        detailViewController.tableDataController = self.data;
        detailViewController.syncController = self.syncController;
    }
    else
    {
        AddViewController *addViewController = (AddViewController *)[segue destinationViewController];
        addViewController.viewController = self;
    }
        
}

- (void)updateData {
    NSString *urlString = [NSString stringWithFormat:@"%@/classes/tableData2",_authViewController.parseUrl];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:_authViewController.parseAppID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [request addValue:_authViewController.parseAppKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    //[request addValue:@"r:X2B7wkiKRKzOipMV2g8RWUiSm" forHTTPHeaderField:@"X-Parse-Session-Token"];
    [[self.session dataTaskWithRequest:request] resume];
}

#pragma mark - <NSURLSessionDataDelegate>

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    self.fullData = [[NSMutableData alloc] init];
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [self.fullData appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error)
    {
        [self.activityIndicator stopAnimating];
    }
    else
    {
        NSError *jsonError = nil;
        NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:self.fullData options:kNilOptions error:&jsonError];
        NSArray *fetchedArr = [jsonArray objectForKey:@"results"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.data addCellModelsFromArray:fetchedArr activityIndicator:self.activityIndicator];
        });
    }
}

@end
