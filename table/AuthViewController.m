//
//  AuthViewController.m
//  table
//
//  Created by Vlad on 16.02.16.
//  Copyright © 2016 Vlad. All rights reserved.
//

#import "AuthViewController.h"
#import "ViewController.h"

@interface AuthViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITextField *login;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (nonatomic, strong) NetworkController *networkController;

@end

@implementation AuthViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.networkController = [[NetworkController alloc] init];
}

- (IBAction)signIn:(id)sender {
    [self.activityIndicator startAnimating];
    [self.networkController authorizeWithUsername:self.login.text password:self.password.text andCompletion:^(BOOL error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error)
            {
                [self.activityIndicator stopAnimating];
            }
            else
            {
                [self.activityIndicator stopAnimating];
                [self performSegueWithIdentifier:@"Auth" sender:nil];
            }
        });
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    ViewController *viewController = (ViewController *)[segue destinationViewController];
    viewController.syncController = [[SyncController alloc] initWithNetworkController:self.networkController];
}



@end
