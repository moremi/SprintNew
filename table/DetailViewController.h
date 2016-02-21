//
//  DetailViewController.h
//  table
//
//  Created by Vlad on 16.02.16.
//  Copyright © 2016 Vlad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellModel.h"
#import "TableDataController.h"
#import "SyncController.h"

@interface DetailViewController : UIViewController

@property (nonatomic,strong) CellModel *cellModel;
@property (nonatomic,strong) TableDataController *tableDataController;
@property (nonatomic,strong) SyncController *syncController;
@end
