#import "DigestUtils.h"
#import <CommonCrypto/CommonCrypto.h>

@interface DigestUtils ()

@end

@implementation DigestUtils
 
+ (nullable NSString *)md5:(NSString *)sourceString {
    if (!sourceString) {
        return nil;
    }
    const char* cString = sourceString.UTF8String;
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cString, (CC_LONG) strlen(cString), result);
    NSMutableString *resultString = [[NSMutableString alloc] init];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [resultString appendFormat:@"%02x", result[i]];
    }
    return resultString;
}

+ (nullable NSString *)sha1:(NSString *)sourceString {
    if (!sourceString) {
        return nil;
    }
    const char *cstr = [sourceString cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:sourceString.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

@end
