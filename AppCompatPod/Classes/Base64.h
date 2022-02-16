#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Base64 : NSObject

/**
 base64编码，模式为填充+不换行
 */
+ (NSString *)encode:(NSString *)sourceString;

/**
 base64解码
 */
+ (NSString *)decode:(NSString *)base64String;

@end

NS_ASSUME_NONNULL_END
