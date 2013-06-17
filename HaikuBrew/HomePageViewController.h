//
//  HomePageViewController.h
//  HaikuBrew
//
//  Created by John Watson on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetBaseDataManager.h"
#import "FacebookLoginViewController.h"
#import "SpinnerViewController.h"
#import "HaikuBrewHomePageTableViewController.h"
#import "YourBrewsViewController.h"
#include "SuperPageViewController.h"
#include "Reachability.h"
#import "BrewingHeader_iPhoneViewController.h"
#import "PostToFacebookObject.h"

@class HaikuBrewHomePageTableViewController;

@interface HomePageViewController : UIViewController <  LoginViewDelegate> {
    UIActivityIndicatorView *activityIndicator;
    UITableView *tableView;
    UIButton *refreshButton;
    
    
}


- (IBAction)btnAddClick:(id)sender;

@property (nonatomic, retain) PostToFacebookObject *postToFacebook;


@property double needsRefresh;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *btnPostToWall;
- (IBAction)pressedPostToWall:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnAdd;
@property (strong, nonatomic) IBOutlet UIImageView *imgTitleBar;


@property (nonatomic, retain) UIImage *needsAttentionImage;
@property (nonatomic, retain) UIImage *inProgressImage;
@property (strong, nonatomic) IBOutlet UIButton *refreshButton;
@property (nonatomic, retain) UIImage *brewedImage;
@property (nonatomic, retain) HaikuBrewHomePageTableViewController *haikuBrewTableViewController;
@property (nonatomic, retain) YourBrewsViewController *yourBrewsViewController;

@property (nonatomic, retain) SpinnerViewController *spinnerViewController;

@property (nonatomic, retain) Reachability *internetReachable;
@property (nonatomic, retain) Reachability *hostReachable;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblBrewInboxCount;

@property (nonatomic, retain) Haiku *haiku;

- (NSDictionary *) parseURLParams:(NSString *)query;

- (void) showSpinnerWithMessage:(NSString *) message;
- (void) dismissSpinner;

-(void) setYourBrewsHaikus:(NSMutableArray *) pYourBrewHaikus;

@property (unsafe_unretained, nonatomic) IBOutlet BrewingHeader_iPhoneViewController *viInboxHeaderView;

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnLogout;
- (IBAction)pressBtnLogout:(id)sender;

@end
