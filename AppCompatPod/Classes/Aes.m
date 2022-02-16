#import "Aes.h"
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonSymmetricKeywrap.h> 

@interface Aes ()

@end

@implementation Aes

+ (NSData *)encryptData:(NSData *)data withKey:(NSString *)key {
    char keyPtr[kCCKeySizeAES256 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger sourceDataLength = [data length];
    size_t bufferSize = sourceDataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          sourceDataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    } else {
        free(buffer);
        return nil;
    }
}

+ (NSData *)decryptData:(NSData *)data withKey:(NSString *)key {
    char keyPtr[kCCKeySizeAES256 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger cipherDataLength = [data length];
    size_t bufferSize = cipherDataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          cipherDataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    } else {
        free(buffer);
        return nil;
    }
}

+ (NSString *)encryptString:(NSString *)sourceString withKey:(NSString *)key {
    NSData *sourceData = [sourceString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [self encryptData:sourceData withKey:key];
    if (data) {
        return [data base64EncodedStringWithOptions:0];
    }
    return nil;
}

+ (NSString *)decryptString:(NSString *)cipherString withKey:(NSString *)key {
    NSData *cipherData = [[NSData alloc] initWithBase64EncodedString:cipherString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *data = [self decryptData:cipherData withKey:key];
    if (data) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

+ (NSString *)keygen {
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [NSMutableString new];
    for (int i = 0; i < kCCKeySizeAES128; i++) {
        unsigned index = arc4random() % [sourceStr length];
        NSString *tmp = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:tmp];
    }
    return resultStr;
}

@end
