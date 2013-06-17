//
//  FacebookLoginViewController.h
//  HaikuBrew
//
//  Created by Brian Ellison on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@protocol LoginViewDelegate <NSObject>
@optional
- (void) facebookLoginSuccessful; // called when a registration is complete
@end


@interface FacebookLoginViewController : UIViewController < UIScrollViewDelegate>
{
    NSObject<LoginViewDelegate> *loginViewDelegate;
}
@property (retain, nonatomic) IBOutlet UIScrollView *scrlTutorial;
@property (retain, nonatomic) IBOutlet UIPageControl *pageControl;

@property (retain, nonatomic) IBOutlet NSObject<LoginViewDelegate> *loginViewDelegate;

@property (retain, nonatomic) IBOutlet UIButton *btnFacebookLogin;
- (IBAction)touchFacebookLogin:(id)sender;

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;

@end
