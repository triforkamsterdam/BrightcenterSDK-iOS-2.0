//
//  BCAResultController.m
//  BrightcenterAppClient
//
//  Created by Rick Slot on 07/07/14.
//  Copyright (c) 2014 Trifork. All rights reserved.
//

#import "BCAResultController.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "NSObject+JsonUtils.h"
#import "BCAssessmentItemResult.h"

@implementation BCAResultController{
    AFHTTPClient *client;
}

+ (BCAResultController *) instance{
    static BCAResultController *_instance = nil;
    @synchronized(self){
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

- (void) configure{
    client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"https://www.brightcenter.nl/"]];
}

- (void) sendResultWithScore:(double) score duration:(int) duration completionStatus:(NSString *) completionStatus assessmentId:(NSString *) assessmentId questionId:(NSString *) questionId success:(void (^)()) success failure:(void (^)(NSError *error, BOOL loginFailure)) failure{
    NSString *path = [NSString stringWithFormat: @"dashboard/api/assessment/%@/student/%@/assessmentItemResult/%@", assessmentId, _student.id, questionId];
    NSMutableURLRequest *urlRequest = [client requestWithMethod:@"POST"
                                                           path:path
                                                     parameters:nil];

    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:_cookieString forHTTPHeaderField: @"Cookie"];
    
    NSDictionary *requestJson = @{
                                  @"score" : @(score),
                                  @"duration" : @(duration),
                                  @"completionStatus" : completionStatus,
                                  };
    
    urlRequest.HTTPBody = [NSJSONSerialization dataWithJSONObject:requestJson options:0 error:nil];
    
    void (^httpSuccess)(NSURLRequest *, NSHTTPURLResponse *, id) = ^(NSURLRequest *request, NSHTTPURLResponse *response, id json) {
            if(success){
                success();
            }
    };
    
    [[AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:httpSuccess
                                                     failure:[self createHttpFailureCallback:failure]] start];
}

- (void) loadResultsForAssessment:(NSString *) assessmentId success: (void (^)(NSArray *assessmentItemResults)) success failure:(void (^)(NSError *error, BOOL loginFailure)) failure{
    if (assessmentId.length == 0) {
        NSLog(@"ERROR - BCStudentsRepository.loadAssessmentItemResults: assessment.id cannot be nil");
        return;
    }
    if (_student.id.length == 0) {
        NSLog(@"ERROR - BCStudentsRepository.loadAssessmentItemResults: student.id cannot be nil");
        return;
    }
    NSString *path = [NSString stringWithFormat:@"/dashboard/api/assessment/%@/students/%@/assessmentItemResult", assessmentId, _student.id];
    NSMutableURLRequest *urlRequest = [client requestWithMethod:@"GET"
                                                    path:path
                                              parameters:nil];
   [urlRequest setValue:_cookieString forHTTPHeaderField: @"Cookie"];
    
    void (^httpSuccess)(NSURLRequest *, NSHTTPURLResponse *, id) = ^(NSURLRequest *request, NSHTTPURLResponse *response, id json) {
        NSMutableArray *results = [NSMutableArray new];
        NSArray *resultsJson = json;
        for (NSDictionary *resultJson in resultsJson) {
            NSDate *date = [resultJson[@"date"] jsonDateValue];
            NSString *questionId = resultJson[@"questionId"];
            CGFloat duration = [resultJson[@"duration"] jsonFloatValue];
            CGFloat score = [resultJson[@"score"] jsonFloatValue];
            NSInteger attempts = [resultJson[@"attempts"] jsonIntegerValue];
            NSString *completionStatusString = resultJson[@"completionStatus"];
            BCCompletionStatus completionStatus = BCCompletionStatusUnknown;
            
            if ([@"COMPLETED" isEqualToString:completionStatusString]) {
                completionStatus = BCCompletionStatusCompleted;
            } else if ([@"INCOMPLETE" isEqualToString:completionStatusString]) {
                completionStatus = BCCompletionStatusIncomplete;
            } else if ([@"NOT_ATTEMPTED" isEqualToString:completionStatusString]) {
                completionStatus = BCCompletionStatusNotAttempted;
            }
            
            BCAssessmentItemResult *result = [BCAssessmentItemResult new];
            result.questionId = questionId;
            result.attempts = attempts;
            result.duration = duration;
            result.score = score;
            result.completionStatus = completionStatus;
            result.date = date;
            result.studentId = _student.id;
            result.assessmentId = assessmentId;
            [results addObject:result];
        }
        if(success){
            success(results);
        }
    };
    

    
    
    [[AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:httpSuccess
                                                     failure:[self createHttpFailureCallback:failure]] start];

}

- (void (^)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id)) createHttpFailureCallback:(void (^)(NSError *, BOOL)) failure {
    void (^httpFailure)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id) = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id o) {
        BOOL loginFailed = response.statusCode == 403;
        NSLog(@"ERROR - BCStudentsRepository: request failed: %@", error);
        if (failure) {
            failure(error, loginFailed);
        }
    };
    return httpFailure;
}

@end
