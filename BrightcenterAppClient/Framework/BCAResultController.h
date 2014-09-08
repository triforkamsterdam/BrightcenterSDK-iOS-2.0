//
//  BCAResultController.h
//  BrightcenterAppClient
//
//  Created by Rick Slot on 07/07/14.
//  Copyright (c) 2014 Trifork. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCStudent.h"

@protocol ResultControllerDelegate <NSObject>
@required
- (void) resultsAreLoaded:(NSArray *) results;
@optional
- (void) resultIsSend;
- (void) networkError:(int) statusCode;
@end

@interface BCAResultController : NSObject

+ (BCAResultController *) instance;

@property (nonatomic, strong) NSString *cookieString;
@property (nonatomic, strong) BCStudent *student;
@property (nonatomic, strong) NSString *urlScheme;
@property (nonatomic, strong) NSString *assessmentIdFromUrl;
@property(nonatomic, strong) id <ResultControllerDelegate> resultControllerDelegate;


- (void) sendResultWithScore:(double) score duration:(int) duration completionStatus:(NSString *) completionStatus assessmentId:(NSString *) assessmentId questionId:(NSString *) questionId;
- (void) loadResultsForAssessment:(NSString *) assessmentId;
- (void) configure;

@end
