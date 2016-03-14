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


@property (nonatomic,strong) NSString *clientId;
@property (nonatomic,strong) NSString *clientSecret;
@property (nonatomic,strong) NSString *serverUrl;
@property (nonatomic,strong) NSString *access_token;
@property (nonatomic,strong) NSString *refresh_token;
@property (nonatomic,strong) NSString *token_type;

@end

@implementation NetworkController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.clientId = @"vasiuk_vlad";
        self.clientSecret = @"fheH@!(HR#@*&G$RGfewNCMZC28fh9sdj@!E@F*H@#*F!(FH(HWEF*&!@HF(!@FH#*@H!";
        self.serverUrl = @"http://localhost:3333/api/";
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];

    }
    return self;
}

- (void)authorizeWithUsername:(NSString *)username password:(NSString *)password andCompletion:(void (^)(BOOL))completion
{
    NSString *urlString = [NSString stringWithFormat:@"%@oauth/token",self.serverUrl];
    
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *authenticationString = [NSString stringWithFormat:@"%@:%@", self.clientId, self.clientSecret];
    NSData *authenticationData = [authenticationString dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authenticationValue = [NSString stringWithFormat:@"Basic %@", [authenticationData base64Encoding]];
    [request setValue:authenticationValue forHTTPHeaderField:@"Authorization"];
    
    NSDictionary *data = @{@"grant_type" : @"password",
                           @"username" : username,
                           @"password" : password};
    NSError *jsonError;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&jsonError];
    [request setHTTPBody:jsonData];
    
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *jsonError = nil;
        NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        if ([jsonArray objectForKey:@"access_token"]!=nil)
        {
            self.access_token = [jsonArray objectForKey:@"access_token"];
            self.refresh_token = [jsonArray objectForKey:@"refresh_token"];
            self.token_type = [jsonArray objectForKey:@"token_type"];
            completion(NO);
        }
        else
        {
            completion(YES);
        }
    }] resume];

}

- (void)uploadImageFromData:(NSData *)imageData withCompletion:(void (^)())completion
{
    NSString *urlString = [NSString stringWithFormat:@"%@img",self.serverUrl];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
    
    [[self.session uploadTaskWithRequest:request fromData:imageData completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(str);
    }] resume];
}

- (void)updateDataCellModel:(CellModel *)cellModel withCompletion:(void (^)(NSError *))completion
{
    NSString *urlString = [NSString stringWithFormat:@"%@articles/%@",self.serverUrl,cellModel.objectId];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"Bearer %@",self.access_token] forHTTPHeaderField:@"Authorization"];
    NSDictionary *data = @{@"title" : cellModel.title,
                           @"subTitle" : cellModel.subTitle,
                           @"content" : cellModel.content,
                           @"imageUrl" : cellModel.imageUrl};
    
    if (cellModel.imageData!=nil)
    {
        [self uploadImageFromData:cellModel.imageData withCompletion:^(){
            NSError* error;
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
            [request setHTTPBody:jsonData];
            
            [[self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                completion(error);
            }] resume];
        }];
    }
    else
    {
        NSError* error;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
        [request setHTTPBody:jsonData];
        
        [[self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            completion(error);
        }] resume];
    }
    
}

- (void)createDataCellModel:(CellModel *)cellModel withCompletion:(void (^)(NSError *))completion
{
    NSString *urlString = [NSString stringWithFormat:@"%@articles",self.serverUrl];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"Bearer %@",self.access_token] forHTTPHeaderField:@"Authorization"];
    NSDictionary *data = @{@"title" : cellModel.title,
                           @"subTitle" : cellModel.subTitle,
                           @"content" : cellModel.content,
                           @"imageUrl" : cellModel.imageUrl};
    NSError *jsonError;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&jsonError];
    [request setHTTPBody:jsonData];
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        completion(error);
    }] resume];
}

- (void)deleteDataCellModel:(NSString *)cellModel withCompletion:(void (^)(NSError *))completion
{
    NSString *urlString = [NSString stringWithFormat:@"%@articles/%@",self.serverUrl,cellModel];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"DELETE"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"Bearer %@",self.access_token] forHTTPHeaderField:@"Authorization"];

    [[self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        completion (error);
    }] resume];
}

- (void)updateDataWithCompletion:(void (^)(NSError *, NSArray *))completion
{
    NSString *urlString = [NSString stringWithFormat:@"%@articles",self.serverUrl];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"Bearer %@",self.access_token] forHTTPHeaderField:@"Authorization"];
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *jsonError = nil;
        NSArray *fetchedArr  = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
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
