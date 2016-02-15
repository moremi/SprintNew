//
//  ImageDownloader.h
//  table
//
//  Created by Yauheni Khralianok on 1/29/16.
//  Copyright © 2016 Vlad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TableViewCell.h"

@class ImageDownloader;

@protocol ImageDownloaderDelegate <NSObject>

- (void)imageDownloader:(ImageDownloader *)downloader didDownloadImage:(NSData *)image atURL:(NSString *)url;

@end

@interface ImageDownloader : NSObject

@property (nonatomic, weak) id <ImageDownloaderDelegate> delegate;

- (void)downloadImageAtURL:(NSString *)url;

@end
