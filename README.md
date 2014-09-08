BrightcenterSDK-iOS-2.0
=======================

This SDK makes it easier to communicate with Brightcenter. It uses an appswitch to retrieve the student that is logged in.

##Register your appUrl
When you register or edit an assessment you can change your appUrl. your appUrl needs to be the same as your CFBundleURLSchemes. If you register your appUrl you can generate a test link on: www.brightcenter.nl/dashboard/createSdkUrl . There you can select your app and a student and your link will be generated. If you open this link on a device or simulator your app will be opened.
When the BrightcenterApp is finished it'll open your app in the same way.

## Install cocoapods

Make sure you have Ruby gem by running `gem --version`.

Install cocoapods

    $ sudo gem install cocoapods
    $ pod setup

See also: http://cocoapods.org


## To integrate this SDK into your educational app

Go to your XCode project directory and create a text file called `PodFile` with the following contents:

    platform :ios, '5.0'
    pod 'BrightCenterSDK', '~> 1.2'

Now open a terminal and change to your XCode project directory. Run the command `pod install`. That's it!
Open the generated YourApp.xcworkspace file with XCode or AppCode (instead of YourApp.xcodeproj).

### Configure the environment 
There are a few things you'll need to do before you can use the SDK.
First of all you'll have to add an CFBundleURLScheme to you {app}-info.plist file. You can do this by adding the following:

```xml
<key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>YOURAPPURLSCHEME</string>
            </array>
            <key>CFBundleURLName</key>
            <string>YOURAPPBUNDLENAME</string>
        </dict>
    </array>
```

Secondly you'll need to add a few thing in your app delegate. Add the following things to your `- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions` :

```objective-c
      BCAResultController *controller = [BCAResultController instance];
    [controller configure];
    NSURL *urlToParse = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    if (urlToParse) {
        [self application:application handleOpenURL:urlToParse];
    }
```

You'll also need to add the following function:
```objective-c
  - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    BCAAppSwitchController *appSwitchController = [BCAAppSwitchController instance];
    [appSwitchController configureWithUrl:url];
    return YES;
  }
```

This makes sure your app switch will be handled correctly.

##Make the app switch
To open the brightcenter app you can use the following(note that you must implement the AppSwitchDelegate protocol):

```objective-c
    BCAAppSwitchController *appController = [BCAAppSwitchController instance];
    appController.appSwitchDelegate = self;
    [appController openBrightcenterAppWithAssessmentId:@"YOUR ASSESSMENT ID" urlScheme:@"YOURURLSCHEME"];
```
The assessmentId can also be `@""` (empty). When the brightcenter app opens your application, the following delegate method is called:
```objective-c
- (void) appIsOpened{
  // The student is available from here you can use: 'resultController.student'
}
```
after this method is called you are able to send and retrieve results!

