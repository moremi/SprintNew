//
//  NetworkController.h
//  table
//
//  Created by Vlad on 18.02.16.
//  Copyright © 2016 Vlad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CellModel.h"
#import "ViewController.h"

@interface NetworkController : NSObject
@property (nonatomic,strong) NSString *parseAppID;
@property (nonatomic,strong) NSString *parseAppKey;
@property (nonatomic,strong) NSString *parseUrl;
@property (nonatomic,strong) ViewController *viewController;
@property (nonatomic,strong) NSString *user;

- (void)updateData;
- (void)updateDataCellModel:(CellModel *)cellModel;
- (void)createDataCellModel:(CellModel *)cellModel;
- (void)deleteDataCellModel:(NSString *)cellModel;

@end