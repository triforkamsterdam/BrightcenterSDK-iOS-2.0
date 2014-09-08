#import "NSObject+JsonUtils.h"

@implementation NSObject (JsonUtils)

- (NSDate *) jsonDateValue {
    if (![self isKindOfClass:[NSNumber class]] || !self) {
        return nil;
    }
    NSNumber *number = (NSNumber *) self;
    return [NSDate dateWithTimeIntervalSince1970:[number longLongValue] / 1000];
}

- (CGFloat) jsonFloatValue {
    if (![self isKindOfClass:[NSNumber class]]) {
        return .0;
    }
    NSNumber *number = (NSNumber *) self;
    return [number floatValue];
}

- (NSInteger) jsonIntegerValue {
    if (![self isKindOfClass:[NSNumber class]]) {
        return 0;
    }
    NSNumber *number = (NSNumber *) self;
    return [number integerValue];
}
@end