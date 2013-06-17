//
//  TweetObject.m
//  HaikuBrew
//
//  Created by Brian Ellison on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TweetObject.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "HaikuEntryPanel.h"

@implementation TweetObject



@synthesize view, haiku, spinnerViewController, yesNoCancelViewController, displayMessageViewController, theNavController;

-(id) initWithObjects:(UIImage *) imageToPublish withHaiku:(Haiku *) haikuToPublish withView:(UIView *) viewToPublishOn  withNaviationController:(UINavigationController *) _theNavController
{
    self = [super init];
    if (self) {
        self.haiku = haikuToPublish;
        self.haiku.publishImageData = imageToPublish;
        self.view = viewToPublishOn;
        self.theNavController = _theNavController;
    }
    return self;
}

- (void) startTweetUploadProcess
{
    
    if(self.haiku.backGroundImageData == nil)
    {
        [self displayMessageViewController:@"Please wait for image to load"];
    }
    else {
        self.spinnerViewController = [[SpinnerViewController alloc] initWithParentView:self.view withLabel:@"Tweeting"];
        [self.spinnerViewController showSpinnerWithMessage:@"Tweeting"];

                                     
        
        
        Class twClass = NSClassFromString(@"TWTweetComposeViewController");
        if (!twClass) // Framework not available, older iOS
            return;

        TWTweetComposeViewController* twc = [[TWTweetComposeViewController alloc] init];
        [twc addURL:[NSURL URLWithString:@"http://www.haikubrew.com/"]];
        [twc addImage:self.haiku.publishImageData];
        [twc setInitialText:@"#HaikuBrew"];
        
        
        twc.completionHandler = ^(TWTweetComposeViewControllerResult result) 
        {
            NSString *msg; 
            
            if (result == TWTweetComposeViewControllerResultCancelled)
                msg = @"Haiku Tweeted";
            else if (result == TWTweetComposeViewControllerResultDone)
            {
                msg = @"Haiku Tweeted.";
                [self displayMessageViewController:msg];
            }
            
            
            [self.spinnerViewController dismissSpinner];
            

            // Dismiss the controller
            [self.theNavController dismissModalViewControllerAnimated:YES];
        };
        
        
        [self.theNavController presentViewController:twc animated:YES completion:^{
            // Optional
            
        }];
        
        
    }
    
}




-(void) displayMessageViewController:(NSString *) _message
{
    [self displayMessageViewController:_message andPop:[NSNumber numberWithBool:NO]];
    
}
-(void) displayMessageViewController:(NSString *) _message andPop:(NSNumber *) isPop
{
    CGRect display = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 44.0);
  
    if(self.displayMessageViewController == nil)
    {
        self.displayMessageViewController = [[DIsplayMessageViewController alloc] initWithNibName:@"DIsplayMessageViewController" bundle:nil] ;
        self.displayMessageViewController.view.frame = display;
        
        [self.displayMessageViewController.messageLabel setText:_message];
        [self.view addSubview:self.displayMessageViewController.view];
    }
    self.displayMessageViewController.view.frame = display;
    NSLog(@"isPOP = %@", isPop.boolValue?@"YES":@"NO");
    __block NSNumber *blockIsPop = isPop;
    NSLog(@"isPOPBlock = %@", blockIsPop.boolValue?@"YES":@"NO");
    [self.displayMessageViewController.messageLabel setText:_message];
    [UIView animateWithDuration:.8 
                     animations:^{
                         CGRect rect = self.displayMessageViewController.view.frame;
                         rect.origin.y = self.view.frame.size.height - self.displayMessageViewController.view.frame.size.height;
                         self.displayMessageViewController.view.frame = rect;
                         
                         
                         
                     } 
                     completion:^(BOOL finished){
                         [self performSelector:@selector(hideMessageViewController:) withObject:blockIsPop afterDelay:1.0];
                     }
     ];
}


-(void) hideMessageViewController:(NSNumber *) isPop
{
    CGRect offDisplay = CGRectMake(0, self.view.frame.size.height + 30, self.view.frame.size.width, 20.0);
    NSLog(@"isPOP = %@", isPop.boolValue?@"YES":@"NO");
    __block NSNumber *blockIsPop = isPop;
    NSLog(@"isPOPBlock = %@", blockIsPop.boolValue?@"YES":@"NO");
    [UIView animateWithDuration:.8 
                     animations:^{
                         self.displayMessageViewController.view.frame = offDisplay;
                     } 
                     completion:^(BOOL finished){
                         NSLog(@"isPOPBlock = %@", blockIsPop.boolValue?@"YES":@"NO");
                         if(blockIsPop.boolValue)
                         {
                             [self.theNavController popViewControllerAnimated:YES];
                         }
                     }
     ];
}



@end
