// test
//  CellModel.h
//  table
//
//  Created by Vlad on 10.02.16.
//  Copyright © 2016 Vlad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface CellModel : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

- (void)updateCellWithDictionary:(NSDictionary *)newData;

@end

NS_ASSUME_NONNULL_END

#import "CellModel+CoreDataProperties.h"
