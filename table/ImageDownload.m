//
//  ImageDownload.m
//  table
//
//  Created by Vlad on 31.01.16.
//  Copyright © 2016 Vlad. All rights reserved.
//

#import "ImageDownload.h"
#import "ImagesLoader.h"

@interface ImageDownload () <NSURLConnectionDataDelegate>

@property (nonatomic,retain) NSMutableData *fullData;
@property (nonatomic,retain) NSString *url;
@property (nonatomic,retain) TableViewCell *cell;
@property (nonatomic,retain) ImageDownloader *downloader;

@end


@implementation ImageDownload 

#pragma mark - <ImageDownloaderDelegate>

- (void)imageDownloader:(ImageDownloader *)downloader startDownloadImageAtURL:(NSString *)urlString forCell:(TableViewCell *)cell
{
    self.url = urlString;
    self.cell = cell;
    self.downloader = downloader;
    
}

- (void)imageDownloader:(ImageDownloader *)downloader didDownloadImage:(UIImage *)image atURL:(NSString *)url {
  //  [downloader finishDownloadImage:image atURL:self.url forCell:self.cell];
}

#pragma mark - <NSURLConnectionDataDelegate>

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.fullData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.fullData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    UIImage *loadedImage = [UIImage imageWithData:self.fullData];
    [self imageDownloader:self.downloader didDownloadImage:loadedImage atURL:self.url];
}



@end
