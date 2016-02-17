//
//  CellModel+CoreDataProperties.h
//  table
//
//  Created by Vlad on 17.02.16.
//  Copyright © 2016 Vlad. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CellModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *imageUrl;
@property (nullable, nonatomic, retain) NSString *objectId;
@property (nullable, nonatomic, retain) NSString *subTitle;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *updatedAt;
@property (nullable, nonatomic, retain) NSString *city;
@property (nullable, nonatomic, retain) NSDate *birthday;

@end

NS_ASSUME_NONNULL_END
