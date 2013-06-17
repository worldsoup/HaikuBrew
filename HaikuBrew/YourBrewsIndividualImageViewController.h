//
//  YourBrewsIndividualImageViewController.h
//  HaikuBrew
//
//  Created by Brian Ellison on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Haiku.h"
#import "UILazyImageView.h"
#import "UIImageView+WebCache.h"


@interface YourBrewsIndividualImageViewController : UIViewController <YourBrewsIndividualDelegate, UIGestureRecognizerDelegate>
@property (retain, nonatomic) IBOutlet UIImageView *imgViewDownloadingBackground;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *imageViewHaikuImage;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *imageViewFacebookUserProfileImage;
@property (retain, nonatomic) IBOutlet UIImageView *imageViewWhiteMask;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *imageViewBottomBubble;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblWaitingOn;
  

@property (nonatomic, retain) Haiku *haikuVO;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withHaiku:(Haiku *) pHaiku;
- (void) imageLoadComplete;



@end
