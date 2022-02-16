#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ColorUtils : NSObject

+ (UIColor *)colorWithHex:(NSUInteger)colorHex withAlpha:(CGFloat)alpha;

+ (UIColor *)colorWithHex:(NSUInteger)colorHex;

@end

NS_ASSUME_NONNULL_END
