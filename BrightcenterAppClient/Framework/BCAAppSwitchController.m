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
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parentalGateUnlocked"]) {
        parentalLocked = false;
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
        } else {
            [[UIApplication sharedApplication] openURL:url];
        }
    }else{
        NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *message;
        NSString *title;
        
        if([language isEqualToString:@"nl"]){
            message = @"De Brightcenter app is niet geinstalleerd op dit apparaat. Installeer deze om Brightcenter functionaliteiten te gebruiken.";
            title = @"Waarschuwing";
        }else{
            message = @"You don't have the Brightcenter App installed on this device. Please install it to use Brightcenter functionality.";
            title = @"Warning";
        }
        
        lockUrl = [NSURL URLWithString:@"http://itunes.com/apps/brightcenter"];
        
        if ([UIAlertController class]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction: [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:NULL]];
            [alert addAction:[UIAlertAction actionWithTitle:@"Open in Appstore" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self showParentalGate];
            }]];
            UIViewController *topMostController = [self topMostController];
            [topMostController presentViewController:alert animated:TRUE completion:nil];
        } else {
            UIAlertView *alert;
            alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Open in Appstore", nil];
            [alert show];
        }
        
    }
}

- (void) showParentalGate {
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *message;
    NSString *msgString;
    NSString *back;
    NSString *cntinue;
    
    code = arc4random() % 90000 + 10000;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterSpellOutStyle];
    
    [self createCodeString];
    
    if ([language isEqualToString:@"nl"]) {
        msgString = @"Vul de onderstaande code in als getallen om door te gaan met het gebruik van Brightcenter: \n%@";
        back = @"Terug";
        cntinue = @"Doorgaan";
    } else {
        msgString = @"Enter the following code as digits to continue using Brightcenter: \n%@";
        back = @"Back";
        cntinue = @"Continue";
    }
    
    message = [NSString stringWithFormat: msgString, codeString];
    
    // iOS 8.0 and later
    if ([UIAlertController class]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Brightcenter" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Code";
            [textField setKeyboardType:UIKeyboardTypeDecimalPad];
        }];
        [alert addAction: [UIAlertAction actionWithTitle:back style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction: [UIAlertAction actionWithTitle:cntinue style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            int input = ((UITextField *)[alert.textFields objectAtIndex:0]).text.intValue;
            if (input == code) {
                [[UIApplication sharedApplication] openURL: lockUrl];
                [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"parentalGateUnlocked"];
                parentalLocked = false;
            } else {
                [self showParentalGate];
            }
        }]];
        [[self topMostController] presentViewController:alert animated:TRUE completion:nil];
   
    // iOS 7 and lower
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Brightcenter" message:message delegate:self cancelButtonTitle:@"Terug" otherButtonTitles:@"Doorgaan",nil];
        
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [[alert textFieldAtIndex:0] setDelegate:self];
        [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeDecimalPad];
        [[alert textFieldAtIndex:0] becomeFirstResponder];
        [alert show];
    }
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
                parentalLocked = false;
                [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"parentalGateUnlocked"];
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


- (UIViewController*) topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}
@end




