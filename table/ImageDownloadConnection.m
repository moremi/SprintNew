//
//  ImageDownloadConnection.m
//  table
//
//  Created by Oleg on 01.02.16.
//  Copyright © 2016 Vlad. All rights reserved.
//

#import "ImageDownloadConnection.h"

@interface ImageDownloadConnection () <NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSURLSession *connection;
@property (nonatomic, strong) NSMutableData *fullData;

@end

@implementation ImageDownloadConnection

- (instancetype)initWithURL:(NSURL *)url
{
    NSParameterAssert(url);
    self = [super init];
    if (self) {
        _url = url;
    }
    return self;
}

- (void)start
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    self.connection = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    [[self.connection dataTaskWithRequest:request] resume];
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
        [self.delegate imageDownloadConnectionFailedLoadImage:self];
    }
    else
    {
        NSData *loadedData = [self.fullData copy];
        [self.delegate imageDownloadConnection:self didDownloadImage:loadedData];
    }
}

@end
