//
//  LoadingView.m
//  AppCompatPod
//
//  Created by 大帅哥小y on 2020/11/27.
//

#import "LoadingView.h"
#import "Masonry.h"
#import "Util.h"
#import "ReactiveObjC.h"

static LoadingView *shareInstance = nil;

@interface LoadingView ()

@property (nonatomic, strong) UIImageView *backGroundImageView;
@property (nonatomic, strong) UIImageView *loadingImageView;
@property (nonatomic, strong) UILabel *labelView;

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
    if (self = [super init]) {
        _backGroundImageView = [[UIImageView alloc] init];
        [_backGroundImageView setImage:[Util imageNamed:@"loading_background"]];
        [self addSubview:_backGroundImageView];
        
        _loadingImageView = [[UIImageView alloc] init];
        [_loadingImageView setImage:[Util imageNamed:@"loading_loading"]];
        [self addSubview:_loadingImageView];
        
        [self layoutSubView];
    }
    return self;
}

- (void)layoutSubView {
    @weakify(self);
    [_backGroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
    }];
    [_loadingImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self.backGroundImageView);
        make.centerY.equalTo(self.backGroundImageView);
    }];
}

+ (void)show:(UIView *)view {
    [[LoadingView share] stopAnimating];
    [[LoadingView share] removeFromSuperview];
    dispatch_async(dispatch_get_main_queue(), ^{
        [view addSubview:[LoadingView share]];
        [[LoadingView share] setFrame:view.bounds];
        [[LoadingView share] startAnimating];
    });
}

+ (void)hidden {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[LoadingView share] stopAnimating];
        [[LoadingView share] removeFromSuperview];
    });
}

+ (void)hiddenLoadingView {
    [self hidden];
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
