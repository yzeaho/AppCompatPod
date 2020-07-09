#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DigestUtils : NSObject

+ (nullable NSString *)md5:(NSString *)sourceString;

+ (nullable NSString *)sha1:(NSString *)sourceString;

@end

NS_ASSUME_NONNULL_END
