#import "ProgressLayout.h"
#import "Masonry.h"
#import "Util.h"

@implementation ProgressLayout

- (instancetype)init {
    if (self = [super init]) {
        _imageView = [UIImageView new];
        _imageView.image = [Util imageNamed:@"icon_download"];
        [self addSubview:_imageView];
        
        _progressView = [UIProgressView new];
        [self addSubview:_progressView];
        
        _textView = [UITextView new];
        _textView.textColor = [UIColor blackColor];
        _textView.textAlignment = NSTextAlignmentCenter;
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.font = [UIFont systemFontOfSize:18];
        _textView.selectable = NO;
        _textView.editable = NO;
        [self addSubview:_textView];
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self layoutView];
    }
    return self;
}

- (void)layoutView {
    __weak typeof(self) weakSelf = self;
    [_imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf).mas_offset(-100);
    }];
    [_progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.width.mas_equalTo(200);
        make.top.mas_equalTo(weakSelf.imageView.mas_bottom).mas_offset(20);
        make.bottom.mas_equalTo(weakSelf.textView.mas_top).mas_offset(-10);
    }];
    [_textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(10);
        make.right.equalTo(weakSelf).offset(-10);
        make.top.mas_equalTo(weakSelf.progressView.mas_bottom);
        make.bottom.equalTo(@-20);
    }];
}

- (void)setProgress:(NSProgress *)progress {
    [_progressView setProgress:progress.fractionCompleted];
    NSInteger p = progress.fractionCompleted * 100;
    _textView.text = [NSString stringWithFormat:@"%ld%%", p];
}

@end
