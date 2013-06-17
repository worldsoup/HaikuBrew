//
//  PostToWhoKnowsWhat.h
//  HaikuBrew
//
//  Created by Brian Ellison on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "PostToFacebookObject.h"
#import "TweetObject.h"
#import "GetBaseDataManager.h"
#import "DelegateMethods.h"



@interface PostToWhoKnowsWhat : NSObject <UIActionSheetDelegate, HideHaikuDelegate, PostToWhoKnowsWhatDelegate>

@property (nonatomic, retain) TweetObject *tweetObject;

-(id) initWithObjects:(UIImage *) imageToPublish withHaiku:(Haiku *) haikuToPublish withView:(UIView *) viewToPublishOn  withNaviationController:(UINavigationController *) _theNavController withDelegate:(NSObject<PostToWhoKnowsWhatDelegate> *) pPostToWhoKnowsWhat;
- (void) displayPostToWhoKnowsWhat;

@property (nonatomic, retain) PostToFacebookObject *postToFacebookObject;

@property (nonatomic, retain) Haiku *haiku;
@property (nonatomic, retain) UIView *view;
@property (nonatomic, retain) SpinnerViewController *spinnerViewController;
@property (nonatomic, retain) DIsplayMessageViewController *displayMessageViewController;
@property (nonatomic, retain) UINavigationController *theNavController;
@property (nonatomic, retain) NSObject<PostToWhoKnowsWhatDelegate> *postToWhoKnowsWhatDelegate;

@end
