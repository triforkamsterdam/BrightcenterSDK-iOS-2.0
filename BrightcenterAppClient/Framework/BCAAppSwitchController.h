//
//  BCAAppSwitchController.h
//  BrightcenterAppClient
//
//  Created by Rick Slot on 08/09/14.
//  Copyright (c) 2014 Trifork. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCAResultController.h"

@protocol AppSwitchDelegate <NSObject>
@required
- (void) appIsOpened:(NSString *) assessmentId;
@end

@interface BCAAppSwitchController : NSObject <UITextFieldDelegate>

@property (nonatomic, strong) BCAResultController *resultController;
@property (nonatomic, strong) id <AppSwitchDelegate> appSwitchDelegate;
@property (nonatomic, strong) NSString *urlScheme;

- (void) openBrightcenterAppWithAssessmentId:(NSString *) assessmentId urlScheme:(NSString *) urlScheme;
- (void) configureWithUrl:(NSURL *) url;
+ (BCAAppSwitchController *) instance;

@end
