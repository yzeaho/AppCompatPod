#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Aes : NSObject

/**
 * aes128加密
 * 加密+base64编码
 */
+ (NSString *)encrypt:(NSString *)sourceString key:(NSString *)key;

/**
 * aes128解密
 * base64解码+解密
 */
+ (NSString *)decrypt:(NSString *)cipherString key:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
