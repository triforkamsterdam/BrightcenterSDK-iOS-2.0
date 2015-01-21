//
//  BCALogoButton.m
//  BrightcenterAppClient
//
//  Created by Rick Slot on 08/09/14.
//  Copyright (c) 2014 Trifork. All rights reserved.
//

#import "BCALogoButton.h"

@implementation BCALogoButton

+ (BCALogoButton *) createButtonWithDelegate:(id <AppSwitchDelegate>) appSwitchDelegate assessmentId:(NSString *) assessmentId urlScheme:(NSString *) scheme{
    BCALogoButton *button = [[BCALogoButton alloc] init];
    button.appSwitchDelegate = appSwitchDelegate;
    button.urlScheme = scheme;
    button.assessmentId = assessmentId;
    
    button.backgroundColor = [UIColor whiteColor];
    button.layer.cornerRadius = 120;
    
    CGRect screenRect = CGRectMake(0, 0, [button screenSize].width, [button screenSize].height);
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    button.frame = CGRectMake(screenWidth - 150, screenHeight - 150, 240, 240);;
    
    int baseOrigin = 50;
    int stepSize = 20;
    int baseSize = 80;
    
    [button addSubview:[button createCircleWithX:baseOrigin Y:baseOrigin size:baseSize color:[UIColor orangeColor]]];
    [button addSubview:[button createCircleWithX:baseOrigin + (stepSize / 2) Y:baseOrigin + (stepSize / 2) size:baseSize - stepSize color:[UIColor whiteColor]]];
    [button addSubview:[button createCircleWithX:baseOrigin + (stepSize) Y:baseOrigin + (stepSize) size:baseSize - (stepSize*2) color:[UIColor orangeColor]]];
    [button addSubview:[button createCircleWithX:baseOrigin + (stepSize * 1.5) Y:baseOrigin + (1.5 * stepSize) size:baseSize - (stepSize*3) color:[UIColor whiteColor]]];
    [button addTarget:nil action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    button.tag = 1337;
    return button;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1){
        BCAAppSwitchController *appSwitchController = [BCAAppSwitchController instance];
        appSwitchController.appSwitchDelegate = self.appSwitchDelegate;
        [appSwitchController openBrightcenterAppWithAssessmentId:self.assessmentId urlScheme:self.urlScheme];
    }
}

- (void) buttonAction:(BCALogoButton *) button{
    BCAAppSwitchController *appSwitchController = [BCAAppSwitchController instance];
    appSwitchController.appSwitchDelegate = button.appSwitchDelegate;
    [appSwitchController openBrightcenterAppWithAssessmentId:button.assessmentId urlScheme:button.urlScheme];
}

- (UIImageView *) createCircleWithX:(int) x Y:(int) y size:(int) size color:(UIColor *) color{
    CGRect frame = CGRectMake(x, y, size, size);
    UIView *circle = [[UIView alloc] initWithFrame: frame];
    circle.backgroundColor = color;
    circle.layer.cornerRadius = size /2;
    
    UIImageView *imageView = [self imageWithView:circle];
    [imageView setFrame: frame];
    
    return imageView;
    
}

- (UIImageView *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
    
    return imageView;
}

- (CGSize)screenSize {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if ((NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        return CGSizeMake(screenSize.height, screenSize.width);
    } else {
        return screenSize;
    }
}

@end
