#import "MBProgressHUD+Extension.h"

@implementation MBProgressHUD (Extension)

+ (void)showHUDByContent:(NSString *)text view:(UIView *)view {
    [self show:text view:view];
}

+ (void)showHUDByContent:(NSString *)text view:(UIView *)view afterDelay:(NSInteger)delay {
    [self show:text view:view afterDelay:delay];
}

+ (void)show:(NSString *)text view:(UIView *)view {
    [self show:text view:view afterDelay:1.5];
}

+ (void)show:(NSString *)text view:(UIView *)view afterDelay:(NSInteger)delay {
    [self show:text view:view afterDelay:delay completion:nil];
}

+ (void)show:(NSString *)text
        view:(UIView *)view
  completion:(void(^ __nullable)(void))completion {
    [self show:text view:view afterDelay:1.5 completion:completion];
}

+ (void)show:(NSString *)text
        view:(UIView *)view
  afterDelay:(NSInteger)delay
  completion:(void(^ __nullable)(void))completion {
    if ([NSThread isMainThread]) {
        [self showImpl:text view:view afterDelay:delay completion:completion];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self showImpl:text view:view afterDelay:delay completion:completion];
        });
    }
}

+ (void)showImpl:(NSString *)text
            view:(UIView *)view
      afterDelay:(NSInteger)delay
      completion:(void(^ __nullable)(void))completion {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = text;
    hud.detailsLabel.textColor = [UIColor whiteColor];
    hud.detailsLabel.font = hud.label.font;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithWhite:0.f alpha:1.f];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        [MBProgressHUD hideHUDForView:view animated:YES];
        if (completion) {
            completion();
        }
    });
}

@end
