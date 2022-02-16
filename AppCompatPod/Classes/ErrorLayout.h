#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ErrorLayout : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITextView *textView;

- (void)layoutView;

@end

NS_ASSUME_NONNULL_END
