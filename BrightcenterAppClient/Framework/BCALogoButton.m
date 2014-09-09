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
    [button setTitle:@"testbutton" forState:UIControlStateNormal];
    button.layer.cornerRadius = 150;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    CGRect frame;
    
    NSLog(@"width: %f height: %f", screenWidth, screenHeight);
    
    
    if(UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)){
        screenWidth = screenRect.size.width;
        screenHeight = screenRect.size.height;
        frame = CGRectMake(screenWidth - 225, screenHeight - 225, 300, 300);
    }else{
        screenHeight = screenRect.size.width;
        screenWidth = screenRect.size.height;
        frame = CGRectMake(screenWidth - 500, screenHeight, 300, 300);
    }
    NSLog(@"%f %f", frame.origin.x, frame.origin.y);
    button.frame = frame;
    
    [button addSubview:[button createCircleWithX:75 Y:75 size:130 color:[UIColor orangeColor]]];
    [button addSubview:[button createCircleWithX:90 Y:90 size:100 color:[UIColor whiteColor]]];
    [button addSubview:[button createCircleWithX:105 Y:105 size:70 color:[UIColor orangeColor]]];
    [button addSubview:[button createCircleWithX:120 Y:120 size:40 color:[UIColor whiteColor]]];
    [button addTarget:nil action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    button.tag = 1337;
    return button;
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

@end
