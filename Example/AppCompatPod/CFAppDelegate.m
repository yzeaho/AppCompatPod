#import "CFAppDelegate.h"
#import <MMKV/MMKV.h>
#import "CFViewController.h"
#import <SDWebImage/SDWebImage.h>
#import <AppCompatPod/AppCompatDiskCache.h>
#import <AppCompatPod/Aes.h>
#import <AppCompatPod/URLEncoder.h>

@implementation CFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [MMKV initializeMMKV:nil logLevel:MMKVLogNone];
    NSString *a = @"中国~!@#$%^&*( )_+-={}[];':<>?,./;'";
    NSString *b = [NSString stringWithFormat:@"%@%@", @"https://www.baidu.com/s?ie=UTF-8&wd=", a];
    NSString *c = [URLEncoder encode:a];
    NSURL *d = [URLEncoder encodeUrl:b];
    NSString *e = [b stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    NSLog(@"%@", c);
    NSLog(@"%@", d);
    NSLog(@"%@", e);
    SDImageCacheConfig.defaultCacheConfig.diskCacheClass = [AppCompatDiskCache class];
    SDImageCacheConfig.defaultCacheConfig.fileManager = [NSFileManager new];
    [NSThread sleepForTimeInterval:1];
    UIViewController *rootController = [[UINavigationController alloc] initWithRootViewController:[CFViewController new]];
    self.window.rootViewController = rootController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
