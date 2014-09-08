#import "BCStudent.h"

@implementation BCStudent {

}

- (id) initWithId:(NSString *) id firstName:(NSString *) firstName lastName:(NSString *) lastName {
    self = [super init];
    if (self) {
        _id = id;
        _firstName = firstName;
        _lastName = lastName;
    }
    return self;
}

+ (id) studentWithId:(NSString *) id firstName:(NSString *) firstName lastName:(NSString *) lastName {
    return [[self alloc] initWithId:id firstName:firstName lastName:lastName];
}

- (NSString *) fullName {
    if (!self.firstName) {
        return self.lastName;
    }
    if (!self.lastName) {
        return self.firstName;
    }
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

- (NSString *) description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.id=%@", self.id];
    [description appendFormat:@", self.firstName=%@", self.firstName];
    [description appendFormat:@", self.lastName=%@", self.lastName];
    [description appendString:@">"];
    return description;
}

@end