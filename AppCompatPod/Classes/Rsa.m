#import "Rsa.h"

@interface Rsa ()

@end

@implementation Rsa

+ (nullable SecKeyRef)publicKeyRef:(NSString *)filepath {
    NSData *certData = [NSData dataWithContentsOfFile:filepath];
    if (!certData) {
        return nil;
    }
    SecCertificateRef cert = SecCertificateCreateWithData(NULL, (CFDataRef)certData);
    SecKeyRef publicKey = NULL;
    SecTrustRef trust = NULL;
    SecPolicyRef policy = NULL;
    if (cert != NULL) {
        policy = SecPolicyCreateBasicX509();
        if (policy) {
            if (SecTrustCreateWithCertificates((CFTypeRef)cert, policy, &trust) == noErr) {
                SecTrustResultType result;
                if (SecTrustEvaluate(trust, &result) == noErr) {
                    publicKey = SecTrustCopyPublicKey(trust);
                }
            }
        }
    }
    if (policy) CFRelease(policy);
    if (trust) CFRelease(trust);
    if (cert) CFRelease(cert);
    return publicKey;
}

+ (SecKeyRef)privateKeyRef:(NSString *)filepath password:(NSString *)password {
    NSData *p12Data = [NSData dataWithContentsOfFile:filepath];
    NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
    SecKeyRef privateKeyRef = NULL;
    [options setObject:password forKey:(__bridge id)kSecImportExportPassphrase];
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    OSStatus securityError = SecPKCS12Import((__bridge CFDataRef) p12Data,
                                             (__bridge CFDictionaryRef)options, &items);
    if (securityError == noErr && CFArrayGetCount(items) > 0) {
        CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
        SecIdentityRef identityApp =
        (SecIdentityRef)CFDictionaryGetValue(identityDict, kSecImportItemIdentity);
        securityError = SecIdentityCopyPrivateKey(identityApp, &privateKeyRef);
        if (securityError != noErr) {
            privateKeyRef = NULL;
        }
    }
    CFRelease(items);
    return privateKeyRef;
}
 
+ (NSString *)encrypt:(NSString *)sourceString publicKey:(SecKeyRef)publicKey {
    size_t cipherBufferSize = SecKeyGetBlockSize(publicKey);
    uint8_t *cipherBuffer = malloc(cipherBufferSize);
    uint8_t *nonce = (uint8_t *) [sourceString UTF8String];
    SecKeyEncrypt(publicKey,
                  kSecPaddingPKCS1,
                  nonce,
                  strlen((char *) nonce),
                  &cipherBuffer[0],
                  &cipherBufferSize);
    NSData *data = [NSData dataWithBytes:cipherBuffer length:cipherBufferSize];
    NSString *r = [data base64EncodedStringWithOptions:0];
    free(cipherBuffer);
    return r;
}

+ (NSString *)decrypt:(NSString *)cipherString privateKey:(SecKeyRef)privateKey {
    size_t plainBufferSize = SecKeyGetBlockSize(privateKey);
    uint8_t *plainBuffer = malloc(plainBufferSize);
    NSData *cipherData = [[NSData alloc] initWithBase64EncodedString:cipherString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    uint8_t *cipherBuffer = (uint8_t *) [cipherData bytes];
    size_t cipherBufferSize = SecKeyGetBlockSize(privateKey);
    SecKeyDecrypt(privateKey,
                  kSecPaddingPKCS1,
                  cipherBuffer,
                  cipherBufferSize,
                  plainBuffer,
                  &plainBufferSize);
    NSData *data = [NSData dataWithBytes:plainBuffer length:plainBufferSize];
    NSString *r = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    free(plainBuffer);
    return r;
}

@end
