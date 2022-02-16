#import <UIKit/UIKit.h>
#import <MMKV/MMKV.h>

NS_ASSUME_NONNULL_BEGIN

@interface Util : NSObject

+ (NSBundle *)bundle;

+ (UIImage *)imageNamed:(NSString *)name;

+ (MMKV *)mmkv;

@end

NS_ASSUME_NONNULL_END
