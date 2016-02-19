//
//  DetailViewController.m
//  table
//
//  Created by Vlad on 16.02.16.
//  Copyright © 2016 Vlad. All rights reserved.
//

#import "DetailViewController.h"
#import "TableViewCell.h"
#import "ImageDataSource.h"
#import "EditViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleLabel.text = self.cellModel.title;
    self.subTitleLabel.text = self.cellModel.subTitle;
    NSDate *date = self.cellModel.createdAt;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    self.dateLabel.text = [formatter stringFromDate:date];
    self.contentLabel.text = self.cellModel.content;
    if (![self.cellModel.imageUrl isEqualToString:@""] && self.cellModel.imageUrl!=nil )
    {
        TableViewCell *cell = [[TableViewCell alloc] init];
        cell.imageView = self.imageView;
        ImageDataSource *imageDataSource = (ImageDataSource *)self.tableDataController.imageData;
        [imageDataSource downloadImageAtURL:self.cellModel.imageUrl forCell:cell];
    }
}

- (IBAction)backClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    EditViewController *editViewController = (EditViewController *)segue.destinationViewController;
    editViewController.detail = self;
}

@end
