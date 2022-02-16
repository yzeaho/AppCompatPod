#import "Util.h"

@implementation Util

+ (NSBundle *)bundle {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *path = [mainBundle pathForResource:@"Frameworks/AppCompatPod.framework/AppCompatPod" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    if (!bundle) {
        path = [mainBundle pathForResource:@"AppCompatPod" ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:path];
    }
    return bundle;
}

+ (UIImage *)imageNamed:(NSString *)name {
    return [UIImage imageNamed:name inBundle:[self bundle] compatibleWithTraitCollection:nil];
}

+ (MMKV *)mmkv {
    return [MMKV mmkvWithID:@"AppCompatPod"];
}

@end
