//
//  CFViewController.m
//  AppCompatPod
//
//  Created by yzeaho on 07/08/2020.
//  Copyright (c) 2020 yzeaho. All rights reserved.
//

#import "CFViewController.h"
#import <AppCompatPod/MBProgressHUD+Extension.h>

@interface CFViewController ()

@end

@implementation CFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [MBProgressHUD show:@"123"];
}

@end
