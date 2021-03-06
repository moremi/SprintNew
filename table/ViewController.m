//
//  ViewController.m
//  table
//
//  Created by Vlad on 14.01.16.
//  Copyright © 2016 Vlad. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"
#import "TableDataController.h"

NSString *const dataUrlString = @"https://api.parse.com/1//classes/tableData2";
NSString *const parseAppID = @"b3Hhp5ALpca7UJFnmtfLUxKq4Bpw91YOG5r5chkE";
NSString *const parseAppKey = @"pxLQKjBhCGzu82afMLKFtYYIrppeTErapzRAfH7w" ;

@interface ViewController () <NSURLSessionDataDelegate>
@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic,strong) TableDataController *data;
@property (nonatomic,strong) NSMutableData *fullData;
@property (nonatomic,strong) NSURLSession *session;

@end

@implementation ViewController

#pragma mark - UIViewController override



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.data = [[TableDataController alloc] initWithTableView:self.tableView];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 160.0;
    self.tableView.dataSource = self.data;
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    [self updateData];
}

#pragma mark - IBAction

- (IBAction)updateTouch:(id)sender
{
    [self updateData];
}

- (void)updateData {
    [self.activityIndicator startAnimating];
    NSString *urlString = [NSString stringWithFormat:dataUrlString];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:parseAppID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [request addValue:parseAppKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
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
