//
//  TableViewCell.h
//  table
//
//  Created by Vlad on 26.01.16.
//  Copyright © 2016 Vlad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel *titleLabel;
@property (nonatomic,weak) IBOutlet UILabel *subTitleLabel;
@property (nonatomic,weak) IBOutlet UIImageView *imageView;
@property (nonatomic,weak) NSString *imageUrl;

@end
