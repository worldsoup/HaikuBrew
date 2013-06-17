//
//  YourBrewsIndividualImageViewController.m
//  HaikuBrew
//
//  Created by Brian Ellison on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YourBrewsIndividualImageViewController.h"
#import <objc/runtime.h>
#import "SuperPageViewController.h"
#import "AppDelegate.h"
#import "HBImageHelper.h"

@interface YourBrewsIndividualImageViewController ()

@end

@implementation YourBrewsIndividualImageViewController
@synthesize imgViewDownloadingBackground;
@synthesize imageViewHaikuImage;
@synthesize imageViewFacebookUserProfileImage;
@synthesize imageViewWhiteMask;
@synthesize imageViewBottomBubble;
@synthesize lblWaitingOn;
@synthesize haikuVO;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withHaiku:(Haiku *) pHaiku
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.haikuVO = pHaiku;
    }
    return self;
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
  
    
    
    if([self.haikuVO isBrewing])
    {
        [self.imageViewWhiteMask setHidden:NO];
        [self.imageViewFacebookUserProfileImage setHidden:NO];
        [self.lblWaitingOn setText:[NSString stringWithFormat:@"Waiting on %@", self.haikuVO.getNextUserFirstName]];
        [self.lblWaitingOn setHidden:NO];
        [self.imageViewBottomBubble setHidden:NO];
                
    }
    else {
        [self.imageViewWhiteMask setHidden:YES];
        [self.imageViewFacebookUserProfileImage setHidden:YES];
    }
    
    [self loadImages];
}

- (void) loadImages
{
    NSLog(@"Load Images");
    NSURL *url = [NSURL URLWithString:haikuVO.backGroundImage];
    
    if([self isViewLoaded] && self.view.window)
    {
        NSLog(@"Showing");
    }
    else {
        NSLog(@"NOOOOOT Showing");
    }
    
    
//    self.imageViewHaikuImage = [[UILazyImageView alloc] initWithURL:url withDelegate:self];
    
    [self.imageViewHaikuImage setImageWithURL:url];
   NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", [self.haikuVO getNextUserId]]];
      [self.imageViewFacebookUserProfileImage setImageWithURL:url2];
    
//    if(self.haikuVO.backGroundImage.length > 8)
//    {
//        [[HBImageHelper sharedInstance] getImageWithURLString:self.haikuVO.backGroundImage forImageView:self.imageViewHaikuImage withSuccessBlock:^(UIImage *image) {
//            self.imageViewHaikuImage.image = image;
//            self.imageViewHaikuImage.hidden = NO;
//        } withFailureBlock:^(NSError *error) {
//            NSLog(@"failed to get image with error = [%@]", error);
//        }];
//    }
//
//
//     
//    if([self.haikuVO getNextUserId] != nil)
//    {
//        [[HBImageHelper sharedInstance] 
//         getImageForFacebookFriend:[self.haikuVO getNextUserId] 
//         forImageView:self.imageViewFacebookUserProfileImage 
//         withSize:NMIMAGE_SIZE_SQUARE
//         withSuccessBlock:^(UIImage *image) {
//             self.imageViewFacebookUserProfileImage.image = image;
//             self.imageViewFacebookUserProfileImage.hidden = NO;
//         } withFailureBlock:^(NSError *error) {
//             NSLog(@"failed to get image with error = [%@]", error);
//         }]; 
//    }


    
}


- (void) imageLoadComplete
{
    [self.view reloadInputViews];
}

- (void)viewDidUnload
{
    [self setImgViewDownloadingBackground:nil];
    [self setImageViewHaikuImage:nil];
    [self setImageViewFacebookUserProfileImage:nil];
    [self setImageViewWhiteMask:nil];
    [self setImageViewBottomBubble:nil];
    [self setLblWaitingOn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)pressBtnHideHaiku:(id)sender {
    NSLog(@"Hike Button Pressed");
}
@end
