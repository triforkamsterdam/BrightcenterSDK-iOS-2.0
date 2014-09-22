//
//  BCALogoButton.h
//  BrightcenterAppClient
//
//  Created by Rick Slot on 08/09/14.
//  Copyright (c) 2014 Trifork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCAAppSwitchController.h"

@interface BCALogoButton : UIButton<UIAlertViewDelegate>

+ (BCALogoButton *) createButtonWithDelegate:(id <AppSwitchDelegate>) appSwitchDelegate assessmentId:(NSString *) assessmentId urlScheme:(NSString *) scheme;

@property (nonatomic, strong) id <AppSwitchDelegate> appSwitchDelegate;
@property (nonatomic, strong) NSString *assessmentId;
@property (nonatomic, strong) NSString *urlScheme;
@end
