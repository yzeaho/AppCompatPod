#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppCompatCookieStorage : NSObject

+ (instancetype)share;

+ (WKProcessPool*)sharedProcessPool;

- (void)syncHttpCookie2WK:(WKHTTPCookieStore *)cookieStore;

- (void)syncHttpCookie2WK;

- (void)clearAllCookies;

- (void)addCookie:(NSHTTPCookie *)cookie;

- (void)cookiesForURL:(NSURL *)url completionHandler:(void (^)(NSArray<NSHTTPCookie *> *))completionHandler;

- (void)setWKCookieStore:(WKHTTPCookieStore *)cookieStore;

@end

NS_ASSUME_NONNULL_END
