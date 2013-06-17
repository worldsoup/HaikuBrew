//
//  NewHomeViewController.h
//  HaikuBrew
//
//  Created by Brian Ellison on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetBaseDataManager.h"
#import "NewHomeTableViewController.h"
#import "FacebookLoginViewController.h"
#import "SpinnerViewController.h"
#import "SuperPageViewController.h"

@interface NewHomeViewController : UIViewController <UIGestureRecognizerDelegate, GetHaikuBrewsDelegate, UIScrollViewDelegate, LoginViewDelegate>


//Views

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *ivPointer;
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView *visScrollView;


//Labels
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblInboxCount;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *viInbox;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *viOutbox;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *viBrewed;





//Variables
@property (nonatomic, retain) NSMutableArray *allBrews;

// Table View Controllers
@property (nonatomic, retain) NewHomeTableViewController *inboxTable;
@property (nonatomic, retain) NewHomeTableViewController *outboxTable;
@property (nonatomic, retain) NewHomeTableViewController *brewedTable;

@property (nonatomic, retain) SpinnerViewController *spinner;

@property (nonatomic, retain) SuperPageViewController *superPageViewController;

//Actions
- (IBAction)pressBtnNewHaiku:(id)sender;
- (IBAction)pressBtnLogout:(id)sender;

//Methods
-(void) refresh;
- (void) showMessageWithText:(NSString *) textToDisplay;
- (void) dismissLoadingView;

- (void) recategorizeBrewedAndBrewing;
- (void) updateLabels;
- (void) refreshTables;
- (void) updateHaikuInStack:(Haiku *) haikuToUpdate;
- (void) addHaikuToStack:(Haiku *) haikuToAdd;
- (void) removeHaikuFromBrewedHaikus:(Haiku *) haikuToDelete;

@end


