//
//  ImageDownloadConnection.h
//  table
//
//  Created by Oleg on 01.02.16.
//  Copyright © 2016 Vlad. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageDownloadConnection;

@protocol ImageDownloadConnectionDelegate <NSObject>

@required

- (void)imageDownloadConnection:(ImageDownloadConnection *)connection didDownloadImage:(NSData *)image;
- (void)imageDownloadConnectionFailedLoadImage:(ImageDownloadConnection *)connection;

@end

@interface ImageDownloadConnection : NSObject

@property (nonatomic, weak) id <ImageDownloadConnectionDelegate> delegate;
@property (nonatomic, readonly) NSURL *url;

- (instancetype)initWithURL:(NSURL *)url NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
- (void)start;

@end
