//
//  NetworkController.h
//  table
//
//  Created by Vlad on 18.02.16.
//  Copyright © 2016 Vlad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CellModel.h"

@interface NetworkController : NSObject
@property (nonatomic,strong) NSString *parseAppID;
@property (nonatomic,strong) NSString *parseAppKey;
@property (nonatomic,strong) NSString *parseUrl;
@property (nonatomic,strong) NSString *user;

- (void)updateDataWithCompletion:(void (^)(NSError *error, NSArray *array))completion;
- (void)updateDataCellModel:(CellModel *)cellModel withCompletion:(void (^)(NSError *error))completion;
- (void)createDataCellModel:(CellModel *)cellModel withCompletion:(void (^)(NSError *error))completion;
- (void)deleteDataCellModel:(NSString *)cellModel withCompletion:(void (^)(NSError *error))completion;

@end
