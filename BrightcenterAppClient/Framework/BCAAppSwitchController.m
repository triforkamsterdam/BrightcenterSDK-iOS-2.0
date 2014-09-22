//
//  BCAAppSwitchController.m
//  BrightcenterAppClient
//
//  Created by Rick Slot on 08/09/14.
//  Copyright (c) 2014 Trifork. All rights reserved.
//

#import "BCAAppSwitchController.h"

@implementation BCAAppSwitchController

+ (BCAAppSwitchController *) instance{
    static BCAAppSwitchController *_instance = nil;
    @synchronized(self){
        if (_instance == nil) {
            _instance = [[self alloc] init];
            _instance.resultController = [BCAResultController instance];
        }
    }
    return _instance;
}

- (void) openBrightcenterAppWithAssessmentId:(NSString *) assessmentId urlScheme:(NSString *) urlScheme{
    NSString *urlString = [NSString stringWithFormat:@"brightcenterApp://protocolName/%@/assessmentId/%@", urlScheme, assessmentId];
    NSURL *url = [NSURL URLWithString:urlString];
    if([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
    }else{
        UIAlertView *alert;
        NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *message;
        if([language isEqualToString:@"nl"]){
            message = @"De Brightcenter app is niet geinstalleerd op dit apparaat. Installeer deze om Brightcenter functionaliteiten te gebruiken.";
            alert = [[UIAlertView alloc] initWithTitle:@"Waarschuwing" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Openen in Appstore",nil];
        }else{
            message = @"You don't have the Brightcenter App installed on this device. Please install it to use Brightcenter functionality.";
            alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Open in Appstore", nil];
        }
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1){
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"URL NEEDS TO BE REPLACED WHEN IN PRODUCTION"]];
    }
}

- (void) configureWithUrl:(NSURL *) url{
    _resultController.cookieString = [NSString stringWithFormat:@"JSESSIONID=%@", [self getCookieFromUrlString:[url path]]];
    _resultController.assessmentIdFromUrl = [self getAssessmentIdFromUrlString:[url path]];
    
    NSString *dataString = [self getDataStringFromUrlString:[url path]];
    NSData *data = [[NSData alloc] initWithBase64EncodedString:dataString options:kNilOptions];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    
    _resultController.student = [[BCStudent alloc] initWithId:[dict valueForKey:@"personId"] firstName:[dict valueForKey:@"firstName"] lastName:[dict valueForKey:@"lastName"]];
    [self.appSwitchDelegate appIsOpened];
}

- (NSString *) getDataStringFromUrlString:(NSString *) path{
    NSRegularExpression *regex1 = [NSRegularExpression regularExpressionWithPattern:@"/cookie.*" options:0 error:nil];
    NSString *dataString = [regex1 stringByReplacingMatchesInString:path options:0 range:NSMakeRange(0, [path length]) withTemplate:@""];
    dataString = [dataString stringByReplacingOccurrencesOfString:@"/" withString:@""];
    return dataString;
}

- (NSString *) getCookieFromUrlString:(NSString *) path{
    NSRegularExpression *regex1 = [NSRegularExpression regularExpressionWithPattern:@".*/cookie/" options:0 error:nil];
    NSRegularExpression *regex2 = [NSRegularExpression regularExpressionWithPattern:@"/assessmentId.*" options:0 error:nil];
    NSString *cookie = [regex1 stringByReplacingMatchesInString:path options:0 range:NSMakeRange(0, [path length]) withTemplate:@""];
    cookie = [regex2 stringByReplacingMatchesInString:cookie options:0 range:NSMakeRange(0, [cookie length]) withTemplate:@""];
    return cookie;
}

- (NSString *) getAssessmentIdFromUrlString:(NSString *) path{
    NSRegularExpression *regex1 = [NSRegularExpression regularExpressionWithPattern:@".*/assessmentId" options:0 error:nil];
    NSString *assessmentId = [regex1 stringByReplacingMatchesInString:path options:0 range:NSMakeRange(0, [path length]) withTemplate:@""];
    assessmentId = [assessmentId stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if([assessmentId isEqual:[NSNull null]]){
        assessmentId = @"";
    }
    return assessmentId;
}

@end




