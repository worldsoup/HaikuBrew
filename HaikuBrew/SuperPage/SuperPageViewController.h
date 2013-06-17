//
//  ViewController.h
//  ImageCapturePreviewTest
//
//  Created by John Watson on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Haiku.h"
#import "HaikuEntryPanel.h"
#import "SelectFacebookFriendViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "DIsplayMessageViewController.h"
#import "SpinnerViewController.h"
#import "GetBaseDataManager.h"
#import "YesNoCancelViewController.h"
#import "JSON.h"
#import "SBJsonParser.h"
#import "PostToFacebookObject.h"
#import "SBJsonWriter.h"
#import "TweetObject.h"
#import "PostToWhoKnowsWhat.h"
#import "DelegateMethods.h"


@interface SuperPageViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UpdateHaikuLineBrewsDelegate, ConfirmViewControllerDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate, HideHaikuDelegate, PostToWhoKnowsWhatDelegate>
{

}

@property (nonatomic, retain) Haiku *haiku;

@property (nonatomic, retain) AVCaptureSession *session;
@property (nonatomic, retain) AVCaptureDeviceInput *frontCameraInput;
@property (nonatomic, retain) AVCaptureDeviceInput *backCameraInput;

@property (strong, nonatomic) IBOutlet UIView *uivBackCameraStreamingView;
@property (strong, nonatomic) IBOutlet UIImageView *uivPreviewView;

@property (nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnPostToFacebook;

@property (nonatomic, retain) HaikuEntryPanel *haikuEntryPanel;

@property BOOL isHaikuEntryPanelShowing;
@property BOOL isShowingFrontFacingCamera;

@property BOOL isCaptureMode;
@property BOOL isEditMode;

@property (nonatomic, retain) DIsplayMessageViewController *displayMessageViewController;
@property (nonatomic, retain) SpinnerViewController *spinnerViewController;

// backToHome Button
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnBackToHome;


// TOOLBAR REFERENCES
@property (strong, nonatomic) IBOutlet UIToolbar *shareToolbar;
@property (strong, nonatomic) IBOutlet UIToolbar *takePhotoToolbar;
@property (strong, nonatomic) IBOutlet UIToolbar *confirmCancelToolbar;

// SHARE TOOLBAR ITEMS AND ACTIONS
@property (unsafe_unretained, nonatomic) IBOutlet UIBarButtonItem *shareButtonBarItem;

// TAKE PHOTO TOOLBAR ITEMS AND ACTIONS
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnTakeCancelPhoto;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnLibrary;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnToggleCamera;

// CONFIRM/CANCEL TOOLBAR ITEMS AND ACTIONS
@property (strong, nonatomic) IBOutlet UIButton *btnToggleHaikuEntryPanel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButtonBarItem;
- (IBAction)cancelImage:(id)sender;
- (IBAction)confirmImage:(id)sender;
- (IBAction)toggleHaikuEntryPanel:(id)sender;


- (IBAction)btnTakePhotoClick:(id)sender;
- (IBAction)btnToggleCameraClick:(id)sender;

// LIBRARY IMAGE ITEMS AND ACTIONS
- (IBAction)btnLibraryClick:(id)sender;
- (IBAction)cancelLibraryImage:(id)sender;
- (IBAction)confirmLibraryImage:(id)sender;
@property (unsafe_unretained, nonatomic) IBOutlet UIBarButtonItem *btnCancelLibraryImage;
@property (unsafe_unretained, nonatomic) IBOutlet UIBarButtonItem *btnConfirmLibraryImage;
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView *svLibraryPicScroller;
@property (strong, nonatomic) IBOutlet UIToolbar *libraryPreviewToolbar;
@property (strong, nonatomic) UIImagePickerController *libraryImagePicker;
@property (strong, nonatomic) UIImageView *libraryImageView;


-(void)showHaikuEntryPanel:(BOOL)show;

-(void)haikuPanelDragged:(id)sender;

- (void) setupVideoCaptureSession;

- (IBAction)pressBtnPostToFacebook:(id)sender;

- (IBAction)backToHome:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andHaiku:(Haiku*) p_haiku;


//*** IMAGE CAPTURE FUNCTIONS ***//
- (UIImage *)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect;
- (UIImage *)resizeHorizontalImage:(UIImage *)image;
- (UIImage *)fixOrientation:(UIImage *) imageToFix DoFlip:(BOOL)doflip;


@property (nonatomic, retain) NSMutableArray *friendsToTag;
@property (nonatomic, retain) NSString *photoID;



@property (nonatomic, retain) PostToWhoKnowsWhat *postToWhoKnowsWhat;

-(void) displayMessageViewController:(NSString *) _message;
-(void) displayMessageViewController:(NSString *) _message andPop:(NSNumber *) isPop;

@property (nonatomic, retain) UIImageView *imageToAdd;
@end
