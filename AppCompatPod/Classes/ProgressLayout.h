#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProgressLayout : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UITextView *textView;

- (void)setProgress:(NSProgress *)progress;

@end

NS_ASSUME_NONNULL_END
