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
    button.layer.cornerRadius = 150;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    CGRect frame;
    
    NSLog(@"width: %f height: %f", screenWidth, screenHeight);
    
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if(UIDeviceOrientationLandscapeLeft == orientation || UIDeviceOrientationLandscapeRight == orientation){
        screenWidth = screenRect.size.height;
        screenHeight = screenRect.size.width;
        frame = CGRectMake(screenWidth - 225, screenHeight - 225, 300, 300);
    }else{
        screenHeight = screenRect.size.height;
        screenWidth = screenRect.size.width;
        frame = CGRectMake(screenWidth - 225, screenHeight - 225, 300, 300);
    }
    NSLog(@"origin: %f %f", frame.origin.x, frame.origin.y);
    button.frame = frame;
    
    [button addSubview:[button createCircleWithX:75 Y:75 size:130 color:[UIColor orangeColor]]];
    [button addSubview:[button createCircleWithX:90 Y:90 size:100 color:[UIColor whiteColor]]];
    [button addSubview:[button createCircleWithX:105 Y:105 size:70 color:[UIColor orangeColor]]];
    [button addSubview:[button createCircleWithX:120 Y:120 size:40 color:[UIColor whiteColor]]];
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
    self.appSwitchDelegate = button.appSwitchDelegate;
    self.assessmentId = button.assessmentId;
    self.urlScheme = button.urlScheme;
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *message;
    UIAlertView *alert;
    if([language isEqualToString:@"nl"]){
        message = @"Je staat op het punt om in te loggen bij Brightcenter, hiervoor is een account nodig. Wil je doorgaan?";
        alert = [[UIAlertView alloc] initWithTitle:@"Waarschuwing" message:message delegate:self cancelButtonTitle:@"Nee" otherButtonTitles:@"Ja", nil];
    }else{
        message = @"You are about to login to Brightcenter, you'll need an account to do this. Are you sure you want to continue?";
        alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:message delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    }
    [alert show];
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
