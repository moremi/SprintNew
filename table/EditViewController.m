//
//  EditViewController.m
//  table
//
//  Created by Vlad on 19.02.16.
//  Copyright © 2016 Vlad. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UITextField *subTitleText;
@property (weak, nonatomic) IBOutlet UITextView *contentText;
@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *cellData = [self.tableDataController cellDataAtIndexPath:self.indexPath];
    
    self.titleText.text = [cellData valueForKey:@"title"];
    self.subTitleText.text = [cellData valueForKey:@"subTitle"];
    self.contentText.text = [cellData valueForKey:@"content"];
}

- (IBAction)cancelClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveClick:(id)sender {
    NSDictionary *cellData = @{   @"title" : self.titleText.text,
                               @"subTitle" : self.subTitleText.text,
                                @"content" : self.contentText.text};
    [self.tableDataController updateCellModelFromCellData:cellData atIndexPath:self.indexPath];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)deleteClick:(id)sender {
    [self.tableDataController deleteCellModelAtIndexPath:self.indexPath];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
