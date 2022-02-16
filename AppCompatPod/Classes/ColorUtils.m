#import "ColorUtils.h"

@implementation ColorUtils

+ (UIColor *)colorWithHex:(NSUInteger)colorHex {
    return [self colorWithHex:colorHex withAlpha:1];
}

+ (UIColor *)colorWithHex:(NSUInteger)colorHex withAlpha:(CGFloat)alpha {
    NSUInteger red = (colorHex >> 16) & 0xff;
    NSUInteger green = (colorHex >> 8) & 0xff;
    NSUInteger blue = colorHex & 0xff;
    return [UIColor colorWithRed:(float)red / 255
                           green:(float)green / 255
                            blue:(float)blue / 255
                           alpha:alpha];
}

@end
