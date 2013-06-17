//
//  SelectFacebookFriendViewController.h
//  HaikuBrew
//
//  Created by Brian Ellison on 3/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookUser.h"
#import "UIImageView+WebCache.h"
#import "SpinnerViewController.h"
#import "GetBaseDataManager.h"
#import "ConfirmViewController.h"
#import <QuartzCore/QuartzCore.h>


typedef enum apiCall {
    kAPILogout,
    kAPIGraphUserPermissionsDelete,
    kDialogPermissionsExtended,
    kDialogRequestsSendToMany,
    kAPIGetAppUsersFriendsNotUsing,
    kAPIGetAppUsersFriendsUsing,
    kAPIFriendsForDialogRequests,
    kDialogRequestsSendToSelect,
    kAPIFriendsForTargetDialogRequests,
    kDialogRequestsSendToTarget,
    kDialogFeedUser,
    kAPIFriendsForDialogFeed,
    kDialogFeedFriend,
    kAPIGraphUserPermissions,
    kAPIGraphMe,
    kAPIGraphUserFriends,
    kDialogPermissionsCheckin,
    kDialogPermissionsCheckinForRecent,
    kDialogPermissionsCheckinForPlaces,
    kAPIGraphSearchPlace,
    kAPIGraphUserCheckins,
    kAPIGraphUserPhotosPost,
    kAPIGraphUserVideosPost,
} apiCall;

typedef enum successFailureCode {
    kSuccessAllComplete,
    kSuccessBrewingComplete
} successFailureCode;


@interface SelectFacebookFriendViewController : UIViewController <
UITableViewDataSource,
UITableViewDelegate, CreateHaikuBrewsDelegate, UpdateHaikuLineBrewsDelegate, ConfirmViewControllerDelegate>
{
    int currentAPICall;
    int currentSuccessFailureCode;
    int selectedSegmentIndex;
    Boolean saveToServerSuccess;
    Boolean postToFacebookSuccess;
}

@property (nonatomic, retain) NSMutableArray *friendsNotUsingAppList;
@property (nonatomic, retain) NSMutableArray *friendsUsingAppList;
@property (nonatomic, retain) FacebookUser *selectedUser;
@property (nonatomic, retain) Haiku *haiku;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UIButton *btnNext;
@property (strong, nonatomic) IBOutlet UILabel *lblHaikuTo;
@property Boolean isUpdate;
@property (nonatomic, retain) ConfirmViewController *confirmViewController;
@property (nonatomic, retain) UIImageView *blurredImageView;

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet UIButton *btnFriendsWithApp;
@property (nonatomic, retain) IBOutlet UIButton *btnFriendsWithoutApp;
@property (nonatomic, retain) IBOutlet UIButton *btnShareToWall;

@property (nonatomic, retain) SpinnerViewController *spinnerViewController;

@property (nonatomic, retain) NSMutableArray *searchedTableData;

//@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControlInviteFriends;
//- (IBAction)segmentedControlInviteFriendsValueChanged:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andHaiku:(Haiku *)_haiku;

- (IBAction)touchCancelButton:(id)sender;
- (IBAction)touchNextButton:(id)sender;

- (void) showLoadingWithLabel:(NSString *) label;
- (void) dismissLoading;

- (void)sendToNewUser:(FacebookUser *)user ;
- (void)submitHaiku;
- (void)friendSelected:(FacebookUser *)user;

- (void)showConfirmMessage:(NSString *) message withColor:(UIColor *) theColor;
- (void) dismissConfirmMessage;
- (NSMutableArray *) getCurrentListOfFriends;


@property (strong, nonatomic) IBOutlet UIButton *btnPlay;
@property (strong, nonatomic) IBOutlet UIButton *btnInvite;


- (IBAction)pressBtnPlay:(id)sender;
- (IBAction)pressBtnInvite:(id)sender;


- (void) reloadFriendsFromFacebook;

@end
