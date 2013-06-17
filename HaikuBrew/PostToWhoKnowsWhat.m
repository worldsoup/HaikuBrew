//
//  PostToWhoKnowsWhat.m
//  HaikuBrew
//
//  Created by Brian Ellison on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PostToWhoKnowsWhat.h"
#import "HaikuEntryPanel.h"
#import "NewHomeViewController.h"
#import "SuperPageViewController.h"

@implementation PostToWhoKnowsWhat
@synthesize  tweetObject, haiku, theNavController,view, spinnerViewController, displayMessageViewController, postToWhoKnowsWhatDelegate, postToFacebookObject;

-(id) initWithObjects:(UIImage *) imageToPublish withHaiku:(Haiku *) haikuToPublish withView:(UIView *) viewToPublishOn  withNaviationController:(UINavigationController *) _theNavController withDelegate:(NSObject<PostToWhoKnowsWhatDelegate> *) pPostToWhoKnowsWhat
{
    self = [super init];
    if (self) {
        self.haiku = haikuToPublish;
        self.view = viewToPublishOn;
        self.theNavController = _theNavController;
        self.postToWhoKnowsWhatDelegate = pPostToWhoKnowsWhat;
    }
    return self;
}


- (void) displayPostToWhoKnowsWhat
{
    
    if(self.haiku.backGroundImageData == nil)
    {
        [self.postToWhoKnowsWhatDelegate displayMessageViewController:@"Please wait for image to load"];
    }
    else {
        [self performSelectorInBackground:@selector(loadFinalImage) withObject:nil];
        
        UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Share Your Brewed Haiku" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Haiku" otherButtonTitles:@"Save", @"Tweet",@"Post to Facebook", nil];
        popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [popupQuery showInView:self.view];
    }

    
}

- (void) loadFinalImage
{
    self.haiku.publishImageData = [self getFinalizedSnapshotImage];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
        
        UIAlertView *replay = [[UIAlertView alloc] initWithTitle:@"Confirm Delete Haiku" message:@"Are you sure you want to delete this Haiku?" 
                                                        delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
        
        [replay show];
        
	} else if (buttonIndex == 1) {
		[self savePhoto];
	} else if (buttonIndex == 2) {
        self.tweetObject = [[TweetObject alloc] initWithObjects:[self getFinalizedSnapshotImage] withHaiku:self.haiku withView:self.view withNaviationController:self.theNavController];
        
        [self.tweetObject startTweetUploadProcess];
        
	} else if (buttonIndex == 3) {
        //        NSString *tagString = [NSString stringWithFormat:@"Would you like to tag your friends with 
        
        self.postToFacebookObject = [[PostToFacebookObject alloc] initWithObjects:[self getFinalizedSnapshotImage] withHaiku:self.haiku withView:self.view withNaviationController:self.theNavController withPostToWhoKnowsWhatDelegate:self.postToWhoKnowsWhatDelegate];
        
        [self.postToFacebookObject performSelector:@selector(startFacebookUploadProcess)];
        
        
	} else if (buttonIndex == 4) {
		NSLog(@"Cancel Button Clicked");
	}
}


#pragma mark Save Image
- (void) savePhoto
{
    
    // Request to save the image to camera roll
    UIImageWriteToSavedPhotosAlbum(self.haiku.publishImageData, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error 
  contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL)
    {
        // Show error message...
        [self.postToWhoKnowsWhatDelegate displayMessageViewController:@"Image was not saved to phone"];
    }
    else  // No errors
    {
        [self.postToWhoKnowsWhatDelegate displayMessageViewController:@"Image Saved To Phone"];
    }
}

