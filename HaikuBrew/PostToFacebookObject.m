//
//  PostToFacebookObject.m
//  HaikuBrew
//
//  Created by Brian Ellison on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PostToFacebookObject.h"
#import "AppDelegate.h"

@implementation PostToFacebookObject


@synthesize view, haiku, spinnerViewController, yesNoCancelViewController, friendsToTag, photoID, displayMessageViewController, theNavController, postToFacebookObjectDelegate;

-(id) initWithObjects:(UIImage *) imageToPublish withHaiku:(Haiku *) haikuToPublish withView:(UIView *) viewToPublishOn withNaviationController:(UINavigationController *) _theNavController withPostToWhoKnowsWhatDelegate:(NSObject<PostToWhoKnowsWhatDelegate> *) pPostToWhoKnowsWhatDelegate
{
    self = [super init];
    if (self) {
        self.haiku = haikuToPublish;
        self.haiku.publishImageData = imageToPublish;
        self.view = viewToPublishOn;
        self.theNavController = _theNavController;
        self.postToFacebookObjectDelegate = pPostToWhoKnowsWhatDelegate;
    }
    return self;
}

- (void) startFacebookUploadProcess
{
    
   
    [self showYesNoCancel:@"Would you like to tag your friends with this post to Facebook?" withColor:[UIColor yellowColor]];
    
    
}






#pragma mark Post Final Haiku To Facebook
-(void) uploadToFacebook
{
    dispatch_async( dispatch_get_main_queue(), ^{
        self.spinnerViewController = [[SpinnerViewController alloc] initWithParentView:self.view withLabel:@"Uploading to Facebook"];
        [self.spinnerViewController showSpinnerWithMessage:@"Uploading to Facebook"];

    });
       
    
    FBRequestConnection *connection = [[FBRequestConnection alloc] init];
    
    // First request uploads the photo.
    FBRequest *request1 = [FBRequest
                           requestForUploadPhoto:self.haiku.publishImageData];
    [connection addRequest:request1
         completionHandler:
     ^(FBRequestConnection *connection, id result, NSError *error) {
         if (!error) {
         }
     }
            batchEntryName:@"photopost"
     ];
    
    
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    faceBookRequestType = 0;
    
//    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[appDelegate.facebook accessToken],@"access_token",
//                                    @"I posted this Haiku using a Beta Version of Haiku Brew. Check out HaikuBrew.com for more information.", @"message",
//                                    self.haiku.publishImageData, @"source",
//                                    nil];
//    [appDelegate.facebook requestWithGraphPath:@"me/photos" 
//                                     andParams:params
//                                 andHttpMethod:@"POST" 
//                                   andDelegate:self];
    
}


//#pragma mark -- FBRequestDelegate Event Handlers --
//-(void)requestLoading:(FBRequest *)request
//{
//    NSLog(@"RequestLoading:");
//}
//
//-(void)request:(FBRequest *)request didLoad:(id)result
//{
//    NSLog(@"RequestDidLoad:");
//    if(faceBookRequestType == 0 )
//    {
//        if(isTagFriends)
//        {
//            self.photoID = [NSString stringWithFormat:@"%@", [(NSDictionary*)result valueForKey:@"id"]];
//            faceBookRequestType = 1;
//            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//            self.friendsToTag = [[NSMutableArray alloc] initWithObjects: nil];
//            
//            if(! [appDelegate.myUserID isEqualToString:self.haiku.haikuLine1.userId])
//            {
//                if(![appDelegate.myUserID isEqualToString:self.haiku.haikuLine1.userId])
//                {
//                    // THe following commented code was in attempt to tag everyone in one full swoop... facebook appears to have issues
//                    //                    NSMutableDictionary *dictToAdd = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.haiku.haikuLine1.userId, @"tag_uid", [NSNumber numberWithInt:50],@"x",[NSNumber numberWithInt:60],@"y", nil];
//                    //                    [friendsToTag addObject: dictToAdd];
//                    [self.friendsToTag addObject:self.haiku.haikuLine1.userId];
//                    
//                    
//                }
//            }
//            if(! [appDelegate.myUserID isEqualToString:self.haiku.haikuLine2.userId])
//            {
//                if(![appDelegate.myUserID isEqualToString:self.haiku.haikuLine2.userId])
//                {
//                    [self.friendsToTag addObject:self.haiku.haikuLine2.userId];
//                }
//            }
//            if(! [appDelegate.myUserID isEqualToString:self.haiku.haikuLine3.userId])
//            {
//                if(![appDelegate.myUserID isEqualToString:self.haiku.haikuLine3.userId])
//                {
//                    [self.friendsToTag addObject:self.haiku.haikuLine3.userId];
//                }
//            }   
//            
//            if(self.friendsToTag != nil && self.friendsToTag.count > 0)
//            {
//                self.spinnerViewController.loadingLabel.text = @"Tagging";
//                NSString *friendToTag = [self.friendsToTag objectAtIndex:0];
//                NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[appDelegate.facebook accessToken],@"access_token",
//                                                nil];
//                [appDelegate.facebook requestWithGraphPath:[NSString stringWithFormat:@"%@/tags/%@", self.photoID,friendToTag ]
//                                                 andParams:params andHttpMethod:@"POST" andDelegate:self];
//                [self.friendsToTag removeObjectAtIndex:0];
//            }
//        }
//        else {
//            [self.spinnerViewController dismissSpinner];
//            [self.postToFacebookObjectDelegate displayMessageViewController:@"Brewed Haiku Posted to Facebook"];
//        }
//    }
//    else if(faceBookRequestType == 1)
//    {
//        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//        
//        if(self.friendsToTag != nil && self.friendsToTag.count > 0)
//        {
//            NSString *friendToTag = [self.friendsToTag objectAtIndex:0];
//            NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[appDelegate.facebook accessToken],@"access_token",
//                                            nil];
//            
//            [appDelegate.facebook requestWithGraphPath:[NSString stringWithFormat:@"%@/tags/%@", self.photoID,friendToTag ]
//                                             andParams:params andHttpMethod:@"POST" andDelegate:self];
//            [self.friendsToTag removeObjectAtIndex:0];
//        }
//        else{
//            [self.spinnerViewController dismissSpinner];
//            [self.postToFacebookObjectDelegate displayMessageViewController:@"Brewed Haiku Posted to Facebook"];
//        }
//    }
//    
//    
//}
//
//-(void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
//{
//    NSLog(@"RequestDidReceiveResponse:");
//    
//    
//    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
//    
//    if ([httpResponse statusCode] >= 400) {
//        NSLog(@"remote url returned error %d %@",[httpResponse statusCode],[NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]);
//        [self.spinnerViewController dismissSpinner];
//        [self.postToFacebookObjectDelegate displayMessageViewController:@"Facebook cannot be reached.  Try Later"];
//    } else {
//        // start recieving data
//        
//    }
//    
//}
//
//-(void)request:(FBRequest *)request didFailWithError:(NSError *)error
//{
//    NSLog(@"RequestDidFailWithError: %@ -- URL: %@", error.description, request.url);
//    [self.spinnerViewController dismissSpinner];
//    [self.postToFacebookObjectDelegate displayMessageViewController:@"There was a problem contacting Facebook"];
//}



