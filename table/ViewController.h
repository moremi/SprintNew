//
//  ViewController.h
//  table
//
//  Created by Vlad on 14.01.16.
//  Copyright © 2016 Vlad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthViewController.h"
#import "TableDataController.h"

@interface ViewController : UIViewController
@property (nonatomic,strong) NSString *token;
@property (nonatomic,strong) NSString *user;
@property (nonatomic,weak) AuthViewController *authViewController;
@property (nonatomic,strong) TableDataController *data;

- (void)updateData;

@end

