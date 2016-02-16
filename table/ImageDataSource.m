//
//  Image.m
//  table
//
//  Created by Vlad on 03.02.16.
//  Copyright © 2016 Vlad. All rights reserved.
//

#import "ImageDataSource.h"
#import "ImageDownloader.h"

@interface ImageDataSource () <ImageDownloaderDelegate>
@property (nonatomic,strong) ImageDownloader *downloader;
@property (nonatomic,strong) NSMutableDictionary *imageCache;
@property (nonatomic,strong) NSMutableArray *cellsWithLoadingImages;
@property (nonatomic,strong) TableDataController *tableDataController;
@end

@implementation ImageDataSource

- (instancetype)initWithImageDownloader:(ImageDownloader *)imageDownloader andTableDataController:(TableDataController *)tableDataController
{
    self = [super init];
    if (self) {
        _downloader = imageDownloader;
        _downloader.delegate = self;
        self.tableDataController = tableDataController;
        self.imageCache = [[NSMutableDictionary alloc] init];
        self.cellsWithLoadingImages = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - <External>

- (void)downloadImageAtURL:(NSString *)url forCell:(TableViewCell *)cell
{
    cell.imageUrl = url;
    NSData *imageData = [self.tableDataController ImageDataWithURL:url];
    if (imageData != nil) {
        UIImage *image = [UIImage imageWithData:imageData];
        cell.imageView.image = image;
    }
    else {
        if (![self.cellsWithLoadingImages containsObject:cell]) {
            [self.cellsWithLoadingImages addObject:cell];
            cell.imageView.image = nil;
        }
        [self.downloader downloadImageAtURL:url];
    }
}

#pragma mark - <ImageDownloaderDelegate>

- (void)imageDownloader:(ImageDownloader *)downloader didDownloadImage:(NSData *)image atURL:(NSString *)url
{
    [self.tableDataController addImageFromData:image withURL:url];
    NSArray *cellsArray = [self.cellsWithLoadingImages copy];
    for (TableViewCell *cell in cellsArray)
    {
        if ([cell.imageUrl isEqualToString:url]) {
            UIImage *newImage = [UIImage imageWithData:image];
             dispatch_async(dispatch_get_main_queue(), ^{
                 cell.imageView.image =newImage;
             });
            [self.cellsWithLoadingImages removeObject:cell];
        }
    }
}

@end
