//
//  BCAAppDelegate.m
//  BrightcenterAppClient
//
//  Created by Rick Slot on 03/06/14.
//  Copyright (c) 2014 Trifork. All rights reserved.
//

#import "BCAAppDelegate.h"
#import "BCAResultController.h"
#import "BCAAppSwitchController.h"
@implementation BCAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    BCAResultController *controller = [BCAResultController instance];
    [controller configure];
    NSURL *urlToParse = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    if (urlToParse) {
        [self application:application handleOpenURL:urlToParse];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    BCAAppSwitchController *appSwitchController = [BCAAppSwitchController instance];
    [appSwitchController configureWithUrl:url];
    return YES;
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
