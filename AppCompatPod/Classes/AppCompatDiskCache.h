#import <Foundation/Foundation.h>
#import <SDWebImage/SDWebImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppCompatDiskCache : SDDiskCache

- (instancetype)initWithCachePath:(NSString *)cachePath config:(nonnull SDImageCacheConfig *)config;

@end

NS_ASSUME_NONNULL_END
