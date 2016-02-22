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

- (void)syncModelsWithCompletion:(void (^)(NSError *, NSArray *))completion
{
    self.networkController.user = self.user;
    dispatch_group_t changesToServerDispatchGroup = dispatch_group_create();
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
    
    dispatch_group_notify(changesToServerDispatchGroup, dispatch_get_main_queue(), ^{
        [self.networkController updateDataWithCompletion:^(NSError *error, NSArray *array) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(error,array);
            });
        }];
    });
    
    self.updatedCellModels = [[NSMutableArray alloc] init];
    self.createdCellModels = [[NSMutableArray alloc] init];
    self.deletedCellModels = [[NSMutableArray alloc] init];
    
}

@end
