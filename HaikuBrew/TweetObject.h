//
//  TweetObject.h
//  HaikuBrew
//
//  Created by Brian Ellison on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Haiku.h"
#import "SpinnerViewController.h"
#import "YesNoCancelViewController.h"
#import "DIsplayMessageViewController.h"

@interface TweetObject : NSObject

-(id) initWithObjects:(UIImage *) imageToPublish withHaiku:(Haiku *) haikuToPublish withView:(UIView *) viewToPublishOn withNaviationController:(UINavigationController *) _theNavController;
- (void) startTweetUploadProcess;


@property (nonatomic, retain) Haiku *haiku;
@property (nonatomic, retain) UIView *view;
@property (nonatomic, retain) SpinnerViewController *spinnerViewController;
@property (nonatomic, retain) YesNoCancelViewController *yesNoCancelViewController;
@property (nonatomic, retain) DIsplayMessageViewController *displayMessageViewController;
@property (nonatomic, retain) UINavigationController *theNavController;


@end
