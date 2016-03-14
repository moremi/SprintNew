//
//  Image.h
//  table
//
//  Created by Vlad on 03.02.16.
//  Copyright © 2016 Vlad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableDataController.h"
#import "ImageDownloader.h"
#import "TableViewCell.h"




@interface ImageDataSource : NSObject

- (void)downloadImageAtURL:(NSString *)url forCell:(TableViewCell *)cell;

- (instancetype)initWithImageDownloader:(ImageDownloader *)imageDownloader andTableDataController:(TableDataController *)tableDataController NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

@end
