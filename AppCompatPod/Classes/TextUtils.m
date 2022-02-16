//
//  TextUtils.m
//  AppCompatPod
//
//  Created by 大帅哥小y on 2021/11/3.
//

#import "TextUtils.h"

@implementation TextUtils

+ (BOOL)isEmtpy:(NSString *)text {
    if (text == nil || text == NULL) {
        return YES;
    }
    if ([text isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}

+ (NSString *)convertNull:(id)object {
    if (object == nil) {
        return @"";
    }else if ([object isKindOfClass:[NSNull class]]) {
        return @"";
    }  else if ([object isEqual:[NSNull null]]) {
        return @"";
    } else if ([object isEqualToString:@"<null>"]) {
        return @"";
    } else if ([object isEqualToString:@"(null)"]) {
        return @"";
    } else {
        return object;
    }
}

@end
