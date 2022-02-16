#import "AppNavigationBar.h"
#import "Util.h"

@interface AppNavigationBar ()

@end

@implementation AppNavigationBar

- (instancetype)init:(UINavigationBar *)navigationBar title:(NSString *)title {
    UIImage *image = [Util imageNamed:@"ic_back"];
    return [self init:navigationBar title:title back:image];
}

- (instancetype)init:(UINavigationBar *)navigationBar title:(NSString *)title back:(UIImage *)image {
    NSLog(@"system navigation %@", NSStringFromCGRect(navigationBar.frame));
    CGFloat height = navigationBar.frame.origin.y + navigationBar.frame.size.height;
    NSLog(@"height %f", height);
    self = [super initWithFrame:CGRectMake(0, 0, navigationBar.frame.size.width, height)];
    if (self) {
        CGFloat x = 0;
        CGFloat y = navigationBar.frame.origin.y;
        CGFloat width = 48;
        CGFloat height = navigationBar.frame.size.height;
        _backView = [UIButton buttonWithType:UIButtonTypeCustom];
        _backView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _backView.frame = CGRectMake(x, y, width, height);
        [_backView setImage:image forState:UIControlStateNormal];
        [_backView addTarget:self action:@selector(goBackClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backView];
        
        x = _backView.frame.origin.x + _backView.frame.size.width;
        width = self.frame.size.width - (_backView.frame.size.width) * 2;
        _titleView = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
        _titleView.textAlignment = NSTextAlignmentCenter;
        _titleView.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _titleView.text = [NSString stringWithFormat:@"%@", title];
        _titleView.textColor = [navigationBar.titleTextAttributes objectForKey:NSForegroundColorAttributeName];
        _titleView.font = [navigationBar.titleTextAttributes objectForKey:NSFontAttributeName];
        [self addSubview:_titleView];
        self.backgroundColor = navigationBar.barTintColor;
    }
    return self;
}

- (void)goBackClick {
    if ([_delegate respondsToSelector:@selector(navigationBarGoToBack)]) {
        [_delegate navigationBarGoToBack];
    }
}

@end
