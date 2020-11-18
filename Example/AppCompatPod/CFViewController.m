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
    NSLog(@"1");
//    [MBProgressHUD show:@"123" view:self.view afterDelay:1.0 completion:^{
//        NSLog(@"2");
//    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [MBProgressHUD show:@"abc" view:self.view];
    });
}

@end
