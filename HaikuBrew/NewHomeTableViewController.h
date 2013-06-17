//
//  NewHomeTableViewController.h
//  HaikuBrew
//
//  Created by Brian Ellison on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PullRefreshTableViewController.h"
#import "Haiku.h"
#import "GetBaseDataManager.h"
#import "PostToFacebookObject.h"
#import "PostToWhoKnowsWhat.h"

@class NewHomeViewController;

@interface NewHomeTableViewController : PullRefreshTableViewController <HideHaikuDelegate,  UIAlertViewDelegate, PostToWhoKnowsWhatDelegate>


@property (nonatomic, retain) NSMutableArray *brews;
@property (nonatomic, retain) NewHomeViewController *homeViewController;
@property (nonatomic, retain) NSIndexPath *indexPathToHide;
@property (nonatomic, retain) PostToWhoKnowsWhat *postToWhoKnowsWhat;
@property (nonatomic, retain) DIsplayMessageViewController *displayMessageViewController;
@property (nonatomic, retain) Haiku *haikuToDelete;
@property (nonatomic, retain) NSString *lastRowImagName;

@property (nonatomic, retain) UIImageView *blurredImageView;

- (void) deleteHaiku:(Haiku *) haiku;
- (void) postToFacebook:(Haiku *) haiku;


@end
