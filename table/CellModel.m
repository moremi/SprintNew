//
//  CellModel.m
//  table
//
//  Created by Vlad on 10.02.16.
//  Copyright © 2016 Vlad. All rights reserved.
//

#import "CellModel.h"

@implementation CellModel

// Insert code here to add functionality to your managed object subclass

- (void)updateCellWithDictionary:(NSDictionary *)newData
{
    if (![[newData objectForKey:@"updatedAt"] isEqualToString:self.updatedAt])
    {
        self.title = [newData objectForKey:@"title"];
        self.subTitle = [newData objectForKey:@"subTitle"];
        self.imageUrl = [newData objectForKey:@"imageUrl"];
        self.objectId = [newData objectForKey:@"objectId"];
        self.updatedAt = [newData objectForKey:@"updatedAt"];
    }
}

@end
