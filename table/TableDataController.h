//
//  DataController.h
//  table
//
//  Created by Vlad on 10.02.16.
//  Copyright © 2016 Vlad. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "SyncController.h"

@interface TableDataController : NSObject <UITableViewDataSource>

@property (nonatomic,strong) id imageData;
@property (nonatomic,strong) SyncController *syncController;
@property (nonatomic,strong) NSString *user;

- (NSDictionary *)cellDataAtIndexPath:(NSIndexPath *)indexPath;
- (void)updateCellModelFromCellData:(NSDictionary *)cellData atIndexPath:(NSIndexPath *)indexPath;
- (void)deleteCellModelAtIndexPath:(NSIndexPath *)indexPath;
- (void)addCellModelFromCellData:(NSDictionary *)cellData;

- (void)addImageFromData:(NSData *)imageData withURL:(NSString *)url;
- (NSData *)ImageDataWithURL:(NSString *)url;

- (void)addCellModelsFromArray:(NSArray *)array activityIndicator:(UIActivityIndicatorView *)activityIndicator;
- (void)saveContext;

- (instancetype)initWithTableView:(UITableView *)tableView;

@end
