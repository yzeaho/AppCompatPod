#import "AppCompatCookieStorage.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface AppCompatCookieStorage()<WKHTTPCookieStoreObserver>

@property (nonatomic, readonly, strong) NSMutableSet<NSHTTPCookie *> *cookieSet;
@property (nonatomic, weak) WKHTTPCookieStore *cookieStore;

@end

@implementation AppCompatCookieStorage

static AppCompatCookieStorage *sharedInstance;

+ (instancetype)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (WKProcessPool*)sharedProcessPool {
    static WKProcessPool *processPool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!processPool) {
            processPool = [[WKProcessPool alloc] init];
        }
    });
    return processPool;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _cookieSet = [NSMutableSet new];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(syncCookieNotification)
                                                     name:NSHTTPCookieManagerCookiesChangedNotification
                                                   object:nil];
    }
    return self;
}

- (void)syncCookieNotification {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (NSHTTPCookie *c in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies)  {
            NSLog(@"%@", [self cookieToString:c]);
            [self addCookie:c];
            [self.cookieStore setCookie:c completionHandler:nil];
        }
    });
}

- (void)syncHttpCookie2WK:(WKHTTPCookieStore *)cookieStore {
    NSArray<NSHTTPCookie *> *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
    for (NSHTTPCookie *c in cookies)  {
        NSHTTPCookie *newCookie = [self copyCookie:c];
        [cookieStore setCookie:newCookie completionHandler:nil];
    }
}

- (void)syncHttpCookie2WK {
    if (_cookieStore == nil) {
        return;
    }
    [self syncHttpCookie2WK:_cookieStore];
}

- (NSHTTPCookie *)copyCookie:(NSHTTPCookie *)cookie {
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    [properties setObject:cookie.name forKey:NSHTTPCookieName];
    [properties setObject:cookie.value forKey:NSHTTPCookieValue];
    [properties setObject:cookie.domain forKey:NSHTTPCookieDomain];
    [properties setObject:cookie.path forKey:NSHTTPCookiePath];
    NSHTTPCookie *accessCookie = [[NSHTTPCookie alloc] initWithProperties:properties];
    return accessCookie;
}

- (NSString *)cookieToString:(NSHTTPCookie *) cookie {
    NSString *r = [NSString stringWithFormat:@"%@=%@", cookie.name, cookie.value];
    if (cookie.domain) {
        r = [r stringByAppendingFormat:@"; domain=%@", cookie.domain];
    }
    if (cookie.path) {
        r = [r stringByAppendingFormat:@"; path=%@", cookie.path];
    }
    if (cookie.expiresDate) {
        r = [r stringByAppendingFormat:@"; expires=%@", cookie.expiresDate];
    }
    return r;
}

- (void)clearAllCookies {
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *each in storage.cookies) {
        [storage deleteCookie:each];
    }
    NSLog(@"http cookies clear completion");

    // 清除wkwebview的cookie
    NSSet *set = [NSSet setWithObjects:WKWebsiteDataTypeCookies, nil];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:set
                                               modifiedSince:[NSDate distantPast]
                                           completionHandler:^{
        NSLog(@"wkwebview cookies clear completion");
    }];
}

- (void)setWKCookieStore:(WKHTTPCookieStore *)cs {
    self.cookieStore = cs;
}

- (void)addCookie:(NSHTTPCookie *)cookie {
    [_cookieSet addObject:cookie];
}

- (void)cookiesForURL:(NSURL *)url completionHandler:(void (^)(NSArray<NSHTTPCookie *> *))completionHandler {
    if (_cookieStore == nil) {
        completionHandler([NSMutableArray new]);
        return;
    }
    @weakify(self);
    [_cookieStore getAllCookies:^(NSArray<NSHTTPCookie *> * _Nonnull cookies) {
        @strongify(self);
        NSMutableSet<NSHTTPCookie *> *s = [NSMutableSet new];
        NSMutableArray<NSHTTPCookie *> *array = [NSMutableArray new];
        for (NSHTTPCookie *cookie in cookies) {
            if ([self matches:url withCookie:cookie]) {
                [s addObject:cookie];
            }
        }
        for (NSHTTPCookie *cookie in self.cookieSet) {
            if ([self matches:url withCookie:cookie]) {
                [s addObject:cookie];
            }
        }
        for (NSHTTPCookie *cookie in s) {
            [array addObject:cookie];
        }
        completionHandler(array);
    }];
}

- (bool)matches:(NSURL *)url withCookie:(NSHTTPCookie *)cookie {
    bool domainMatch = false;
    if (cookie.HTTPOnly) {
        if ([url.host isEqualToString:cookie.domain]) {
            domainMatch = true;
        }
    } else {
        domainMatch = [self domainMatch:url.host domain:cookie.domain];
    }
    
    if (!domainMatch) {
        return false;
    }
    
    if (![self pathMatch:url path:cookie.path]) {
        return false;
    }
        
    if (cookie.secure && ![url.absoluteString hasPrefix:@"https"])  {
        return false;
    }
    
    return true;
}

- (bool)domainMatch:(NSString *)urlHost domain:(NSString *)domain {
    if ([urlHost isEqualToString:domain]) {
        return true; // As in 'example.com' matching 'example.com'.
    }
    if ([urlHost hasSuffix:domain]) {
        NSUInteger index = urlHost.length - domain.length;
        unichar ch = [urlHost characterAtIndex:index];
        if (ch == '.') {
            return true;
        }
    }
    return false;
}

- (bool)pathMatch:(NSURL *)url path:(NSString *)path {
    NSString *urlPath = [url path];
    if ([urlPath isEqualToString:path]) {
        return true; // As in '/foo' matching '/foo'.
    }
    if ([urlPath hasPrefix:path]) {
        if ([path hasSuffix:@"/"]) {
            return true; // As in '/' matching '/foo'.
        }
        if ([urlPath characterAtIndex:path.length] == '/') {
            return true; // As in '/foo' matching '/foo/bar'.
        }
    }
    return false;
}

@end
