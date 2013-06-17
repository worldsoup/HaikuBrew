//
//  YourBrewsViewController.h
//  HaikuBrew
//
//  Created by John Watson on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YourBrewsViewController : UIViewController <UIGestureRecognizerDelegate, UIScrollViewDelegate>
{
    NSMutableSet *recycledPages;
    NSMutableSet *visiblePages;
}

// Variables
@property (nonatomic, retain) NSMutableArray *yourHaikuBrews;
@property (retain, nonatomic) IBOutlet UIScrollView *scrlYourBrews;

//Methods
- (void) loadAllHaikus;

@end
