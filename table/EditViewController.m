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
    _titleText.text = self.detail.cellModel.title;
    _subTitleText.text = self.detail.cellModel.subTitle;
    _contentText.text = self.detail.cellModel.content;
}

- (IBAction)cancelClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveClick:(id)sender {
    CellModel *cellModel = self.detail.cellModel;
    
    cellModel.title = _titleText.text;
    cellModel.subTitle = _subTitleText.text;
    cellModel.content = _contentText.text;
    //[self.detail.tableDataController saveContext];
    [self.detail.syncController updatedCellModel:cellModel];
    [self.detail viewDidLoad];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)deleteClick:(id)sender {
    CellModel *cellModel = self.detail.cellModel;
    [self.detail.syncController deletedCellModel:cellModel];
    [cellModel.managedObjectContext deleteObject:cellModel];
    //[self.detail viewDidLoad];
    [self.navigationController popViewControllerAnimated:YES];
    [self.detail.navigationController popViewControllerAnimated:YES];
}

@end
