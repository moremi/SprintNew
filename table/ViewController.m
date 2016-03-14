//
//  ViewController.m
//  table
//
//  Created by Vlad on 14.01.16.
//  Copyright © 2016 Vlad. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"
#import "EditViewController.h"
#import "AddViewController.h"

@interface ViewController () <UITableViewDelegate>
@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation ViewController




#pragma mark - UIViewController override


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationItem.backBarButtonItem.enabled = NO;
    self.data = [[TableDataController alloc] initWithTableView:self.tableView];
    self.data.user = self.user;
    self.syncController.activityIndicator = self.activityIndicator;
    self.syncController.user = self.user;
    self.data.syncController = self.syncController;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 160.0;
    self.tableView.dataSource = self.data;
    self.tableView.delegate = self;
    
    [self updateTouch:nil];
}

#pragma mark - IBAction

- (IBAction)updateTouch:(id)sender
{
    [self.activityIndicator startAnimating];
    [self.syncController syncModelsWithCompletion:^(NSError *error, NSArray *array) {
        if (error)
        {
            
            [self.activityIndicator stopAnimating];
        } else {
           
            [self.data addCellModelsFromArray:array activityIndicator:self.activityIndicator];
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"edit"])
    {
        EditViewController *editViewController = (EditViewController *)[segue destinationViewController];
        NSIndexPath *indexPath = (NSIndexPath *) sender;
        editViewController.tableDataController = self.data;
        editViewController.indexPath = indexPath;
    }
    else
    {
        AddViewController *addViewController = (AddViewController *)[segue destinationViewController];
        addViewController.tableDataController = self.data;
    }
        
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"edit" sender:indexPath];
}

@end
