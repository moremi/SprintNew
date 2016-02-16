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

@end

@implementation AuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ViewController *viewController = (ViewController *)[segue destinationViewController];
    viewController.token = @"asd";
}


@end
