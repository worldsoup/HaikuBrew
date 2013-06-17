//
//  HaikuBrewHomePageTableViewController.h
//  HaikuBrew
//
//  Created by Brian Ellison on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetBaseDataManager.h"
#import "PullRefreshTableViewController.h"
@class HomePageViewController;

@interface HaikuBrewHomePageTableViewController : PullRefreshTableViewController <GetHaikuBrewsDelegate, HideHaikuDelegate>


@property (nonatomic, retain) NSMutableArray *allBrews;
@property (nonatomic, retain) NSMutableArray *inboxBrews;
@property (nonatomic, retain) NSMutableDictionary *brewsByBrewingAndBrewed;
@property (nonatomic, retain) HomePageViewController *homePageViewController;

@property (nonatomic, retain) NSIndexPath *indexPathToHide;

- (void) recategorizeBrewedAndBrewing;



@end
