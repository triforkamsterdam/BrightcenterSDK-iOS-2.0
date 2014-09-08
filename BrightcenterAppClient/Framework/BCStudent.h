@interface BCStudent : NSObject

@property(readonly) NSString *id;
@property(readonly) NSString *firstName;
@property(readonly) NSString *lastName;

// Adds the firstName to the lastName, just for convenience purposes.
@property(readonly) NSString *fullName;

- (id) initWithId:(NSString *) id firstName:(NSString *) firstName lastName:(NSString *) lastName;

+ (id) studentWithId:(NSString *) id firstName:(NSString *) firstName lastName:(NSString *) lastName;


@end