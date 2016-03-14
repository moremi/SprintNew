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


- (void)authorizeWithUsername:(NSString *)username password:(NSString *)password andCompletion:(void (^)(BOOL error))completion;

- (void)updateDataWithCompletion:(void (^)(NSError *error, NSArray *array))completion;
- (void)updateDataCellModel:(CellModel *)cellModel withCompletion:(void (^)(NSError *error))completion;
- (void)createDataCellModel:(CellModel *)cellModel withCompletion:(void (^)(NSError *error))completion;
- (void)deleteDataCellModel:(NSString *)cellModel withCompletion:(void (^)(NSError *error))completion;

@end
