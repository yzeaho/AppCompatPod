#import "Device.h"
#import "TextUtils.h"
#import "Util.h"
#import "Aes.h"
#import "DigestUtils.h"

@implementation Device

+ (NSString *)appUniqueId {
    NSString *key = @"app_uniqueId";
    NSString *appId = [[Util mmkv] getStringForKey:key];
    if ([TextUtils isEmtpy:appId]) {
        appId = [DigestUtils md5:[self uuid]];
        [[Util mmkv] setString:appId forKey:key];
    }
    return appId;
}

+ (NSString *)uuid {
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref = CFUUIDCreateString(NULL, uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    CFRelease(uuid_ref);
    CFRelease(uuid_string_ref);
    return [uuid lowercaseString];
}

+ (NSString *)secretKey {
    NSString *key = @"app_secretKey";
    NSString *skey = [[Util mmkv] getStringForKey:key];
    if ([TextUtils isEmtpy:skey]) {
        skey = [Aes keygen];
        [[Util mmkv] setString:skey forKey:key];
    }
    return skey;
}

@end
