//
//  CFAppDelegate.m
//  AppCompatPod
//
//  Created by yzeaho on 07/08/2020.
//  Copyright (c) 2020 yzeaho. All rights reserved.
//

#import "CFAppDelegate.h"
#import <AppCompatPod/DigestUtils.h>
#import <AppCompatPod/Base64.h>

@implementation CFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString *a = [DigestUtils md5:@"123"];
    NSLog(@"%@", a);
    a = [DigestUtils sha1:@"123"];
    NSLog(@"%@", a);
    a = [Base64 encode:@"1234567890"];
    NSLog(@"%@", a);
    NSLog(@"%@", [Base64 decode:a]);
    return YES;
}

@end
