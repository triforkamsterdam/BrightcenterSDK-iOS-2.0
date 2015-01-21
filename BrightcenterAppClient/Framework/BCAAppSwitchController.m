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
    NSString *urlString = [NSString stringWithFormat:@"brightcenterApp://?protocolName=%@", urlScheme];
    if(assessmentId != nil){
        urlString = [NSString stringWithFormat:@"%@&assessmentId=%@", urlString, assessmentId];
    }
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
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"https://itunes.apple.com/"]];
    }
}

- (void) configureWithUrl:(NSURL *) url{
    NSString *query = url.query;
    NSArray *components = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    for (NSString *component in components) {
        NSArray *subcomponents = [component componentsSeparatedByString:@"="];
        [parameters setObject:[[subcomponents objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                       forKey:[[subcomponents objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    _resultController.cookieString = [NSString stringWithFormat:@"JSESSIONID=%@", [parameters objectForKey:@"cookie"]];
    _resultController.assessmentIdFromUrl = [parameters objectForKey:@"assessmentId"];
    
    NSString *dataString = [parameters objectForKey:@"data"];
    dataString = [dataString stringByReplacingOccurrencesOfString:@"*" withString:@"="];
    NSData *data = [[NSData alloc] initWithBase64EncodedString:dataString options:kNilOptions];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    
    _resultController.student = [[BCStudent alloc] initWithId:[dict valueForKey:@"personId"] firstName:[dict valueForKey:@"firstName"] lastName:[dict valueForKey:@"lastName"]];
    [self.appSwitchDelegate appIsOpened: _resultController.assessmentIdFromUrl];
}

@end




