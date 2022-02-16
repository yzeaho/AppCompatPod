#import "AppCompatSafariController.h"
#import <WebKit/WebKit.h>
#import "Masonry.h"
#import "ReactiveObjC.h"
#import "AppCompatCookieStorage.h"
#import "AppNavigationBar.h"
#import "LoadingView.h"
#import "ErrorLayout.h"
#import "Util.h"
#import "TextUtils.h"

@interface AppCompatSafariController()<WKNavigationDelegate, WKUIDelegate, AppNavigationBarDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) AppNavigationBar *navigationBar;
@property (nonatomic, strong) ErrorLayout *errorLayout;

@end

@implementation AppCompatSafariController

#pragma mark - LifeCycle

- (void)dealloc {
    NSLog(@"%s", __func__);
    [_webView removeObserver:self forKeyPath:@"title"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    _navigationBar = [[AppNavigationBar alloc] init:self.navigationController.navigationBar title:self.title];
    _navigationBar.delegate = self;
    [self.view addSubview:_navigationBar];
    
    _errorLayout = [ErrorLayout new];
    _errorLayout.hidden = YES;
    [self.view addSubview:_errorLayout];
    
    WKWebViewConfiguration *config = [self createWebViewConfiguration];
    _webView = [self createWebView:config];
    [self.view addSubview: _webView];
    [[AppCompatCookieStorage share] syncHttpCookie2WK:_webView.configuration.websiteDataStore.httpCookieStore];

    __weak typeof(self) weakSelf = self;
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.navigationBar.mas_bottom);
        make.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view);
    }];
    [_errorLayout mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.navigationBar.mas_bottom);
        make.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view);
    }];
    
    [self loadUrl:_url];
}

#pragma mark - Private Method

- (WKWebViewConfiguration *)createWebViewConfiguration {
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKPreferences *preferences = [[WKPreferences alloc] init];
    [preferences setValue:@YES forKey:@"allowFileAccessFromFileURLs"];
    if (@available(iOS 10.0, *)) {
        [config setValue:@YES forKey:@"allowUniversalAccessFromFileURLs"];
    }
    config.preferences = preferences;
    config.processPool = [AppCompatCookieStorage sharedProcessPool];
    return config;
}

