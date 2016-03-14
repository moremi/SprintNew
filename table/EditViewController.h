//
//  EditViewController.h
//  table
//
//  Created by Vlad on 19.02.16.
//  Copyright © 2016 Vlad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableDataController.h"

@interface EditViewController : UIViewController
@property (nonatomic,weak) TableDataController *tableDataController;
@property (nonatomic,strong) NSIndexPath *indexPath;
@end