- (void) dismissYesNoViewContorller
{
    
    [UIView animateWithDuration:.5
                     animations:^{
                         self.yesNoCancelViewController.view.alpha = 0.0;
                     } 
                     completion:^(BOOL finished){
                         [self.yesNoCancelViewController.view removeFromSuperview];
                         self.yesNoCancelViewController = nil;
                     }];
    
}



#pragma mark YesNoCancel Delegate methods
- (void)yesNoCancelCancel
{
    
    [self dismissYesNoViewContorller];
}

- (void)yesNoCancelYes
{
    [self dismissYesNoViewContorller];
    isTagFriends = YES;
    [self uploadToFacebook];
}

- (void)yesNoCancelNo
{
    [self dismissYesNoViewContorller];
    isTagFriends = NO;
    [self uploadToFacebook];
}

- (void)showYesNoCancel:(NSString *) message withColor:(UIColor *) theColor
{
    if(self.yesNoCancelViewController == nil)
    {
        self.yesNoCancelViewController = [[YesNoCancelViewController alloc] initWithNibName:@"YesNoCancelViewController" bundle:nil borderColor:theColor withLabelText:message withConfirmViewDelegate:self];
    }
    
    CGRect viewBounts = self.view.bounds;
    CGSize result = [[UIScreen mainScreen] bounds].size;
    viewBounts.size.height = result.height;
    self.yesNoCancelViewController.view.bounds = viewBounts;
    self.yesNoCancelViewController.view.alpha = 0;
    [self.view addSubview:self.yesNoCancelViewController.view];

    
    [UIView animateWithDuration:.5
                     animations:^{
                         self.yesNoCancelViewController.view.alpha = 1.0;
                     } 
                     completion:^(BOOL finished){
                         
                     }];
}

//-(void) displayMessageViewController:(NSString *) _message
//{
//    [self displayMessageViewController:_message andPop:[NSNumber numberWithBool:NO]];
//    
//}
//-(void) displayMessageViewController:(NSString *) _message andPop:(NSNumber *) isPop
//{
//    CGRect display = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 20.0);
//    
//    if(self.displayMessageViewController == nil)
//    {
//        self.displayMessageViewController = [[DIsplayMessageViewController alloc] initWithNibName:@"DIsplayMessageViewController" bundle:nil] ;
//        self.displayMessageViewController.view.frame = display;
//        
//        [self.displayMessageViewController.messageLabel setText:_message];
//        [self.view addSubview:self.displayMessageViewController.view];
//    }
//    self.displayMessageViewController.view.frame = display;
//    NSLog(@"isPOP = %@", isPop.boolValue?@"YES":@"NO");
//    __block NSNumber *blockIsPop = isPop;
//    NSLog(@"isPOPBlock = %@", blockIsPop.boolValue?@"YES":@"NO");
//    [self.displayMessageViewController.messageLabel setText:_message];
//    [UIView animateWithDuration:.8 
//                     animations:^{
//                         CGRect rect = self.displayMessageViewController.view.frame;
//                         rect.origin.y = self.view.frame.size.height - 44;
//                         self.displayMessageViewController.view.frame = rect;
//                         
//                         
//                         
//                     } 
//                     completion:^(BOOL finished){
//                         [self performSelector:@selector(hideMessageViewController:) withObject:blockIsPop afterDelay:1.0];
//                     }
//     ];
//}
//
//
//-(void) hideMessageViewController:(NSNumber *) isPop
//{
//    CGRect offDisplay = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 20.0);
//    NSLog(@"isPOP = %@", isPop.boolValue?@"YES":@"NO");
//    __block NSNumber *blockIsPop = isPop;
//    NSLog(@"isPOPBlock = %@", blockIsPop.boolValue?@"YES":@"NO");
//    [UIView animateWithDuration:.8 
//                     animations:^{
//                         self.displayMessageViewController.view.frame = offDisplay;
//                     } 
//                     completion:^(BOOL finished){
//                         NSLog(@"isPOPBlock = %@", blockIsPop.boolValue?@"YES":@"NO");
//                         if(blockIsPop.boolValue)
//                         {
//                             [self.theNavController popViewControllerAnimated:YES];
//                         }
//                     }
//     ];
//}




@end
