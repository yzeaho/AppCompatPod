#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AppNavigationBarDelegate <NSObject>

@optional

- (void)navigationBarGoToBack;

@end

@interface AppNavigationBar : UIView

@property (nonatomic, weak) id<AppNavigationBarDelegate> delegate;
@property (nonatomic, strong) UILabel *titleView;
@property (nonatomic, strong) UIButton *backView;

- (instancetype)init:(UINavigationBar *)navigationBar title:(NSString *)title;

- (instancetype)init:(UINavigationBar *)navigationBar title:(NSString *)title back:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
