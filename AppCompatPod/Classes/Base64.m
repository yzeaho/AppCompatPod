#import "Base64.h"

@interface Base64 ()

@end

@implementation Base64
 
+ (NSString *)encode:(NSString *)sourceString {
    NSData *data = [sourceString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *r = [data base64EncodedStringWithOptions:0];
    return r;
}

+ (NSString *)decode:(NSString *)base64String {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString *r =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return r;
}

@end
