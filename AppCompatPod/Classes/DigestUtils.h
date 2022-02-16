#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DigestUtils : NSObject

/**
 md5摘要
 */
+ (nullable NSString *)md5:(NSString *)sourceString;

/**
 sha1摘要
 */
+ (nullable NSString *)sha1:(NSString *)sourceString;

@end

NS_ASSUME_NONNULL_END
