//
//  TableViewCell.m
//  table
//
//  Created by Vlad on 26.01.16.
//  Copyright © 2016 Vlad. All rights reserved.
//

#import "TableViewCell.h"
#import "ViewController.h"


@implementation TableViewCell

@synthesize titleLabel;
@synthesize subTitleLabel;
@synthesize imageView;

- (void)prepareForReuse
{
    self.imageView.image = nil;
}

@end
