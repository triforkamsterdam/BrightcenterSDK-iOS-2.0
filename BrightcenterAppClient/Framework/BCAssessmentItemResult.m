#import "BCAssessmentItemResult.h"

@implementation BCAssessmentItemResult

- (NSString *) description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.assessment=%@", self.assessmentId];
    [description appendFormat:@", self.student=%@", self.studentId];
    [description appendFormat:@", self.date=%@", self.date];
    [description appendFormat:@", self.questionId=%@", self.questionId];
    [description appendFormat:@", self.score=%f", self.score];
    [description appendFormat:@", self.duration=%f", self.duration];
    [description appendFormat:@", self.attempts=%i", self.attempts];
    [description appendFormat:@", self.completionStatus=%d", self.completionStatus];
    [description appendString:@">"];
    return description;
}

@end