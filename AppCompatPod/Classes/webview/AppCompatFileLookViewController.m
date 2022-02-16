#import "AppCompatFileLookViewController.h"
#import <QuickLook/QuickLook.h>
#import "AppNavigationBar.h"
#import "AppCompatFileLookManager.h"
#import "Masonry.h"
#import "ErrorLayout.h"
#import "ProgressLayout.h"
#import "Util.h"

@interface AppCompatFileLookViewController()<QLPreviewControllerDataSource, QLPreviewControllerDelegate,
                                            AppNavigationBarDelegate, AppCompatFileLookManagerDelegate>

@property (nonatomic, strong) AppNavigationBar *navigationBar;
@property (nonatomic, strong) ErrorLayout *errorLayout;
@property (nonatomic, strong) ProgressLayout *progressLayout;
@property (nonatomic, strong) AppCompatFileLookManager *manager;
@property (nonatomic, strong) NSURL *localFilepathUrl;

@end

@implementation AppCompatFileLookViewController

#pragma mark - LifeCycle

- (void)dealloc {
    NSLog(@"%s", __func__);
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
    _errorLayout.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(downloadAgain)];
    [_errorLayout addGestureRecognizer:tapGesture];
    _errorLayout.textView.userInteractionEnabled = YES;
    [self.view addSubview:_errorLayout];
    
    _progressLayout = [ProgressLayout new];
    _progressLayout.hidden = YES;
    [self.view addSubview:_progressLayout];
    
    __weak typeof(self) weakSelf = self;
    [_errorLayout mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.navigationBar.mas_bottom);
        make.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view);
    }];
    [_progressLayout mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.navigationBar.mas_bottom);
        make.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view);
    }];
        
    _manager = [AppCompatFileLookManager new];
    _manager.delegate = self;
    
    NSString *ext = [[_url pathExtension] lowercaseString];
    if (![_manager isSupportPreview:ext]) {
        [self downloadError:@"不支持打开此文件类型" withFailStatus:AppCompatFileNoSupportPreview];
        return;
    }

    NSString *localFilePath = [AppCompatFileLookManager generateLocalFile:_url ext:ext];
    if ([[NSFileManager defaultManager] fileExistsAtPath:localFilePath]) {
        [self openLocalFile:[NSURL fileURLWithPath:localFilePath]];
    } else {
        [self downloadAgain];
    }
}

#pragma mark - Private Method

- (void)downloadAgain {
    _progressLayout.hidden = NO;
    _errorLayout.hidden = YES;
    [_manager startDownload:_url];
}

- (void)openLocalFile:(NSURL *)filepathUrl {
    NSLog(@"openLocalFile %@", filepathUrl);
    _localFilepathUrl = filepathUrl;
    if (![QLPreviewController canPreviewItem:filepathUrl]) {
        [self downloadError:@"不支持打开此文件类型" withFailStatus:AppCompatFileNoSupportPreview];
        return;
    }
    
    QLPreviewController *preview = [[QLPreviewController alloc] init];
    preview.dataSource = self;
    preview.delegate = self;
    [self addChildViewController:preview];
    [self.view addSubview:preview.view];

    __weak typeof(self) weakSelf = self;
    [preview.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.navigationBar.mas_bottom);
        make.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view);
    }];
    _progressLayout.hidden = YES;
    _errorLayout.hidden = YES;
}

#pragma mark - AppNavigationBarDelegate

- (void)navigationBarGoToBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - QLPreviewControllerDelegate

- (BOOL)previewController:(QLPreviewController *)controller shouldOpenURL:(NSURL *)url forPreviewItem:(id <QLPreviewItem>)item {
    return YES;
}

#pragma mark - QLPreviewControllerDataSource

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return _localFilepathUrl;
}

#pragma mark - FileLookManagerDelegate

- (void)downLoadProcess:(NSProgress *)progress {
    _progressLayout.hidden = NO;
    _errorLayout.hidden = YES;
    [_progressLayout setProgress:progress];
}

- (void)downloadSuccess:(NSURL *)filepathUrl {
    [self openLocalFile:filepathUrl];
}

- (void)downloadError:(NSString *)error withFailStatus:(AppCompatFileStatus)fileStatus {
    UIImage *image;
    switch (fileStatus) {
        case AppCompatFileDownloadFail:
            _errorLayout.userInteractionEnabled = YES;
            _errorLayout.textView.userInteractionEnabled = YES;
            image = [Util imageNamed:@"errorLoad"];
            break;
        case AppCompatFileNoSupportPreview:
            _errorLayout.userInteractionEnabled = NO;
            _errorLayout.textView.userInteractionEnabled = NO;
            image = [Util imageNamed:@"errorLoad"];
            break;
        case AppCompatFileEmpty:
            _errorLayout.userInteractionEnabled = NO;
            _errorLayout.textView.userInteractionEnabled = NO;
            image = [Util imageNamed:@"errorLoad"];
            break;
        default:
            break;
    }
    _errorLayout.hidden = NO;
    _errorLayout.textView.text = error;
    _errorLayout.imageView.image = image;
    [_errorLayout layoutView];
}

@end
