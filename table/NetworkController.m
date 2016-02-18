//
//  NetworkController.m
//  table
//
//  Created by Vlad on 18.02.16.
//  Copyright © 2016 Vlad. All rights reserved.
//

#import "NetworkController.h"
//NSString *const dataUrlString = @"https://api.parse.com/1//classes/tableData2";


@interface NetworkController () <NSURLSessionDataDelegate>
@property (nonatomic,strong) NSMutableData *fullData;
@property (nonatomic,strong) NSURLSession *session;
@property (nonatomic,strong) NSString *sessionToken;
@end

@implementation NetworkController



- (void)updateData {
    NSString *parseAppID = @"b3Hhp5ALpca7UJFnmtfLUxKq4Bpw91YOG5r5chkE";
    NSString *parseAppKey = @"pxLQKjBhCGzu82afMLKFtYYIrppeTErapzRAfH7w" ;
    NSString *urlString = [NSString stringWithFormat:@"https://api.parse.com/1/classes/tableData2"];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:parseAppID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [request addValue:parseAppKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    NSDictionary *data = @{@"title" : @"vlad", @"subTitle":@"vvv"};
    NSError* error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
    [request setHTTPBody:jsonData];
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
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
        
    }
    else
    {
        NSError *jsonError = nil;
        NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:self.fullData options:kNilOptions error:&jsonError];
        self.sessionToken = [jsonArray objectForKey:@"sessionToken"];
    }
}

@end
