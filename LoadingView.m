//
//  LoadingView.m
//  AppCompatPod
//
//  Created by 大帅哥小y on 2020/11/27.
//

#import "LoadingView.h"

static LoadingView *shareInstance = nil;

@interface LoadingView () {
    UIImageView *_loadingImageView;
    UIImageView *_backGroundImageView;
    UILabel *_loadingLabelView;
}

@end

@implementation LoadingView

+ (LoadingView *)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [LoadingView new];
    });
    return shareInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _backGroundImageView = [[UIImageView alloc] init];
        [_backGroundImageView setImage:[UIImage imageNamed:@"loading_background"]];
        [self addSubview:_backGroundImageView];
        
        _loadingImageView = [[UIImageView alloc] init];
        [_loadingImageView setImage:[UIImage imageNamed:@"loading_loading"]];
        [self addSubview:_loadingImageView];
        
        _loadingLabelView = [[UILabel alloc] init];
        _loadingLabelView.textAlignment = NSTextAlignmentCenter;
        _loadingLabelView.font = [UIFont systemFontOfSize:12];
        _loadingLabelView.textColor = [UIColor whiteColor];
        [self addSubview:_loadingLabelView];
    }
    return self;
}

+ (void)show:(UIView *)view {
    [[LoadingView share] stopAnimating];
    [[LoadingView share] removeFromSuperview];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [view addSubview:[LoadingView share]];
        [[LoadingView share] setFrame:view.bounds];
        [[LoadingView share] startAnimating];
    });
}

+ (void)hidden {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[LoadingView share] stopAnimating];
        [[LoadingView share] removeFromSuperview];
    });
}

- (void)startAnimating {
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = INT_MAX;
    rotationAnimation.removedOnCompletion = NO;
    [_loadingImageView.layer addAnimation:rotationAnimation forKey:nil];
}

- (void)stopAnimating {
    [_loadingImageView.layer removeAllAnimations];
}

@end
