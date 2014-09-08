@class BCStudent;
@class BCAssessment;

typedef enum {
    BCCompletionStatusUnknown,
    BCCompletionStatusCompleted,
    BCCompletionStatusIncomplete,
    BCCompletionStatusNotAttempted
} BCCompletionStatus;

@interface BCAssessmentItemResult : NSObject

@property (nonatomic, strong) NSString *assessmentId;
@property (nonatomic, strong) NSString *studentId;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) NSString *questionId;

@property (nonatomic) CGFloat score;
@property (nonatomic) CGFloat duration;
@property (nonatomic) NSInteger attempts;
@property (nonatomic) BCCompletionStatus completionStatus;

@end