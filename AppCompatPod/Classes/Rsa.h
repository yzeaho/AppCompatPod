#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Rsa : NSObject

/**
 * 获取公钥
 * @param filepath 公钥文件路径
 */
+ (nullable SecKeyRef)publicKeyRef:(NSString *)filepath;

/**
 * 获取私钥
 * @param filepath 私钥文件路径
 * @param password 私钥文件密码
 */
+ (SecKeyRef)privateKeyRef:(NSString *)filepath password:(NSString *)password;

/**
 * 加密
 * 原文加密，然后进行base64编码
 * @param sourceString 原文
 * @param publicKey 公钥
 */
+ (NSString *)encrypt:(NSString *)sourceString publicKey:(SecKeyRef)publicKey;

/**
 * 解密
 * 先对密文进行base64解码，再解密
 * @param cipherString 密文
 * @param privateKey 私钥
 */
+ (NSString *)decrypt:(NSString *)cipherString privateKey:(SecKeyRef)privateKey;

@end

NS_ASSUME_NONNULL_END
