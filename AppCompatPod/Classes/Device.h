#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Device : NSObject

/**
 app的唯一标识，app生成的唯一标识并保存在本地。
 */
+ (NSString *)appUniqueId;

/**
 随机生成一个uuid
 */
+ (NSString *)uuid;

+ (NSString *)secretKey;

@end

NS_ASSUME_NONNULL_END
