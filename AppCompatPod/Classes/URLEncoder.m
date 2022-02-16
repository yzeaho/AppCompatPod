#import "URLEncoder.h"

@interface URLEncoder ()

@end

@implementation URLEncoder

+ (NSString *)encode:(NSString *)s {
    NSString *escape = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.-*_";
    NSCharacterSet *allowedCharacters = [NSCharacterSet characterSetWithCharactersInString:escape];
    NSString *r = [s stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    r = [r stringByReplacingOccurrencesOfString:@"%20" withString:@"+"];
    return r;
}

+ (NSURL *)encodeUrl:(NSString *)urlString {
    NSString *escape = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.-*_:/?&#=";
    NSCharacterSet *allowedCharacters = [NSCharacterSet characterSetWithCharactersInString:escape];
    NSString *url = [urlString stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    return [NSURL URLWithString:url];
}

@end
