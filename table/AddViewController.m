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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveClick:(id)sender {
    CellModel *cellModel = _viewController.data.newCellModel;
    cellModel.title = _titleText.text;
    cellModel.subTitle = _subTitleText.text;
    cellModel.content = _contentText.text;
    [_viewController.data.syncController createdCellModel:cellModel];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
