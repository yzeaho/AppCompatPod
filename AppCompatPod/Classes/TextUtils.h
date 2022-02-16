//
//  TextUtils.h
//  AppCompatPod
//
//  Created by 大帅哥小y on 2021/11/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TextUtils : NSObject

+ (BOOL)isEmtpy:(NSString *)text;

+ (NSString *)convertNull:(id)object;

@end

NS_ASSUME_NONNULL_END
