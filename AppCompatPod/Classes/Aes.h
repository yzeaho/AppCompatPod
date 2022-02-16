#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Aes : NSObject

/**
 * aes加密
 * 加密+base64编码
 */
+ (NSString *)encryptString:(NSString *)sourceString withKey:(NSString *)key;

/**
 * aes解密
 * base64解码+解密
 */
+ (NSString *)decryptString:(NSString *)cipherString withKey:(NSString *)key;

+ (NSData *)encryptData:(NSData *)data withKey:(NSString *)key;
+ (NSData *)decryptData:(NSData *)data withKey:(NSString *)key;

/**
 * 生成16位的aes秘钥
 */
+ (NSString *)keygen;

@end

NS_ASSUME_NONNULL_END
