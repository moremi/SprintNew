//
//  AuthViewController.m
//  table
//
//  Created by Vlad on 16.02.16.
//  Copyright © 2016 Vlad. All rights reserved.
//

#import "AuthViewController.h"
#import "ViewController.h"

@interface AuthViewController () <NSURLSessionDataDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITextField *login;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (nonatomic,strong) NSURLSession *session;
@property (nonatomic,strong) NSMutableData *fullData;
@property (nonatomic,strong) NSString *sessionToken;
@property (nonatomic,strong) NSString *user;
@end

@implementation AuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.parseAppID = @"b3Hhp5ALpca7UJFnmtfLUxKq4Bpw91YOG5r5chkE";
    self.parseAppKey = @"pxLQKjBhCGzu82afMLKFtYYIrppeTErapzRAfH7w";
    self.parseUrl = @"https://api.parse.com/1/";
}

- (IBAction)signIn:(id)sender {
    [self.activityIndicator startAnimating];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/login?username=%@&password=%@",_parseUrl,self.login.text,self.password.text];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:_parseAppID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [request addValue:_parseAppKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    [[self.session dataTaskWithRequest:request] resume];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    ViewController *viewController = (ViewController *)[segue destinationViewController];
    viewController.token = self.sessionToken;
    viewController.authViewController = self;
    viewController.user = self.user;
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
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityIndicator stopAnimating];
    });
    if (error)
    {
        
    }
    else
    {
        NSError *jsonError = nil;
        NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:self.fullData options:kNilOptions error:&jsonError];
        self.sessionToken = [jsonArray objectForKey:@"sessionToken"];
        if (self.sessionToken != nil)
        {
            self.user = [jsonArray objectForKey:@"objectId"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:@"Auth" sender:nil];
            });
        }
        else
            NSLog(@"login incorrect");
    }
}

@end
