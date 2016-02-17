//
//  DetailViewController.m
//  table
//
//  Created by Vlad on 16.02.16.
//  Copyright © 2016 Vlad. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _nameLabel.text = [NSString stringWithFormat:@"First Name: %@",self.cellModel.title];
    _lastNameLabel.text = [NSString stringWithFormat:@"Last Name: %@",self.cellModel.subTitle];
    _cityLabel.text = [NSString stringWithFormat:@"City: %@",self.cellModel.city];
    NSDate *date = self.cellModel.birthday;
    
   // _birthdayLabel.text = stringFromDate;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    //Optionally for time zone conversions
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    
    NSString *stringFromDate = [formatter stringFromDate:date];
    NSLog(stringFromDate);
    
}

- (IBAction)backClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
