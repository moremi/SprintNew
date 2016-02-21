//
//  SyncController.m
//  table
//
//  Created by Vlad on 19.02.16.
//  Copyright © 2016 Vlad. All rights reserved.
//

#import "SyncController.h"
#import "NetworkController.h"
@interface SyncController()
@property (nonatomic,strong) NetworkController *networkController;
@property (nonatomic,strong) NSMutableArray *updatedCellModels;
@property (nonatomic,strong) NSMutableArray *deletedCellModels;
@property (nonatomic,strong) NSMutableArray *createdCellModels;
@end


@implementation SyncController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.networkController = [[NetworkController alloc] init];
        self.updatedCellModels = [[NSMutableArray alloc] init];
        self.deletedCellModels = [[NSMutableArray alloc] init];
        self.createdCellModels = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)updatedCellModel:(CellModel *)cellModel
{
    if (![self.updatedCellModels containsObject:cellModel] && ![self.createdCellModels containsObject:cellModel])
        [self.updatedCellModels addObject:cellModel];
}

- (void)deletedCellModel:(CellModel *)cellModel
{
    if ([self.updatedCellModels containsObject:cellModel])
    {
        [self.updatedCellModels delete:cellModel];
    }
    if ([self.createdCellModels containsObject:cellModel])
    {
        [self.createdCellModels delete:cellModel];
    }
    [self.deletedCellModels addObject:cellModel.objectId];
}

- (void)createdCellModel:(CellModel *)cellModel
{
    [self.createdCellModels addObject:cellModel];
}

- (void)syncModelsViewController:(id)viewController
{
    ViewController *vc = (ViewController *)viewController;
    _networkController.viewController = vc;
    _networkController.user = vc.user;
    if (_updatedCellModels.count == 0 && _deletedCellModels.count == 0 && _createdCellModels.count == 0)
    {
        //[viewController updateData];
    }
    dispatch_group_t changesToServerDispatchGroup = dispatch_group_create();
    dispatch_group_notify(changesToServerDispatchGroup, dispatch_get_main_queue(), ^{
        [viewController updateData];
        NSLog(@"SECOND");
    });
    
    for (CellModel *cellModel in self.updatedCellModels)
    {
        dispatch_group_enter(changesToServerDispatchGroup);
        [self.networkController updateDataCellModel:cellModel withCompletion:^(NSError *error) {
            if (error)
            {
                
            } else {
                //[self.updatedCellModels delete:cellModel];
            }
            dispatch_group_leave(changesToServerDispatchGroup);
        }];
    }
    
    for (NSString *cellModel in self.deletedCellModels)
    {
        dispatch_group_enter(changesToServerDispatchGroup);
        [self.networkController deleteDataCellModel:cellModel withCompletion:^(NSError *error) {
            if (error)
            {
                
            } else {
                //[self.deletedCellModels delete:cellModel];
            }
            NSLog(@"FIRST");
            dispatch_group_leave(changesToServerDispatchGroup);
        }];
    }
    
    for (CellModel *cellModel in self.createdCellModels)
    {
        dispatch_group_enter(changesToServerDispatchGroup);
        [self.networkController createDataCellModel:cellModel withCompletion:^(NSError *error) {
            if (error)
            {
            
            } else {
                //[self.createdCellModels delete:cellModel];
            }
            dispatch_group_leave(changesToServerDispatchGroup);
        }];
    }
    
    self.updatedCellModels = [[NSMutableArray alloc] init];
    self.createdCellModels = [[NSMutableArray alloc] init];
    self.deletedCellModels = [[NSMutableArray alloc] init];
    
}

@end
