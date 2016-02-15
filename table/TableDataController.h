//
//  DataController.h
//  table
//
//  Created by Vlad on 10.02.16.
//  Copyright © 2016 Vlad. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface TableDataController : NSObject <UITableViewDataSource>


- (void)addImageFromData:(NSData *)imageData withURL:(NSString *)url;
- (NSData *)ImageDataWithURL:(NSString *)url;

- (void)addCellModelsFromArray:(NSArray *)array activityIndicator:(UIActivityIndicatorView *)activityIndicator;

- (instancetype)initWithTableView:(UITableView *)tableView;

@end
