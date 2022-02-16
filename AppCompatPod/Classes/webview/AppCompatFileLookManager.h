#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AppCompatFileStatus) {
    AppCompatFileDownloadFail,
    AppCompatFileNoSupportPreview,
    AppCompatFileEmpty,
};

NS_ASSUME_NONNULL_BEGIN

@protocol AppCompatFileLookManagerDelegate

- (void)downLoadProcess:(NSProgress *)progress;

- (void)downloadSuccess:(NSURL *)filepathUrl;

- (void)downloadError:(NSString *)error withFailStatus:(AppCompatFileStatus)fileStatus;

@end

@interface AppCompatFileLookManager : NSObject

@property(nonatomic, weak, nullable) id <AppCompatFileLookManagerDelegate> delegate;

- (void)startDownload:(NSURL *)url;

- (void)cancel;

- (BOOL)isSupportPreview:(NSString *)ext;

+ (NSString *)generateLocalFile:(NSURL *)url ext:(NSString *)ext;

@end

NS_ASSUME_NONNULL_END
