//
//  ImageModel+CoreDataProperties.h
//  table
//
//  Created by Vlad on 15.02.16.
//  Copyright © 2016 Vlad. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ImageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImageModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *imageUrl;
@property (nullable, nonatomic, retain) NSData *imageData;

@end

NS_ASSUME_NONNULL_END
