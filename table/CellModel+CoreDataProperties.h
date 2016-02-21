//
//  CellModel+CoreDataProperties.h
//  table
//
//  Created by Vlad on 18.02.16.
//  Copyright © 2016 Vlad. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CellModel (CoreDataProperties)

@property (nonnull, nonatomic, retain) NSDate *createdAt;
@property (nonnull, nonatomic, retain) NSString *imageUrl;
@property (nonnull, nonatomic, retain) NSString *objectId;
@property (nonnull, nonatomic, retain) NSString *subTitle;
@property (nonnull, nonatomic, retain) NSString *title;
@property (nonnull, nonatomic, retain) NSString *updatedAt;
@property (nonnull, nonatomic, retain) NSString *content;

@end

NS_ASSUME_NONNULL_END
