#import <MBProgressHUD/MBProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (Extension)

+ (void)show:(NSString *)text;

+ (void)show:(NSString *)text view:(UIView *)view;

+ (void)show:(NSString *)text view:(UIView *)view afterDelay:(NSInteger)delay;

@end

NS_ASSUME_NONNULL_END
