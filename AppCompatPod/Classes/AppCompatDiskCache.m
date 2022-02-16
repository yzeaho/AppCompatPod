#import "AppCompatDiskCache.h"
#import "Device.h"
#import "Aes.h"

@interface AppCompatDiskCache ()

@property (nonatomic, copy) NSString *diskCachePath;
@property (nonatomic, strong, nonnull) NSFileManager *fileManager;

@end

@implementation AppCompatDiskCache

- (instancetype)initWithCachePath:(NSString *)cachePath config:(nonnull SDImageCacheConfig *)config {
    if (self = [super initWithCachePath:cachePath config:config]) {
        _diskCachePath = cachePath;
        _fileManager = config.fileManager;
    }
    return self;
}

- (NSData *)dataForKey:(NSString *)key {
    NSParameterAssert(key);
    NSString *filePath = [self cachePathForKey:key];
    NSData *data = [NSData dataWithContentsOfFile:filePath options:self.config.diskCacheReadingOptions error:nil];
    if (data) {
        NSString *skey = [self secretKey];
        data = [Aes decryptData:data withKey:skey];
        return data;
    }
    return nil;
}

- (void)setData:(NSData *)data forKey:(NSString *)key {
    NSParameterAssert(data);
    NSParameterAssert(key);
    
    if (![self.fileManager fileExistsAtPath:self.diskCachePath]) {
        [self.fileManager createDirectoryAtPath:self.diskCachePath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    // get cache Path for image key
    NSString *cachePathForKey = [self cachePathForKey:key];
    // transform to NSURL
    NSURL *fileURL = [NSURL fileURLWithPath:cachePathForKey];
    
    NSData *eData = [Aes encryptData:data withKey:[self secretKey]];
    [eData writeToURL:fileURL options:self.config.diskCacheWritingOptions error:nil];
    
    // disable iCloud backup
    if (self.config.shouldDisableiCloud) {
        // ignore iCloud backup resource value error
        [fileURL setResourceValue:@YES forKey:NSURLIsExcludedFromBackupKey error:nil];
    }
}

- (NSString *)secretKey {
    return [Device secretKey];
}


@end
