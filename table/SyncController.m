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
        _networkController = [[NetworkController alloc] init];
        _updatedCellModels = [[NSMutableArray alloc] init];
        _deletedCellModels = [[NSMutableArray alloc] init];
        _createdCellModels = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)updatedCellModel:(CellModel *)cellModel
{
    [self.updatedCellModels addObject:cellModel];
}

- (void)deletedCellModel:(CellModel *)cellModel
{
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
        [viewController updateData];
    }
    
    for (CellModel *cellModel in _updatedCellModels)
    {
        [_networkController updateDataCellModel:cellModel];
    }
    for (NSString *cellModel in _deletedCellModels)
    {
        [_networkController deleteDataCellModel:cellModel];
    }
    for (CellModel *cellModel in _createdCellModels)
    {
        [_networkController createDataCellModel:cellModel];
    }
    
    _updatedCellModels = [[NSMutableArray alloc] init];
    _deletedCellModels = [[NSMutableArray alloc] init];
    _createdCellModels = [[NSMutableArray alloc] init];
}

@end
