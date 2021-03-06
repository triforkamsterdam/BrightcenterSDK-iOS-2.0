//
//  BCAMainViewController.m
//  BrightcenterAppClient
//
//  Created by Rick Slot on 03/06/14.
//  Copyright (c) 2014 Trifork. All rights reserved.
//

#import "BCAMainViewController.h"
#import "BCALogoButton.h"

@interface BCAMainViewController ()

@property (weak, nonatomic) IBOutlet UILabel *studentLabel;
@property (nonatomic, strong) BCAResultController *resultController;
@property (nonatomic, strong) BCAAppSwitchController *appSwitchController;
@property (nonatomic, strong) BCALogoButton *logoButton;
@end

@implementation BCAMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"mainviewcontroller");
    _resultController = [BCAResultController instance];
    self.logoButton = [BCALogoButton createButtonWithDelegate:self assessmentId: nil urlScheme:@"brightcenterAppClient"];
    [self.view addSubview:self.logoButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)connectButtonClicked:(id)sender {
    _appSwitchController = [BCAAppSwitchController instance];
    _appSwitchController.appSwitchDelegate = self;
    [_appSwitchController openBrightcenterAppWithAssessmentId:@"342f6bff-44bd-4a2b-82d3-790b73c5200c" urlScheme:@"brightcenterAppClient"];
}

- (IBAction)loadResultsButtonClicked:(id)sender {
    [_resultController loadResultsForAssessment:@"342f6bff-44bd-4a2b-82d3-790b73c5200c" success:^(NSArray *results){
        NSLog(@"results are loaded");
    }failure:^(NSError *error, BOOL loginFailure){
        NSLog(@"failure with loading results");
    }];
}

- (IBAction)postResultButtonClicked:(id)sender {
    [_resultController sendResultWithScore:4.0 duration:11 completionStatus:@"INCOMPLETE" assessmentId:@"342f6bff-44bd-4a2b-82d3-790b73c5200c" questionId:@"1"
            success:^(void){
                NSLog(@"post succes");
            } failure:^(NSError *error, BOOL loginFailure){
                NSLog(@"post failure");
            }];
}
- (IBAction)connectWithoutAssessmentClicked:(id)sender {
    BCAAppSwitchController *appSwitchController = [BCAAppSwitchController instance];
    appSwitchController.appSwitchDelegate = self;
    [appSwitchController openBrightcenterAppWithAssessmentId:@"" urlScheme:@"brightcenterAppClient"];
}

- (void) appIsOpened:(NSString *) assessmentId{
    NSLog(@"app is opened");
    _studentLabel.text = [NSString stringWithFormat:@"Student: %@ %@ %@\n %@ %@", _resultController.student.firstName, _resultController.student.lastName, _resultController.student.id, _resultController.cookieString, assessmentId];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    for (UIView *subView in self.view.subviews)
    {
        if (subView.tag == 1337)
        {
            NSLog(@"removing");
            [subView removeFromSuperview];
        }
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    self.logoButton = [BCALogoButton createButtonWithDelegate:self assessmentId:nil urlScheme:@"brightcenterAppClient"];
    [self.view addSubview:self.logoButton];
    
}



@end
