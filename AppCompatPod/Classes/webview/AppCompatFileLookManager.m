#import "AppCompatFileLookManager.h"
#import <AFNetworking/AFNetworking-umbrella.h>
#import "ReactiveObjC.h"
#import "DigestUtils.h"

@interface AppCompatFileLookManager()

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (readonly, copy) NSMutableSet *supportSet;

@end

@implementation AppCompatFileLookManager

- (instancetype)init {
    if (self = [super init]) {
        [self setSupportFileType];
    }
    return self;
}

- (void)setSupportFileType {
    _supportSet = [NSMutableSet set];
    // 图片
    [_supportSet addObject:@"jpg"];
    [_supportSet addObject:@"jpeg"];
    [_supportSet addObject:@"jpe"];
    [_supportSet addObject:@"png"];
    [_supportSet addObject:@"bmp"];
    [_supportSet addObject:@"gif"];
    // 其他文本
    [_supportSet addObject:@"txt"];
    [_supportSet addObject:@"pdf"];
    // office
    [_supportSet addObject:@"doc"];
    [_supportSet addObject:@"docx"];
    [_supportSet addObject:@"dot"];
    [_supportSet addObject:@"dotx"];
    [_supportSet addObject:@"xls"];
    [_supportSet addObject:@"xlsx"];
    [_supportSet addObject:@"xlt"];
    [_supportSet addObject:@"xltx"];
    [_supportSet addObject:@"ppt"];
    [_supportSet addObject:@"pot"];
    [_supportSet addObject:@"pps"];
    [_supportSet addObject:@"pptx"];
    [_supportSet addObject:@"potx"];
    [_supportSet addObject:@"ppsx"];
}

- (BOOL)isSupportPreview:(NSString *)ext {
    ext = [ext lowercaseStringWithLocale:[NSLocale currentLocale]];
    return [_supportSet containsObject:ext];
}

+ (NSString *)downloadLocalDir {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *downloadDir = [docDir stringByAppendingPathComponent:@"download"];
    return downloadDir;
}

+ (NSString *)generateLocalFile:(NSURL *)url ext:(NSString *)ext {
    NSString *dir = [self downloadLocalDir];
    NSString *filename = [DigestUtils md5:url.absoluteString];
    NSString *file = [dir stringByAppendingPathComponent:filename];
    if (ext) {
        return [NSString stringWithFormat:@"%@.%@", file, ext];
    } else {
        return file;
    }
}

+ (NSString *)generateLocalFile:(NSURL *)url {
    NSString *ext = [[url pathExtension] lowercaseString];
    return [self generateLocalFile:url ext:ext];
}

- (void)startDownload:(NSURL *)url {
    @weakify(self);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    _downloadTask = [[AFHTTPSessionManager manager] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        @strongify(self);
        [self notifyDownloadProgress:downloadProgress];
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *dir = [AppCompatFileLookManager downloadLocalDir];
        if (![[NSFileManager defaultManager] fileExistsAtPath:dir]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
        }
        return [NSURL fileURLWithPath:[AppCompatFileLookManager generateLocalFile:url]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        @strongify(self);
        if (!self) {
            return;
        }
        if (error || !filePath) {
            [self.delegate downloadError:@"下载文件失败，请点击重试" withFailStatus:AppCompatFileDownloadFail];
            return;
        }
        NSHTTPURLResponse *r = (NSHTTPURLResponse *) response;
        if (![r isKindOfClass:[NSHTTPURLResponse class]]) {
            [self.delegate downloadError:@"不支持打开此文件类型" withFailStatus:AppCompatFileNoSupportPreview];
            return;
        }
        NSInteger code = r.statusCode;
        NSURL *url = response.URL;
        NSString *contentType = [r.allHeaderFields objectForKey:@"Content-Type"];
        NSLog(@"code:%ld contentType:%@", code, contentType);
        if (code >= 200 && code < 300) {
            NSString *ext = [[url pathExtension] lowercaseStringWithLocale:[NSLocale currentLocale]];
            NSLog(@"ext:%@", ext);
            if (![self isSupportPreview:ext]) {
                [self.delegate downloadError:@"不支持打开此文件类型" withFailStatus:AppCompatFileNoSupportPreview];
                return;
            }
            if ([contentType containsString:@"html"]) {
                [[NSFileManager defaultManager] removeItemAtURL:filePath error:nil];
                [self.delegate downloadError:@"文件预览失败" withFailStatus:AppCompatFileNoSupportPreview];
                return;
            }
            if (response.expectedContentLength == 0) {
                [[NSFileManager defaultManager] removeItemAtURL:filePath error:nil];
                [self.delegate downloadError:@"空文件" withFailStatus:AppCompatFileEmpty];
                return;
            }
            [self.delegate downloadSuccess:filePath];
        } else {
            [self.delegate downloadError:@"下载文件失败，请点击重试" withFailStatus:AppCompatFileDownloadFail];
        }
    }];
    
    //3.执行Task
    [_downloadTask resume];
}

- (void)notifyDownloadProgress:(NSProgress *)progress {
    @weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self);
        [self.delegate downLoadProcess:progress];
    });
}

- (void)cancel {
    [_downloadTask cancel];
    _downloadTask = nil;
}

@end
