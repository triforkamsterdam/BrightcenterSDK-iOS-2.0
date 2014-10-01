//
//  BCAResultController.h
//  BrightcenterAppClient
//
//  Created by Rick Slot on 07/07/14.
//  Copyright (c) 2014 Trifork. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCStudent.h"

@interface BCAResultController : NSObject

+ (BCAResultController *) instance;

@property (nonatomic, strong) NSString *cookieString;
@property (nonatomic, strong) BCStudent *student;
@property (nonatomic, strong) NSString *urlScheme;
@property (nonatomic, strong) NSString *assessmentIdFromUrl;

- (void) sendResultWithScore:(double) score duration:(int) duration completionStatus:(NSString *) completionStatus assessmentId:(NSString *) assessmentId questionId:(NSString *) questionId success:(void (^)()) success failure:(void (^)(NSError *error, BOOL loginFailure)) failure;
- (void) loadResultsForAssessment:(NSString *) assessmentId success: (void (^)(NSArray *assessmentItemResults)) success failure:(void (^)(NSError *error, BOOL loginFailure)) failure;
- (void) configure;

@end