//
//#pragma mark Send Email
//- (void) sendEmail
//{
//    self.haiku.publishImageData = [self getFinalizedSnapshotImage];
//    
//    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
//    picker.mailComposeDelegate = self;
//    
//    // Set the subject of email
//    [picker setSubject:[NSString stringWithFormat: @"HaikuBrew - %@.png", self.haiku.title]];
//    
//    // Add email addresses
//    // Notice three sections: "to" "cc" and "bcc"	
//    //    [picker setToRecipients:[NSArray arrayWithObjects:@"emailaddress1@domainName.com", @"emailaddress2@domainName.com", nil]];
//    
//    // Fill out the email body text
//    NSString *emailBody = @"I created this Haiku using a Beta Version of Haiku Brew. Check out HaikuBrew.com for more information.";
//    
//    // This is not an HTML formatted email
//    [picker setMessageBody:emailBody isHTML:NO];
//    
//    // Create NSData object as PNG image data from camera image
//    //    NSData *data = UIImagePNGRepresentation(image);
//    
//    // Attach image data to the email
//    // 'CameraImage.png' is the file name that will be attached to the email
//    NSData *image = UIImagePNGRepresentation(self.haiku.publishImageData);
//    [picker addAttachmentData:image mimeType:@"image/png" fileName:[NSString stringWithFormat: @"HaikuBrew - %@.png", self.haiku.title]];
//    
//    // Show email view	
//    [self presentModalViewController:picker animated:YES];
//}
//
//- (void)mailComposeController:(MFMailComposeViewController*)controller  
//          didFinishWithResult:(MFMailComposeResult)result 
//                        error:(NSError*)error;    
//{
//    if (result == MFMailComposeResultSent) {
//        NSLog(@"It's away!");
//        [self dismissModalViewControllerAnimated:YES];
//        [self displayMessageViewController:@"Email Sent"];
//    }
//    else {
//        {   
//            [self dismissModalViewControllerAnimated:YES];
//            [self displayMessageViewController:@"Email Send Failed"];
//        }
//    }
//    
//    
//}


- (UIImage*) getFinalizedSnapshotImage {

    UIImageView *borderImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 340, 335)];
    [borderImage setImage:[UIImage imageNamed:@"HorizontalScrollBackground.png"]];
    UIImageView *image = [[UIImageView alloc] initWithImage:self.haiku.backGroundImageData];
    [image setFrame:CGRectMake(9, 4, 320, 320)];
    UIImageView *waterMarkImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"watermark.png"]];
    // watermark is 52 wide and 16 tall
    [waterMarkImage setFrame:CGRectMake(170-26, 15, 52, 16)];
    
    HaikuEntryPanel *panel = [[HaikuEntryPanel alloc] initWithNibName:@"HaikuEntryPanel" bundle:nil haiku:self.haiku];
    CGRect panelFrame = panel.view.frame;
    panelFrame.origin.y = [self.haiku.yPosition intValue] - 47;
    panelFrame.origin.x =19;
    panel.view.frame = panelFrame;
    [image addSubview:panel.view];
    [borderImage addSubview:image];
    
    [borderImage addSubview:waterMarkImage];
    UIGraphicsBeginImageContext(borderImage.bounds.size);
    [borderImage.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    image = nil;
    borderImage = nil;
    return img;
}





#pragma mark UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // NO = 0, YES = 1
    if(buttonIndex == 0)
    {
        return;
    }
    else {
        self.spinnerViewController = [[SpinnerViewController alloc] initWithParentView:self.view withLabel:@"Deleting Haiku"];
        [self.spinnerViewController showSpinnerWithMessage:@"Deleting Haiku"];
		GetBaseDataManager *getBaseDataManager = [[GetBaseDataManager alloc] init];
        [getBaseDataManager setHideHaikuDelegate:self];
        [getBaseDataManager hideHaiku:self.haiku];
    }
}




#pragma mark Hide Haiku Delegate Methods
-(void)hideHaikuDidFail
{
    NSLog(@"Hide Failed");
    [self.spinnerViewController dismissSpinner];
}

- (void)hideHaikuDidStart
{
    
    NSLog(@"Hide Started");
    
}

- (void)hideHaikuDidComplete
{
    
    [self.spinnerViewController dismissSpinner];
    
    
    
        
    for (id theView in self.theNavController.viewControllers) {
        if( [theView isKindOfClass:[NewHomeViewController class]] )
        {
            [self.postToWhoKnowsWhatDelegate displayMessageViewController:@"Haiku Deleted" andPop:[NSNumber numberWithBool:YES]];
            
            
            NewHomeViewController *newHomeVC = ((NewHomeViewController *)theView);
            [newHomeVC removeHaikuFromBrewedHaikus:self.haiku];
            break;
        }
       
    }
}


- (void)displayMessageViewController:(NSString *)_message
{
    [self.postToWhoKnowsWhatDelegate displayMessageViewController:_message];
}

- (void)displayMessageViewController:(NSString *)_message andPop:(NSNumber *)isPop
{
    [self.postToWhoKnowsWhatDelegate displayMessageViewController:_message andPop:isPop];
}

@end
