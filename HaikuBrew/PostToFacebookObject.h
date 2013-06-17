//
//  PostToFacebookObject.h
//  HaikuBrew
//
//  Created by Brian Ellison on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Haiku.h"
#import "SpinnerViewController.h"
#import "YesNoCancelViewController.h"
#import "DIsplayMessageViewController.h"
#import "DelegateMethods.h"

//@protocol PostToFacebookObjectDelegate <NSObject>
//-(void) displayMessageViewController:(NSString *) _message;
//-(void) displayMessageViewController:(NSString *) _message andPop:(NSNumber *) isPop;
//@end


@interface PostToFacebookObject : NSObject < YesNoCancelViewDelegate>
{
    int faceBookRequestType;
    BOOL isTagFriends;
}

-(id) initWithObjects:(UIImage *) imageToPublish withHaiku:(Haiku *) haikuToPublish withView:(UIView *) viewToPublishOn withNaviationController:(UINavigationController *) _theNavController withPostToWhoKnowsWhatDelegate:(NSObject<PostToWhoKnowsWhatDelegate> *) pPostToWhoKnowsWhatDelegate;
- (void) startFacebookUploadProcess;


@property (nonatomic, retain) Haiku *haiku;
@property (nonatomic, retain) UIView *view;
@property (nonatomic, retain) SpinnerViewController *spinnerViewController;
@property (nonatomic, retain) YesNoCancelViewController *yesNoCancelViewController;
@property (nonatomic, retain) DIsplayMessageViewController *displayMessageViewController;
@property (nonatomic, retain) UINavigationController *theNavController;

@property (nonatomic, retain) NSMutableArray *friendsToTag;
@property (nonatomic, retain) NSString *photoID;

@property (nonatomic, retain) NSObject<PostToWhoKnowsWhatDelegate> *postToFacebookObjectDelegate;

@end
