//
//  BCAAppSwitchController.m
//  BrightcenterAppClient
//
//  Created by Rick Slot on 08/09/14.
//  Copyright (c) 2014 Trifork. All rights reserved.
//

#import "BCAAppSwitchController.h"

@implementation BCAAppSwitchController

bool parentalLocked = true;
int code;
NSString *codeString;
NSURL *lockUrl;

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
        if (parentalLocked) {
            lockUrl = url;
            [self showParentalGate];
            parentalLocked = false;
        } else {
            [[UIApplication sharedApplication] openURL:url];
        }
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
        lockUrl = [NSURL URLWithString:@"http://itunes.com/apps/brightcenter"];
        [alert show];
    }
}

- (void) showParentalGate {
    UIAlertView *alert;
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *message;
    
    code = arc4random() % 90000 + 10000;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterSpellOutStyle];
    
    [self createCodeString];
    
    if([language isEqualToString:@"nl"]){
        message = [NSString stringWithFormat: @"Vul de code in om door te gaan: \n%@", codeString];
        alert = [[UIAlertView alloc] initWithTitle:@"Alleen voor ouders \n(of leraren)!" message:message delegate:self cancelButtonTitle:@"Terug" otherButtonTitles:@"Doorgaan",nil];
    }else{
        message = [NSString stringWithFormat: @"Enter the code to continue: \n%@", codeString];
        alert = [[UIAlertView alloc] initWithTitle:@"Parents (or teachers) only!" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
    }
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[alert textFieldAtIndex:0] setDelegate:self];
    [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    [[alert textFieldAtIndex:0] becomeFirstResponder];
    [alert show];
}

- (void) prependNumber:(NSString *)num {
    codeString = [NSString stringWithFormat:@"%@ %@", num, codeString];
}


-(void) createCodeString  {
    codeString = @"";
    int parentcode = code;
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
   
    do
    {
        int digit = parentcode % 10;
        
        switch (digit) {
            case 0:
                [language isEqualToString:@"nl"] ? [self prependNumber:@"NUL"] : [self prependNumber:@"ZERO"];
                break;
            case 1:
                [language isEqualToString:@"nl"] ? [self prependNumber:@"EEN"] : [self prependNumber:@"ONE"];
                break;
            case 2:
                [language isEqualToString:@"nl"] ? [self prependNumber:@"TWEE"] : [self prependNumber:@"TWO"];
                break;
            case 3:
                [language isEqualToString:@"nl"] ? [self prependNumber:@"DRIE"] : [self prependNumber:@"THREE"];
                break;
            case 4:
                [language isEqualToString:@"nl"] ? [self prependNumber:@"VIER"] : [self prependNumber:@"FOUR"];
                break;
            case 5:
                [language isEqualToString:@"nl"] ? [self prependNumber:@"VIJF"] : [self prependNumber:@"FIVE"];
                break;
            case 6:
                [language isEqualToString:@"nl"] ? [self prependNumber:@"ZES"] : [self prependNumber:@"SIX"];
                break;
            case 7:
                [language isEqualToString:@"nl"] ? [self prependNumber:@"ZEVEN"] : [self prependNumber:@"SEVEN"];
                break;
            case 8:
                [language isEqualToString:@"nl"] ? [self prependNumber:@"ACHT"] : [self prependNumber:@"EIGHT"];
                break;
            case 9:
                [language isEqualToString:@"nl"] ? [self prependNumber:@"NEGEN"] : [self prependNumber:@"NINE"];
                break;
            default:
                break;
        }
        parentcode /= 10;
    }
    while (parentcode != 0);

}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.alertViewStyle == UIAlertViewStyleDefault) {
        if (buttonIndex == 1){
            [self showParentalGate];
        }
    } else {
        if (buttonIndex == 1){
            int input = [[alertView textFieldAtIndex:0] text].intValue;
            if (input == code) {
                [[alertView textFieldAtIndex:0] resignFirstResponder];
                [[UIApplication sharedApplication] openURL: lockUrl];
            } else {
                [self showParentalGate];
            }
        }
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




