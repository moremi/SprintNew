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
        if (self.imageUrl == nil)
        {
            self.imageUrl = @"";
        }
        self.objectId = [newData objectForKey:@"_id"];
        self.updatedAt = [newData objectForKey:@"updatedAt"];
        self.content = [newData objectForKey:@"content"];
        if (self.content == nil)
        {
            self.content = @"";
        }
        
        //NSString *dateString = [[newData objectForKey:@"createdAt"] objectForKey:@"iso"];
//        NSString *dateString = [newData objectForKey:@"createdAt"];
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
//        self.createdAt = [dateFormatter dateFromString:dateString];
    }
}

@end
