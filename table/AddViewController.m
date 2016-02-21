//
//  AddViewController.m
//  table
//
//  Created by Vlad on 19.02.16.
//  Copyright © 2016 Vlad. All rights reserved.
//

#import "AddViewController.h"

@interface AddViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UITextField *subTitleText;
@property (weak, nonatomic) IBOutlet UITextView *contentText;
@end

@implementation AddViewController

- (IBAction)cancelClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveClick:(id)sender {
    NSDictionary *cellData = @{   @"title" : self.titleText.text,
                               @"subTitle" : self.subTitleText.text,
                                @"content" : self.contentText.text};
    [self.tableDataController addCellModelFromCellData:cellData];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