- (WKWebView *)createWebView:(WKWebViewConfiguration *)config {
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    webView.allowsBackForwardNavigationGestures = NO;
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    webView.allowsBackForwardNavigationGestures = NO;
    webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
    [webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    return webView;
}

- (void)loadUrl:(NSURL *)url {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

- (void)showError:(NSError *)error {
    [self showError:error withImage:@"errorLoad"];
}

- (void)showError:(NSError *)error withImage:(NSString *)img {
    if (_errorLayout.hidden == NO) {
        return;
    }
    _errorLayout.hidden = NO;
    _webView.hidden = YES;
    if (error.userInfo) {
        NSString *description = [TextUtils convertNull:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
        NSString *suggestion = [TextUtils convertNull:[error.userInfo objectForKey:NSLocalizedRecoverySuggestionErrorKey]];
        _errorLayout.textView.text = [NSString stringWithFormat:@"%@\n%@", description, suggestion];
    }
    UIImage *image = [Util imageNamed:@"errorLoad"];
    _errorLayout.imageView.image = image;
    [_errorLayout layoutView];
}

#pragma mark - Observer

-(void)changeTitle:(NSString *)title {
    [self setTitle:title];
    _navigationBar.titleView.text = title;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"title"]) {
        if (object == self.webView) {
            NSString *title = self.webView.title;
            NSLog(@"title:%@", title);
            if ([TextUtils isEmtpy:title]) {
                NSURL *url = self.webView.URL;
                title = [url lastPathComponent];
            }
            [self changeTitle:title];
            return;
        }
    }
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma mark - AppNavigationBarDelegate

- (void)navigationBarGoToBack {
    if (_webView.hidden == NO && [_webView canGoBack]) {
        [_webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - WKNavigationDelegate

//在发送请求之前是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"decidePolicyForNavigationAction %@", navigationAction.request.URL.absoluteString);
    decisionHandler(WKNavigationActionPolicyAllow);
}

//在发送请求之前是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
    preferences:(WKWebpagePreferences *)preferences
decisionHandler:(void (^)(WKNavigationActionPolicy, WKWebpagePreferences *))decisionHandler API_AVAILABLE(ios(13.0)) {
    NSLog(@"decidePolicyForNavigationAction2 %@", navigationAction.request.URL.absoluteString);
    NSURL *url = navigationAction.request.URL;
    NSString *scheme = [url.scheme lowercaseStringWithLocale:[NSLocale currentLocale]];
    WKFrameInfo *target = navigationAction.targetFrame;
    NSLog(@"target %@", target);
    if ([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"]) {
        if (target == nil) {
            [webView loadRequest:navigationAction.request];
        }
        decisionHandler(WKNavigationActionPolicyAllow, preferences);
    } else if ([scheme isEqualToString:@"about"]) {
        decisionHandler(WKNavigationActionPolicyCancel, preferences);
    } else if ([scheme isEqualToString:@"file"]) {
        decisionHandler(WKNavigationActionPolicyAllow, preferences);
    }  else {
        [[UIApplication sharedApplication] openURL:url options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@NO} completionHandler:nil];
        decisionHandler(WKNavigationActionPolicyCancel, preferences);
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse
decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    NSLog(@"decidePolicyForNavigationResponse %@", navigationResponse.response.URL.absoluteString);
    decisionHandler(WKNavigationResponsePolicyAllow);
}

//页面开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"didStartProvisionalNavigation");
    [LoadingView show:self.view];
}

//收到服务器重定向时调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"didReceiveServerRedirectForProvisionalNavigation");
}

//页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"didFailProvisionalNavigation %@", error);
    [LoadingView hidden];
    if ([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code == 102) {
        //Error Domain=WebKitErrorDomain Code=102 "Frame load interrupted"
        return;
    }
    [self showError:error withImage:@"errorLoad"];
}

//当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"didCommitNavigation");
}

//页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"didFinishNavigation");
    [LoadingView hidden];
}

//WKNavigation导航错误
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"didFailNavigation %@", error);
    [LoadingView hidden];
    if ([error.domain isEqualToString:@"QuickLookErrorDomain"] && error.code == 912) {
        [self showError:error];
    }
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString: NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
    } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    NSLog(@"webViewWebContentProcessDidTerminate");
}

- (void)webView:(WKWebView *)webView authenticationChallenge:(NSURLAuthenticationChallenge *)challenge shouldAllowDeprecatedTLS:(void (^)(BOOL))decisionHandler API_AVAILABLE(ios(14.0)) {
    NSLog(@"authenticationChallenge");
    decisionHandler(YES);
}

- (void)webView:(WKWebView *)webView navigationAction:(WKNavigationAction *)navigationAction didBecomeDownload:(WKDownload *)download API_AVAILABLE(ios(15.0)) {
    NSLog(@"didBecomeDownload");
}

- (void)webView:(WKWebView *)webView navigationResponse:(WKNavigationResponse *)navigationResponse didBecomeDownload:(WKDownload *)download API_AVAILABLE(ios(15.0)) {
    NSLog(@"didBecomeDownload");
}

#pragma mark - WKUIDelegate

-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration
  forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    NSLog(@"createWebViewWithConfiguration %@", navigationAction.request);
    NSURL *url = navigationAction.request.URL;
    NSString *scheme = [url.scheme lowercaseStringWithLocale:[NSLocale currentLocale]];
    WKFrameInfo *target = navigationAction.targetFrame;
    NSLog(@"createWebViewWithConfiguration target %@", target);
    if ([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"]) {
        if (target == nil) {
            [webView loadRequest:navigationAction.request];
        }
    }
    return nil;
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text ? alertController.textFields[0].text : @"");
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
