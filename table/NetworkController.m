//
//  NetworkController.m
//  table
//
//  Created by Vlad on 18.02.16.
//  Copyright © 2016 Vlad. All rights reserved.
//

#import "NetworkController.h"

@interface NetworkController () <NSURLSessionDataDelegate>
@property (nonatomic,strong) NSMutableData *fullData;
@property (nonatomic,strong) NSURLSession *session;
@property (nonatomic,strong) NSString *sessionToken;
@end

@implementation NetworkController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.parseAppID = @"b3Hhp5ALpca7UJFnmtfLUxKq4Bpw91YOG5r5chkE";
        self.parseAppKey = @"pxLQKjBhCGzu82afMLKFtYYIrppeTErapzRAfH7w";
        self.parseUrl = @"https://api.parse.com/1/";
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];

    }
    return self;
}

- (void)updateDataCellModel:(CellModel *)cellModel withCompletion:(void (^)(NSError *))completion
{
    NSString *urlString = [NSString stringWithFormat:@"%@/classes/tableData2/%@",_parseUrl,cellModel.objectId];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:_parseAppID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [request addValue:_parseAppKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    NSDictionary *data = @{@"title" : cellModel.title,
                           @"subTitle" : cellModel.subTitle,
                           @"content" : cellModel.content};
    NSError* error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
    [request setHTTPBody:jsonData];
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        completion(error);
    }] resume];
}

- (void)createDataCellModel:(CellModel *)cellModel withCompletion:(void (^)(NSError *))completion
{
    NSString *urlString = [NSString stringWithFormat:@"%@/classes/tableData2/",_parseUrl];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:_parseAppID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [request addValue:_parseAppKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    NSDictionary *data = @{@"title" : cellModel.title,
                           @"subTitle" : cellModel.subTitle,
                           @"content" : cellModel.content,
                           @"owner" : self.user};
    NSError *jsonError;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&jsonError];
    [request setHTTPBody:jsonData];
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        completion(error);
    }] resume];
}

- (void)deleteDataCellModel:(NSString *)cellModel withCompletion:(void (^)(NSError *))completion
{
    NSString *urlString = [NSString stringWithFormat:@"%@/classes/tableData2/%@",_parseUrl,cellModel];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"DELETE"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:_parseAppID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [request addValue:_parseAppKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        completion (error);
    }] resume];
}

- (void)updateDataWithCompletion:(void (^)(NSError *, NSArray *))completion
{
    NSString *urlString = [NSString stringWithFormat:@"%@/classes/tableData2",self.parseUrl];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:self.parseAppID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [request addValue:self.parseAppKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    //[request addValue:@"r:X2B7wkiKRKzOipMV2g8RWUiSm" forHTTPHeaderField:@"X-Parse-Session-Token"];
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *jsonError = nil;
        NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        NSArray *fetchedArr = [jsonArray objectForKey:@"results"];
        completion(error,fetchedArr);
    }] resume];
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
//        NSError *jsonError = nil;
//        NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:self.fullData options:kNilOptions error:&jsonError];
        //self.sessionToken = [jsonArray objectForKey:@"sessionToken"];
    }
}

@end
