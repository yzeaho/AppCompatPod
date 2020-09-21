#import "Aes.h"
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@interface Aes ()

@end

@implementation Aes

+ (NSString *)encrypt:(NSString *)sourceString key:(NSString *)key {
    char keyPtr[kCCKeySizeAES256 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSData *sourceData = [sourceString dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger sourceDataLength = [sourceData length];
    size_t bufferSize = sourceDataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [sourceData bytes],
                                          sourceDataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        NSString *r = [data base64EncodedStringWithOptions:0];
        return r;
    } else {
        free(buffer);
        return nil;
    }
}

+ (NSString *)decrypt:(NSString *)cipherString key:(NSString *)key {
    char keyPtr[kCCKeySizeAES256 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSData *cipherData = [[NSData alloc] initWithBase64EncodedString:cipherString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSUInteger cipherDataLength = [cipherData length];
    size_t bufferSize = cipherDataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [cipherData bytes],
                                          cipherDataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
        NSString *r = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return r;
    } else {
        free(buffer);
        return nil;
    }
}

@end
