//
//  ImageDownloader.m
//  table
//
//  Created by Yauheni Khralianok on 1/29/16.
//  Copyright © 2016 Vlad. All rights reserved.
//

#import "ImageDownloader.h"
#import "ImageDownload.h"
#import "ImageDownloadConnection.h"

@interface ImageDownloader() <ImageDownloadConnectionDelegate>
@property (nonatomic, strong) NSMutableArray *connections;
@end


@implementation ImageDownloader

- (instancetype)init
{
    self = [super init];
    if (self) {
        _connections = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - External

- (void)downloadImageAtURL:(NSString *)urlString
{
    if ([[self.connections valueForKey:@"url"] containsObject:[NSURL URLWithString:urlString]]) {
        return;
    }
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    ImageDownloadConnection *connection = [[ImageDownloadConnection alloc] initWithURL:url];
    [self.connections addObject:connection];
    connection.delegate = self;
    [connection start];
}

#pragma mark - <ImageDownloadConnectionDelegate>

- (void)imageDownloadConnection:(ImageDownloadConnection *)connection didDownloadImage:(NSData *)image
{
    if ([self.connections containsObject:connection]) {
        [self.connections removeObject:connection];
    }
    if (image != nil) {
        [self.delegate imageDownloader:self didDownloadImage:image atURL:[connection.url absoluteString]];
    }
}

- (void)imageDownloadConnectionFailedLoadImage:(ImageDownloadConnection *)connection
{
    if ([self.connections containsObject:connection]) {
        [self.connections removeObject:connection];
    }
}

@end
