//
//  SyncController.h
//  table
//
//  Created by Vlad on 19.02.16.
//  Copyright © 2016 Vlad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellModel.h"

@interface SyncController : NSObject

@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic,strong) NSString *user;
- (void)updatedCellModel:(CellModel *)cellModel;
- (void)deletedCellModel:(CellModel *)cellModel;
- (void)createdCellModel:(CellModel *)cellModel;
- (void)syncModelsWithCompletion:(void (^)(NSError *error, NSArray *array))completion;
@end
