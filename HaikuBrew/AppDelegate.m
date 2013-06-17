//
//  AppDelegate.m
//  HaikuBrew
//
//  Created by Brian Ellison on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "UAirship.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize homePageViewController = _homePageViewController;

//@synthesize facebook = _facebook;

@synthesize myUserID = _myUserID;
@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize haikuIDToLoad;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //Init Airship launch options
    NSMutableDictionary *takeOffOptions = [[NSMutableDictionary alloc] init];
    [takeOffOptions setValue:launchOptions forKey:UAirshipTakeOffOptionsLaunchOptionsKey];
    
    // Create Airship singleton that's used to talk to Urban Airship servers.
    // Please populate AirshipConfig.plist with your info from http://go.urbanairship.com
    [UAirship takeOff:takeOffOptions];
//
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    // saving an NSString
//    if([prefs objectForKey:@"uid"] != nil)
//    {
//            // Register for notifications
//    [[UIApplication sharedApplication]
//     registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
//                                         UIRemoteNotificationTypeSound |
//                                         UIRemoteNotificationTypeAlert)];
//    }
//    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.homePageViewController = [[NewHomeViewController alloc] initWithNibName:@"NewHomeViewController" bundle:nil];
    } else {
        self.homePageViewController = [[NewHomeViewController alloc] initWithNibName:@"NewHomeViewController" bundle:nil];
    }
    
//    self.facebook = [[Facebook alloc] initWithAppId: @"149371725183092" andDelegate:nil];
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    if( [defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"] )
//    {
//        self.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
//        self.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];                                
//    }
//
    
    
    //    [self.facebook requestWithGraphPath:@"me" andDelegate:self];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.homePageViewController];
    [navController setNavigationBarHidden:YES];
    
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    return YES;

}


- (void)applicationWillTerminate:(UIApplication *)application {
    
    [UAirship land];
    // FBSample logic
    // if the app is going away, we close the session if it is open
    // this is a good idea because things may be hanging off the session, that need
    // releasing (completion block, etc.) and other components in the app may be awaiting
    // close notification in order to do cleanup
    [self.session close];
}

#pragma mark -- Facebook SSO Redirect Handlers --
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
//    return [self.facebook handleOpenURL:url];
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:self.session];
}



#pragma mark -- FBRequestDelegate Event Handlers --
//-(void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
//{
//    NSLog(@"requestdidReceiveResponse:");
//}
//
//-(void)requestLoading:(FBRequest *)request
//{
//    NSLog(@"requestLoading:");
//}
//
//-(void)request:(FBRequest *)request didLoad:(id)result
//{
//    NSLog(@"requestdidLoad:");
//}
//
//-(void)request:(FBRequest *)request didLoadRawResponse:(NSData *)data
//{
//    NSLog(@"requestdidLoadRawResponse:");
//}
//
//-(void)request:(FBRequest *)request didFailWithError:(NSError *)error
//{
//    NSLog(@"requestdidFailWithError:");
//}


#pragma mark -- Standard App Delegate --
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    // FBSample logic
    // We need to properly handle activation of the application with regards to SSO
    //  (e.g., returning from iOS 6.0 authorization dialog or from fast app switching).
    [FBAppCall handleDidBecomeActiveWithSession:self.session];
}




- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Updates the device token and registers the token with UA
//    [[UAirship shared] registerDeviceToken:deviceToken];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // saving an NSString
    if([prefs objectForKey:@"uid"] != nil && ![[prefs objectForKey:@"uid"] isEqualToString:@""])
    {
        FacebookUser *user = [[FacebookUser alloc] init];
        [user setUserId:[prefs objectForKey:@"uid"]];
        NSString * tokenAsString = [[[deviceToken description] 
                                    stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] 
                                   stringByReplacingOccurrencesOfString:@" " withString:@""];
        [user setPushToken:tokenAsString];
        [[DataManager getDataManager] registerDevice:user];
    }
}


//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
//{
//    
//    self.haikuIDToLoad = [userInfo objectForKey:@"haikuId"];
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//    if ( application.applicationState == UIApplicationStateActive )
////    {
////        NSLog(@"STATE AcTIVE %@", userInfo);
////    }
////    else
////    { 
//        
//        
//        if(self.haikuIDToLoad != nil && ![self.haikuIDToLoad isEqualToString:@""])
//        {
//            for(int i =0; i < self.homePageViewController.allBrews.count; i++)
//            {
//                [self.homePageViewController refresh];
//                Haiku *haikuToLoad = [self.homePageViewController.allBrews objectAtIndex:i];
//                if([haikuToLoad.haikuId isEqualToString:self.haikuIDToLoad])
//                {
//                    NSLog(@"PUSHED VALUE");
//                    SuperPageViewController *viewController = [[SuperPageViewController alloc] initWithNibName:@"SuperPageViewController" bundle:nil andHaiku:haikuToLoad];
//                    [self.homePageViewController.navigationController pushViewController:viewController animated:YES];
//                }
//            }
//            self.haikuIDToLoad = nil;
//        }
//        
////    }
//           
//}



@end
