#import <MBProgressHUD/MBProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (Extension)

+ (void)showHUDByContent:(NSString *)text view:(UIView *)view;

+ (void)showHUDByContent:(NSString *)text view:(UIView *)view afterDelay:(NSInteger)delay;

+ (void)show:(NSString *)text view:(UIView *)view;

+ (void)show:(NSString *)text
        view:(UIView *)view
  afterDelay:(NSInteger)delay;

+ (void)show:(NSString *)text
        view:(UIView *)view
  completion:(void(^ __nullable)(void))completion;

+ (void)show:(NSString *)text
        view:(UIView *)view
  afterDelay:(NSInteger)delay
  completion:(void(^ __nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END
