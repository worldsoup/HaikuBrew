//
//  AppDelegate.h
//  HaikuBrew
//
//  Created by Brian Ellison on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageViewController.h"
#import "NewHomeViewController.h"
#import <FacebookSDK/FacebookSDK.h>
@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NewHomeViewController *homePageViewController;


@property (strong, nonatomic) NSString *myUserID;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;

@property (nonatomic, retain) NSString *haikuIDToLoad;

@property (strong, nonatomic) FBSession *session;


@end
