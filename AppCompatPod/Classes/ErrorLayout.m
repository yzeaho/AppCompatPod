#import "ErrorLayout.h"
#import "Masonry.h"

@interface ErrorLayout ()

@end

@implementation ErrorLayout

- (instancetype)init {
    if (self = [super init]) {
        _imageView = [UIImageView new];
        [self addSubview:_imageView];
        
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
    [_textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).mas_offset(10);
        make.top.mas_equalTo(weakSelf.imageView.mas_bottom).mas_offset(10);
        make.right.equalTo(weakSelf).mas_offset(-10);
        make.bottom.lessThanOrEqualTo(weakSelf).mas_offset(-10);
    }];
}

@end
