#import "CFViewController.h"
#import <AppCompatPod/AppCompatSafariController.h>
#import <AppCompatPod/Device.h>
#import <AppCompatPod/ColorUtils.h>
#import <AppCompatPod/AppCompatFileLookViewController.h>
#import <AppCompatPod/Util.h>
#import <SDWebImage/SDWebImage.h>
#import <Masonry/Masonry.h>

@interface CFViewController()

@property (nonatomic, strong) UIButton *b1;
@property (nonatomic, strong) UIButton *b2;
@property (nonatomic, strong) UIImageView *iv1;

@end

@implementation CFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad %@", self);
    self.view.backgroundColor = [UIColor yellowColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor =  [ColorUtils colorWithHex:0x2753be];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.title = @"CFViewController";
    
    _b1 = [UIButton new];
    [_b1 setTitle:@"Safari" forState:UIControlStateNormal];
    [_b1 addTarget:self action:@selector(onClickSafari) forControlEvents:UIControlEventTouchDown];
    _b1.backgroundColor = [UIColor redColor];
    [self.view addSubview:_b1];
    
    _b2 = [UIButton new];
    [_b2 setTitle:@"File" forState:UIControlStateNormal];
    [_b2 addTarget:self action:@selector(onClickFile) forControlEvents:UIControlEventTouchDown];
    _b2.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_b2];
    
    _iv1 = [UIImageView new];
    _iv1.sd_imageTransition = SDWebImageTransition.fadeTransition;
    [self.view addSubview:_iv1];
    [_iv1 sd_setImageWithURL:[NSURL URLWithString:@"https://www.baidu.com/img/PCtm_d9c8750bed0b3c7d089fa7d55720d6cf.png"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear %@", self);
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear %@", self);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear %@", self);
}

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    __weak typeof(self) weakSelf = self;
    [_b1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).mas_offset(weakSelf.view.safeAreaInsets.top);
    }];
    [_b2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.b1.mas_bottom);
    }];
    [_iv1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).mas_offset(10);
        make.right.equalTo(weakSelf.view).mas_offset(-10);
        make.top.mas_equalTo(weakSelf.b2.mas_bottom);
    }];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)onClickSafari {
    AppCompatSafariController *c = [AppCompatSafariController new];
    c.url = [NSURL URLWithString:@"http://www.baidu.com"];
    c.title = @"123";
    [self.navigationController pushViewController:c animated:YES];
}

- (void)onClickFile {
    AppCompatFileLookViewController *c = [AppCompatFileLookViewController new];
    c.url = [NSURL URLWithString:@"https://devstreaming-cdn.apple.com/videos/wwdc/2017/511tj33587vdhds/511/511_working_with_heif_and_hevc.pdf"];
    c.title = @"511_working_with_heif_and_hevc.pdf";
    [self.navigationController pushViewController:c animated:YES];
}

@end
