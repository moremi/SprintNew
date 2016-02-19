//
//  SyncController.h
//  table
//
//  Created by Vlad on 19.02.16.
//  Copyright © 2016 Vlad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CellModel.h"

@interface SyncController : NSObject

- (void)updatedCellModel:(CellModel *)cellModel;
- (void)deletedCellModel:(CellModel *)cellModel;
- (void)createdCellModel:(CellModel *)cellModel;
- (void)syncModelsViewController:(id)viewController;

@end
