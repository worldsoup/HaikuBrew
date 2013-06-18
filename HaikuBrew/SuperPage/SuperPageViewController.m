//
//  ViewController.m
//  ImageCapturePreviewTest
//
//  Created by John Watson on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SuperPageViewController.h"
#import "AppDelegate.h"
#import "ScreenCapture.h"

@implementation SuperPageViewController
@synthesize shareToolbar;
@synthesize shareButtonBarItem;
@synthesize btnBackToHome;
@synthesize displayMessageViewController;
@synthesize spinnerViewController;
@synthesize haiku;
@synthesize friendsToTag, photoID;

@synthesize btnCancelLibraryImage;
@synthesize btnConfirmLibraryImage;
@synthesize svLibraryPicScroller;
@synthesize libraryPreviewToolbar;
@synthesize libraryImagePicker;
@synthesize libraryImageView;

@synthesize session;
@synthesize frontCameraInput;
@synthesize backCameraInput;

@synthesize uivBackCameraStreamingView;
@synthesize uivPreviewView;

@synthesize btnToggleHaikuEntryPanel;

@synthesize stillImageOutput;
@synthesize btnTakeCancelPhoto;
@synthesize btnLibrary;
@synthesize btnToggleCamera;

@synthesize takePhotoToolbar;
@synthesize confirmCancelToolbar;
@synthesize btnPostToFacebook;

@synthesize haikuEntryPanel;

@synthesize isHaikuEntryPanelShowing;
@synthesize isShowingFrontFacingCamera;

@synthesize isCaptureMode;
@synthesize isEditMode;

@synthesize postToWhoKnowsWhat;
@synthesize imageToAdd;
const int HAIKU_ENTRY_PANEL_HIDE_Y_POS = 500;
const int HAIKU_ENTRY_PANEL_HIDE_X_POS = 10;

const int HAIKU_ENTRY_PANEL_SHOW_Y_POS = 100;
const int HAIKU_ENTRY_PANEL_SHOW_X_POS = 10;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning]; 
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andHaiku:(Haiku*) p_haiku
{
    self = [super init];
    
    if (self) {
        if( self.haikuEntryPanel == nil )
        {
            self.haiku = p_haiku != nil ? p_haiku : [[Haiku alloc] init];
            self.haikuEntryPanel = [[HaikuEntryPanel alloc] initWithNibName:@"HaikuEntryPanel" bundle:nil haiku:self.haiku];
        }
        
        //see what kind of state we are in
        self.isCaptureMode = [self.haiku getNextHaikuLineNumber] == 1; //if WE are creating the first line, we are allowed to take a picture!
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSLog(@"Next User ID: %@", [self.haiku getNextUserId]);
        self.haikuEntryPanel.isEditMode = self.isEditMode = [[self.haiku getNextUserId] isEqualToString:appDelegate.myUserID];
        NSLog(@"App Delegate myUserID: %@", appDelegate.myUserID);
        NSLog(@"Are they equal? %@", [[self.haiku getNextUserId] isEqualToString:appDelegate.myUserID] ? @"YES" : @"NO");
        NSLog(@"self.isEditMode: %@", self.isEditMode ? @"YES" : @"NO");
        
        
    }
    
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
        
    [self initButtonIcons];

    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [[UIToolbar appearance] setBackgroundImage:[UIImage imageNamed:@"toolbar 23-07-23-813.png"] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
    
    //this removes the white background from the "Toggle" button in the top right corner
    CALayer *layer = btnToggleCamera.layer;
    layer.backgroundColor = [[UIColor clearColor] CGColor];
    layer.borderColor = [[UIColor darkGrayColor] CGColor];
    layer.cornerRadius = 8.0f;
    layer.borderWidth = 1.0f;
    
    // Moved from View Did Appear
    self.isHaikuEntryPanelShowing = NO;
    self.isShowingFrontFacingCamera = NO; //FRONT FACING CAMERA IS THE ONE LOOKING AT *YOU*! BACK IS THE OTHER ONE :P
    
    //*** SETUP THE HAIKU ENTRY PANEL ***//  
    //    self.haikuEntryPanel.view.frame = CGRectMake(HAIKU_ENTRY_PANEL_HIDE_X_POS, HAIKU_ENTRY_PANEL_HIDE_Y_POS, 300, 126);
    
    //,kl
//    if(self.haiku.yPosition.intValue == 0 && !isEditMode)
//    {
//        self.haiku.yPosition = [NSNumber numberWithInt:HAIKU_ENTRY_PANEL_SHOW_Y_POS];
//    }
    NSLog(@"YPOS : %i", self.haiku.yPosition.intValue);
    if(self.haiku.yPosition  != nil && self.haiku.yPosition.intValue != 0)
    {
        self.haikuEntryPanel.view.frame = CGRectMake(HAIKU_ENTRY_PANEL_HIDE_X_POS, self.haiku.yPosition.intValue, self.haikuEntryPanel.view.frame.size.width, self.haikuEntryPanel.view.frame.size.height);
    }
    else {
        self.haikuEntryPanel.view.frame = CGRectMake(HAIKU_ENTRY_PANEL_HIDE_X_POS, HAIKU_ENTRY_PANEL_HIDE_Y_POS, self.haikuEntryPanel.view.frame.size.width, self.haikuEntryPanel.view.frame.size.height);
    }
    
    [self addChildViewController:haikuEntryPanel];
    [self.view addSubview:self.haikuEntryPanel.view];

    
//    NSURL *url = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"zenbell" ofType:@"aif"]];
//    NSLog(@"%@", url);
//    AVAudioPlayer *gameOverTrack = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
//    [gameOverTrack prepareToPlay];
//    [gameOverTrack play];
    
//    // Recognizer
//    UISwipeGestureRecognizer * recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(flipUpAction:)];
//    [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
//    [self.haikuEntryPanel.view addGestureRecognizer:recognizer];

    
    HaikuLine *lastLineTest = [self.haiku getNextHaikuLine];
    
    if( self.isCaptureMode )
    {
        [self.takePhotoToolbar setHidden:NO];
        [self setupVideoCaptureSession];
        
        [self.btnToggleCamera setHidden:NO];
        
        UIPanGestureRecognizer *dragger = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(haikuPanelDragged:)];
        [dragger setMinimumNumberOfTouches:1];
        [dragger setMaximumNumberOfTouches:1];
        
        [self.haikuEntryPanel.view addGestureRecognizer:dragger];
    }
    else 
    {
        if(haiku.backGroundImageData == nil)
        {

            dispatch_after(DISPATCH_TIME_NOW, dispatch_get_current_queue(), ^{
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", haiku.backGroundImage]];
                UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
                self.haiku.backGroundImageData= image;
                [self setPreviewImage:self.haiku.backGroundImageData];
                
            });
        }
        else{
            [self setPreviewImage:self.haiku.backGroundImageData];
        }

        [self showStreamingView:NO];
        [self showHaikuEntryPanel:YES];
        
        if(lastLineTest == nil)
        {
            [self.btnPostToFacebook setHidden:NO];
        }
        
//        //remove the cancel button from the toolbar - if the user wants to "cancel" they have to push the X at the top to return to the homescreen
        NSMutableArray *items = [self.confirmCancelToolbar.items mutableCopy];
        [items removeObject: self.cancelButtonBarItem];
        self.confirmCancelToolbar.items = items;
        
        [self.btnToggleCamera setHidden:YES];
    }
    
    
    //if we are not editing (i.e. waiting on someone else) hide all the toolbars - the user can't do anything
    if(!self.isEditMode)
    {
        [self.takePhotoToolbar setHidden:YES];
        [self.confirmCancelToolbar setHidden:YES];
        [self.shareToolbar setHidden:NO];
        
        if( self.haiku.isBrewing )
        {
            NSMutableArray *items = [self.shareToolbar.items mutableCopy];
            [items removeObject: self.shareButtonBarItem];
            self.shareToolbar.items = items;
        }
    }
}

-(void) initButtonIcons
{
    //*******************************************************************//
    //**** USE THIS CODE TO INIT ALL THE BAR BUTTON ITEMS IN THE APP ****//
    //*******************************************************************//
    
    self.takePhotoToolbar = [[UIToolbar alloc] init];
    
    //self.takePhotoToolbar.hidden = YES;
    NSMutableArray *takePhotoToolbarItems = [[NSMutableArray alloc] init];
//    NSLog(@"toolbarsize: width=%f height=%f x=%f y=%f", takePhotoToolbar.frame.size.width, takePhotoToolbar.frame.size.height, takePhotoToolbar.frame.origin.x, takePhotoToolbar.frame.origin.y);
    
    [self.takePhotoToolbar setFrame:CGRectMake(0, 436, 320, 44)];
    
    //=== TAKE PHOTO TOOLBAR ===//
    //HOME BUTTON
    UIImage *takePhotoHomeImage = [UIImage imageNamed:@"TakePhotoToolbarHome.png"];
    UIButton *takePhotoHomeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    takePhotoHomeButton.bounds = CGRectMake( 0, 0, takePhotoHomeImage.size.width/2, takePhotoHomeImage.size.height/2 );    
    [takePhotoHomeButton setImage:takePhotoHomeImage forState:UIControlStateNormal];
    [takePhotoHomeButton addTarget:self action:@selector(backToHome:) forControlEvents:UIControlEventTouchUpInside];    
    UIBarButtonItem *takePhotoHomeButtonBarItem = [[UIBarButtonItem alloc] initWithCustomView:takePhotoHomeButton];
    
    //TAKE PHOTO BUTTON
    UIImage *takePhotoImage = [UIImage imageNamed:@"TakePhotoToolbarTakePhoto.png"];
    UIButton *takePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    takePhotoButton.bounds = CGRectMake( 0, 0, takePhotoImage.size.width/2, takePhotoImage.size.height/2 );    
    [takePhotoButton setImage:takePhotoImage forState:UIControlStateNormal];
    [takePhotoButton addTarget:self action:@selector(btnTakePhotoClick:) forControlEvents:UIControlEventTouchUpInside];    
    UIBarButtonItem *takePhotoButtonBarItem = [[UIBarButtonItem alloc] initWithCustomView:takePhotoButton];
    
    //LIBRARY BUTTON
    UIImage *libraryImage = [UIImage imageNamed:@"TakePhotoToolbarLibrary.png"];
    UIButton *libraryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    libraryButton.bounds = CGRectMake( 0, 0, libraryImage.size.width/2, libraryImage.size.height/2 );    
    [libraryButton setImage:libraryImage forState:UIControlStateNormal];
    [libraryButton addTarget:self action:@selector(btnLibraryClick:) forControlEvents:UIControlEventTouchUpInside];    
    UIBarButtonItem *libraryButtonBarItem = [[UIBarButtonItem alloc] initWithCustomView:libraryButton];
    
    
    [takePhotoToolbarItems addObject:takePhotoHomeButtonBarItem];
    [takePhotoToolbarItems addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    [takePhotoToolbarItems addObject:takePhotoButtonBarItem];
    [takePhotoToolbarItems addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    [takePhotoToolbarItems addObject:libraryButtonBarItem];
    
    [self.takePhotoToolbar setItems:takePhotoToolbarItems];
    [self.view addSubview:self.takePhotoToolbar];
    
    
    
    self.confirmCancelToolbar = [[UIToolbar alloc] init];    
    NSMutableArray *confirmCancelToolbarItems = [[NSMutableArray alloc] init];    
    [self.confirmCancelToolbar setFrame:CGRectMake(0, 436, 320, 44)];
    
    //=== CONFIRM CANCEL TOOLBAR ===//
    //HOME BUTTON
    UIImage *confirmCancelHomeImage = [UIImage imageNamed:@"TakePhotoToolbarHome.png"];
    UIButton *confirmCancelHomeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmCancelHomeButton.bounds = CGRectMake( 0, 0, confirmCancelHomeImage.size.width/2, confirmCancelHomeImage.size.height/2 );    
    [confirmCancelHomeButton setImage:confirmCancelHomeImage forState:UIControlStateNormal];
    [confirmCancelHomeButton addTarget:self action:@selector(backToHome:) forControlEvents:UIControlEventTouchUpInside];    
    UIBarButtonItem *confirmCancelHomeButtonBarItem = [[UIBarButtonItem alloc] initWithCustomView:confirmCancelHomeButton];
    
    //CANCEL BUTTON
    UIImage *cancelButtonImage = [UIImage imageNamed:@"ConfirmCancelToolbarCancel.png"];
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.bounds = CGRectMake( 0, 0, cancelButtonImage.size.width/2, cancelButtonImage.size.height/2 );    
    [cancelButton setImage:cancelButtonImage forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelImage:) forControlEvents:UIControlEventTouchUpInside];    
    self.cancelButtonBarItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    
    //CONFIRM BUTTON
    UIImage *confirmButtonImage = [UIImage imageNamed:@"ConfirmCancelToolbarConfirm.png"];
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.bounds = CGRectMake( 0, 0, confirmButtonImage.size.width/2, confirmButtonImage.size.height/2 );    
    [confirmButton setImage:confirmButtonImage forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmImage:) forControlEvents:UIControlEventTouchUpInside];    
    UIBarButtonItem *confirmButtonBarItem = [[UIBarButtonItem alloc] initWithCustomView:confirmButton];
    
    //TOGGLE HAIKU ENTRY PANEL BUTTON
    UIImage *toggleEntryPanelImage = [UIImage imageNamed:@"ConfirmCancelToolbarHide.png"];
    self.btnToggleHaikuEntryPanel = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnToggleHaikuEntryPanel.bounds = CGRectMake( 0, 0, toggleEntryPanelImage.size.width/2, toggleEntryPanelImage.size.height/2 );    
    [self.btnToggleHaikuEntryPanel setImage:toggleEntryPanelImage forState:UIControlStateNormal];
    [self.btnToggleHaikuEntryPanel addTarget:self action:@selector(toggleHaikuEntryPanel:) forControlEvents:UIControlEventTouchUpInside];    
    UIBarButtonItem *toggleEntryPanelButtonBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnToggleHaikuEntryPanel];
    
    
    [confirmCancelToolbarItems addObject:confirmCancelHomeButtonBarItem];
    [confirmCancelToolbarItems addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    [confirmCancelToolbarItems addObject:self.cancelButtonBarItem];
    [confirmCancelToolbarItems addObject:confirmButtonBarItem];
    [confirmCancelToolbarItems addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    [confirmCancelToolbarItems addObject:toggleEntryPanelButtonBarItem];
    
    [self.confirmCancelToolbar setItems:confirmCancelToolbarItems];
    [self.view addSubview:self.confirmCancelToolbar];

    
    
    self.shareToolbar = [[UIToolbar alloc] init];    
    NSMutableArray *shareToolbarItems = [[NSMutableArray alloc] init];    
    [self.shareToolbar setFrame:CGRectMake(0, 436, 320, 44)];
    
    //=== SHARE TOOLBAR ===//
    //HOME BUTTON
    UIImage *shareHomeImage = [UIImage imageNamed:@"TakePhotoToolbarHome.png"];
    UIButton *shareHomeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareHomeButton.bounds = CGRectMake( 0, 0, shareHomeImage.size.width/2, shareHomeImage.size.height/2 );    
    [shareHomeButton setImage:shareHomeImage forState:UIControlStateNormal];
    [shareHomeButton addTarget:self action:@selector(backToHome:) forControlEvents:UIControlEventTouchUpInside];    
    UIBarButtonItem *shareHomeButtonBarItem = [[UIBarButtonItem alloc] initWithCustomView:shareHomeButton];
    
    //SHARE BUTTON
    UIImage *shareButtonImage = [UIImage imageNamed:@"SendHaiku.png"];
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.bounds = CGRectMake( 0, 0, shareButtonImage.size.width/2, shareButtonImage.size.height/2 );    
    [shareButton setImage:shareButtonImage forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(pressBtnPostToFacebook:) forControlEvents:UIControlEventTouchUpInside];    
    self.shareButtonBarItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    
    [shareToolbarItems addObject:shareHomeButtonBarItem];
    [shareToolbarItems addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    [shareToolbarItems addObject:self.shareButtonBarItem];
    
    [self.shareToolbar setItems:shareToolbarItems];
    [self.view addSubview:self.shareToolbar];
    
    
    
    self.libraryPreviewToolbar = [[UIToolbar alloc] init];    
    NSMutableArray *libraryPreviewToolbarItems = [[NSMutableArray alloc] init];    
    [self.libraryPreviewToolbar setFrame:CGRectMake(0, 436, 320, 44)];
    
    //=== LIBRARY PREVIEW TOOLBAR ===//
    //HOME BUTTON
//    UIImage *libraryHomeImage = [UIImage imageNamed:@"TakePhotoToolbarHome.png"];
//    UIButton *libraryHomeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    libraryHomeButton.bounds = CGRectMake( 0, 0, libraryHomeImage.size.width/2, libraryHomeImage.size.height/2 );    
//    [libraryHomeButton setImage:libraryHomeImage forState:UIControlStateNormal];
//    [libraryHomeButton addTarget:self action:@selector(backToHome:) forControlEvents:UIControlEventTouchUpInside];    
//    UIBarButtonItem *libraryHomeButtonBarItem = [[UIBarButtonItem alloc] initWithCustomView:libraryHomeButton];
//    
    //CANCEL LIBRARY IMAGE BUTTON
    UIImage *cancelLibraryImageImage = [UIImage imageNamed:@"ConfirmCancelToolbarCancel.png"];
    UIButton *cancelLibraryImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelLibraryImageButton.bounds = CGRectMake( 0, 0, cancelLibraryImageImage.size.width/2, cancelLibraryImageImage.size.height/2 );    
    [cancelLibraryImageButton setImage:cancelLibraryImageImage forState:UIControlStateNormal];
    [cancelLibraryImageButton addTarget:self action:@selector(cancelLibraryImage:) forControlEvents:UIControlEventTouchUpInside];    
    UIBarButtonItem *cancelLibraryImageBarItem = [[UIBarButtonItem alloc] initWithCustomView:cancelLibraryImageButton];
    
    //CONFIRM LIBRARY IMAGE BUTTON
    UIImage *confirmLibraryImageImage = [UIImage imageNamed:@"ConfirmCancelToolbarConfirm.png"];
    UIButton *confirmLibraryImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmLibraryImageButton.bounds = CGRectMake( 0, 0, confirmLibraryImageImage.size.width/2, confirmLibraryImageImage.size.height/2 );    
    [confirmLibraryImageButton setImage:confirmLibraryImageImage forState:UIControlStateNormal];
    [confirmLibraryImageButton addTarget:self action:@selector(confirmLibraryImage:) forControlEvents:UIControlEventTouchUpInside];    
    UIBarButtonItem *confirmLibraryImageBarItem = [[UIBarButtonItem alloc] initWithCustomView:confirmLibraryImageButton];    
    
    [libraryPreviewToolbarItems addObject:cancelLibraryImageBarItem];
    [libraryPreviewToolbarItems addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    [libraryPreviewToolbarItems addObject:confirmLibraryImageBarItem];
    
    [self.libraryPreviewToolbar setItems:libraryPreviewToolbarItems];
    [self.view addSubview:self.libraryPreviewToolbar];
    
    [self.takePhotoToolbar setHidden:NO];
    [self.confirmCancelToolbar setHidden:YES];
    [self.shareToolbar setHidden:YES];
    [self.libraryPreviewToolbar setHidden:YES];
}

double oldX = 0;
double oldY = 0;
-(void)haikuPanelDragged:(id)sender{
    double minX = self.uivPreviewView.frame.origin.x;
    double minY = self.uivPreviewView.frame.origin.y;
    double maxX = (self.uivPreviewView.frame.origin.x + self.uivPreviewView.frame.size.width) - [sender view].frame.size.width;
    double maxY = (self.uivPreviewView.frame.origin.y + self.uivPreviewView.frame.size.height) - [sender view].frame.size.height;
    

    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        oldX = 0;
        oldY = 0;
    }
    
    double dx = translatedPoint.x - oldX;
    double dy = translatedPoint.y - oldY;
    oldX = translatedPoint.x;
    oldY = translatedPoint.y;
    
    double newX = [sender view].frame.origin.x + dx;
    double newY = [sender view].frame.origin.y + dy;
    
    if( newX > maxX )
        newX = maxX;
    if( newY > maxY )
        newY = maxY;
    
    if( newX < minX )
        newX = minX;
    if( newY < minY )
        newY = minY;
    
    self.haikuEntryPanel.view.frame = CGRectMake(newX, newY, [sender view].frame.size.width, [sender view].frame.size.height);
    self.haiku.yPosition = [NSNumber numberWithInt:self.haikuEntryPanel.view.frame.origin.y];
}

-(void)flipUpAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    
}



- (void)viewDidUnload
{
    [self setUivBackCameraStreamingView:nil];
    [self setUivPreviewView:nil];
    [self setBtnTakeCancelPhoto:nil];
    [self setBtnLibrary:nil];
    [self setBtnToggleCamera:nil];
    [self setTakePhotoToolbar:nil];
    [self setConfirmCancelToolbar:nil];
    [self setBtnToggleHaikuEntryPanel:nil];
    [self setBtnPostToFacebook:nil];
    [self setBtnBackToHome:nil];
    [self setShareToolbar:nil];
    [self setBtnToggleCamera:nil];
    [self setShareButtonBarItem:nil];
    [self setBtnCancelLibraryImage:nil];
    [self setBtnConfirmLibraryImage:nil];
    [self setSvLibraryPicScroller:nil];
    [self setLibraryPreviewToolbar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void) setupVideoCaptureSession
{
    //*** NOTE ***
    //The *BACK* camera is the one facing away from the user
    //The *FRONT* camera is the one facing towards the user
    
    //*** SETUP VIDEO CAPTURE SESSIONS ***//
    self.session = [[AVCaptureSession alloc] init];
	self.session.sessionPreset = AVCaptureSessionPresetHigh;
    
	AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
	captureVideoPreviewLayer.frame = self.uivBackCameraStreamingView.bounds;
	[self.uivBackCameraStreamingView.layer addSublayer:captureVideoPreviewLayer];
    
    //find and save the front and back cameras
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *backCameraDevice;
    AVCaptureDevice *frontCameraDevice;
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionBack) 
        {
            backCameraDevice = device;
        }
        if([device position] == AVCaptureDevicePositionFront) 
        {
            frontCameraDevice = device;
            NSLog(@"AVCaptureSessionPreset1280x720: %i",[frontCameraDevice supportsAVCaptureSessionPreset:AVCaptureSessionPreset1280x720]);
            NSLog(@"AVCaptureSessionPresetiFrame960x540: %i",[frontCameraDevice supportsAVCaptureSessionPreset:AVCaptureSessionPresetiFrame960x540]);
            NSLog(@"AVCaptureSessionPreset640x480: %i",[frontCameraDevice supportsAVCaptureSessionPreset:AVCaptureSessionPreset640x480]);
            
            NSLog(@"AVCaptureSessionPresetHigh: %i",[frontCameraDevice supportsAVCaptureSessionPreset:AVCaptureSessionPresetHigh]);
            NSLog(@"AVCaptureSessionPresetMedium: %i",[frontCameraDevice supportsAVCaptureSessionPreset:AVCaptureSessionPresetMedium]);
            NSLog(@"AVCaptureSessionPresetLow: %i",[frontCameraDevice supportsAVCaptureSessionPreset:AVCaptureSessionPresetLow]);
        }
    }
    
    //If they have no back facing camera remove the toggle button (for iPhone 3G and before)
    if( frontCameraDevice == nil )
    {
        NSMutableArray *takePhotoToolbarItems = [[NSMutableArray alloc] init];
        for (UIBarButtonItem *item in self.takePhotoToolbar.items) {
            if([item isEqual:self.btnToggleCamera])
            {
                [takePhotoToolbarItems addObject:item];
                
            }
        }   
        self.takePhotoToolbar.items = takePhotoToolbarItems;
    }
    
	NSError *error = nil;
	self.frontCameraInput = [AVCaptureDeviceInput deviceInputWithDevice:frontCameraDevice error:&error];
    self.backCameraInput = [AVCaptureDeviceInput deviceInputWithDevice:backCameraDevice error:&error];
    
	if (!self.frontCameraInput) {
		// Handle the error appropriately.
		NSLog(@"ERROR: trying to open camera: %@", error);
	}
	[self.session addInput:self.backCameraInput];
    
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    
    [self.session addOutput:stillImageOutput];
    
	[self.session startRunning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (IBAction)confirmImage:(id)sender {
    if([self.haiku getNextHaikuLineNumber] == 1 && (self.haikuEntryPanel.tfHaikuLine1.text == nil || [self.haikuEntryPanel.tfHaikuLine1.text isEqualToString:@""]))
    {
        [self displayMessageViewController:@"Please enter line 1"];
        return;
    }
    if([self.haiku getNextHaikuLineNumber] == 2 && (self.haikuEntryPanel.tfHaikuLine2.text == nil || [self.haikuEntryPanel.tfHaikuLine2.text isEqualToString:@""]))
    {
        [self displayMessageViewController:@"Please enter line 2"];
        return;
    }
    
    
    if([self.haiku getNextHaikuLineNumber] == 3)
    {
        if((self.haikuEntryPanel.tfHaikuLine3.text == nil || [self.haikuEntryPanel.tfHaikuLine3.text isEqualToString:@""]))
        {
            [self displayMessageViewController:@"Please enter line 3"];
            return;
        }
        else {
            GetBaseDataManager *manager = [[GetBaseDataManager alloc] init];
            [manager setUpdateDelegate:self];
            [manager updateHaikuLineThree:self.haiku];
            [self.confirmCancelToolbar setHidden:YES];
            [self.takePhotoToolbar setHidden:YES];
            [self.btnPostToFacebook setHidden:NO];
            
            [self.haikuEntryPanel.lbHaikuLine3 setText:self.haikuEntryPanel.tfHaikuLine3.text];
            [self.haikuEntryPanel.lbHaikuLine3 setHidden:NO];
            [self.haikuEntryPanel.tfHaikuLine3 setHidden:YES];

            [self.haikuEntryPanel colorLineBackground:self.haikuEntryPanel.lbHaikuLine3 withColor:[UIColor colorWithRed:86.0/255.0 green:149.0/255.0 blue:182.0/255.0 alpha:0.9]];
            [self.shareToolbar setHidden:NO];
            
        }
    }
//    else {
        SelectFacebookFriendViewController *controller = [[SelectFacebookFriendViewController alloc] initWithNibName:@"SelectFacebookFriendViewController_iPhone" bundle:nil];
        [controller setIsUpdate:!self.isCaptureMode];
        if(self.isCaptureMode)
            [self.haiku setBackGroundImageData:self.uivPreviewView.image];
        
        self.haiku.yPosition = [NSNumber numberWithInt:self.haikuEntryPanel.view.frame.origin.y];
        [controller setHaiku:self.haiku];
        [self.navigationController pushViewController:controller animated:YES];
//    }
    NSLog(@"Here");
}

- (IBAction)cancelImage:(id)sender {
    //Switch Image Output State    
    [self.uivPreviewView setHidden:YES];
    [self.uivBackCameraStreamingView setHidden:NO];
    [self showImagePreviewBorder:NO];
    
    self.uivPreviewView.image = nil;
    
    [self.takePhotoToolbar setHidden:NO];
    [self.confirmCancelToolbar setHidden:YES];
    
    [self showHaikuEntryPanel:NO];
    
    [self.btnToggleCamera setHidden:NO];
}


#pragma mark --- Library Image Selection Functions ---
- (IBAction)btnLibraryClick:(id)sender {
    if(self.libraryImagePicker == nil)
    {
        libraryImagePicker = [[UIImagePickerController alloc] init];
        libraryImagePicker.delegate = self;
        [libraryImagePicker setWantsFullScreenLayout:YES];
        
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypePhotoLibrary]) 
        {
            // Set source to the Photo Library
            libraryImagePicker.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
        }
    }

    [self.takePhotoToolbar setHidden:YES];
    [self.confirmCancelToolbar setHidden:YES];
    [self.shareToolbar setHidden:YES];
    [self.uivBackCameraStreamingView setHidden:YES];
    
    [self.svLibraryPicScroller setHidden:NO];
    [self.libraryPreviewToolbar setHidden:NO];
    
    [self presentModalViewController:libraryImagePicker animated:YES];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [self.uivBackCameraStreamingView setHidden:YES];
    [self dismissViewControllerAnimated:YES completion:^(void) {
        [self setupLibraryImageScroller:image];
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    self.libraryImageView.image = nil;
    
    [self.takePhotoToolbar setHidden:NO];
    [self.uivBackCameraStreamingView setHidden:NO];
    
    [self.svLibraryPicScroller setHidden:YES];
    [self.libraryPreviewToolbar setHidden:YES];
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void)setupLibraryImageScroller:(UIImage *)image
{
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    
    float viewWidth = 320;
    float viewHeight = 460;
    
    float newImageHeight = imageHeight;
    float newImageWidth = imageHeight / (viewHeight/viewWidth);
    
    NSLog(@"width: %f", imageWidth);
    NSLog(@"height: %f", imageHeight);
    NSLog(@"NewImageWidth: %f", newImageWidth);
    NSLog(@"NewImageHeight: %f", newImageHeight);
    image = [self fixOrientation:image DoFlip:NO];
    if( imageWidth < imageHeight ) //vertical image
    {
        newImageHeight = imageHeight;
        newImageWidth = imageHeight / (viewHeight/viewWidth);
        
        NSLog(@"NewImageWidth: %f", newImageWidth);
        NSLog(@"NewImageHeight: %f", newImageHeight);
        
        image = [self imageByCropping:image toRect:CGRectMake(0, 0, newImageWidth, newImageHeight)];

        self.libraryImageView = [[UIImageView alloc] initWithImage:image];
        self.libraryImageView.frame = CGRectMake(0, 47, 320, 460);
        
        [self.svLibraryPicScroller setContentSize:CGSizeMake(320, 620)];
    }
    else { //horizontal image
        newImageHeight = imageWidth / (viewHeight/viewWidth);
        newImageWidth = imageWidth;
        
        NSLog(@"NewImageWidth: %f", newImageWidth);
        NSLog(@"NewImageHeight: %f", newImageHeight);
        
        image = [self imageByCropping:image toRect:CGRectMake(0, 0, newImageWidth, newImageHeight)];
        
        self.libraryImageView = [[UIImageView alloc] initWithImage:image];
        self.libraryImageView.frame = CGRectMake(0, 47, 460, 320);
        
        [self.svLibraryPicScroller setContentSize:CGSizeMake(self.libraryImageView.frame.size.width, 320)];
    }
    
    //kludge to make sure the scrollview is in the right place after the library picker's status bar is removed
    [self.svLibraryPicScroller setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)]; 
    [self.svLibraryPicScroller setContentOffset:CGPointMake(0, 0)];
    
    [self.svLibraryPicScroller addSubview:self.libraryImageView];
    
    [self.uivPreviewView setHidden:NO];
    [self showImagePreviewBorder:YES];
}

- (IBAction)cancelLibraryImage:(id)sender 
{
    self.libraryImageView.image = nil;
    
    [self presentModalViewController:self.libraryImagePicker animated:YES];
}

- (IBAction)confirmLibraryImage:(id)sender 
{
    [self.libraryPreviewToolbar setHidden:YES];
    [self.libraryImageView setHidden:YES];
    [self.svLibraryPicScroller setHidden:YES];
    
    [self.confirmCancelToolbar setHidden:NO];
            
    [self setPreviewImage:libraryImageView.image withOffset:self.svLibraryPicScroller.contentOffset];
    
    self.libraryImageView.image = nil;
    
    [self showImagePreviewBorder:NO];
}



- (IBAction)btnToggleCameraClick:(id)sender
{
    //*** NOTE ***
    //The *BACK* camera is the one facing away from the user
    //The *FRONT* camera is the one facing towards the user

    [session beginConfiguration];
    
    if( self.isShowingFrontFacingCamera ) {
        [session removeInput:self.frontCameraInput];
        [session addInput:self.backCameraInput];                                  
        //self.session.sessionPreset = AVCaptureSessionPreset1280x720;
    }
    else {
       	//self.session.sessionPreset = AVCaptureSessionPresetHigh;
        [session removeInput:self.backCameraInput];
        [session addInput:self.frontCameraInput];
    }
    self.isShowingFrontFacingCamera = !self.isShowingFrontFacingCamera;
    
    [session commitConfiguration];
}

-(void)setPreviewImage:(UIImage *)image
{
    float width = image.size.width;
    float height = image.size.height;
    image = [self fixOrientation:image DoFlip:NO];
    image = [self imageByCropping:image toRect:CGRectMake(0, (height - width) / 2, width, width)];
    
    self.uivPreviewView.image = image;
    [self showImagePreviewBorder:NO];
    [self showStreamingView:NO];
    [self showHaikuEntryPanel:YES];
}

-(void)setPreviewImage:(UIImage *)image withOffset:(CGPoint)offset
{
    float width = image.size.width;
    float height = image.size.height;
    
    float ratio = height / self.svLibraryPicScroller.frame.size.height;
    
    image = [self fixOrientation:image DoFlip:NO];
    image = [self imageByCropping:image toRect:CGRectMake(0, offset.y * ratio, width, width)];
    
    self.uivPreviewView.image = image;
    [self showImagePreviewBorder:NO];
    [self showStreamingView:NO];
    [self showHaikuEntryPanel:YES];
}

- (void) showStreamingView:(BOOL) show
{
    //Switch Image Output State
    if( show )
    {
        [self.uivPreviewView setHidden:NO];
        [self.uivBackCameraStreamingView setHidden:NO];
        
        [self.takePhotoToolbar setHidden:NO];
        [self.confirmCancelToolbar setHidden:YES];
    }
    else 
    {
        [self.uivPreviewView setHidden:NO];
        [self.uivBackCameraStreamingView setHidden:YES];
        
        [self.takePhotoToolbar setHidden:YES];
        [self.confirmCancelToolbar setHidden:NO];
    }
}

-(void)showHaikuEntryPanel:(BOOL)show
{
    self.isHaikuEntryPanelShowing = show;
    
    int yPos = 0;
    if( self.isHaikuEntryPanelShowing ) {
        if(self.haiku.yPosition == nil || self.haiku.yPosition == 0)
        {
           yPos = HAIKU_ENTRY_PANEL_SHOW_Y_POS; 
        }
        else {
            yPos = [self.haiku.yPosition intValue];
        }
        
        UIImage *toggleEntryPanelImage = [UIImage imageNamed:@"ConfirmCancelToolbarHide.png"];
        [self.btnToggleHaikuEntryPanel setImage:toggleEntryPanelImage forState:UIControlStateNormal];
    }
    else {
        yPos = HAIKU_ENTRY_PANEL_HIDE_Y_POS;
        UIImage *toggleEntryPanelImage = [UIImage imageNamed:@"ConfirmCancelToolbarShow.png"];
        [self.btnToggleHaikuEntryPanel setImage:toggleEntryPanelImage forState:UIControlStateNormal];
    }
    [UIView animateWithDuration:0.5 
                          delay:0.0 
                        options:UIViewAnimationOptionCurveEaseIn 
                     animations:^{
                         self.haikuEntryPanel.view.frame = CGRectMake(HAIKU_ENTRY_PANEL_SHOW_X_POS,yPos, self.haikuEntryPanel.view.frame.size.width, self.haikuEntryPanel.view.frame.size.height);
                     }
                     completion:nil];
}

// THIS FUNCTION IS USED ONLY FOR THE TOGGLE BUTTON
- (IBAction)toggleHaikuEntryPanel:(id)sender
{
    [self showHaikuEntryPanel:!self.isHaikuEntryPanelShowing];
}

- (void) goGoGadgetSnapshot
{
  UIImage *baImage = [self imageFromView:self.view];
           self.imageToAdd = [[UIImageView alloc] initWithImage:baImage];
           [self.imageToAdd setFrame:self.view.frame];
           [self.view addSubview:imageToAdd];

}

- (IBAction)btnTakePhotoClick:(id)sender {


//    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150,150)];
//    [imgView setImage:[self imageFromView:self.view]];
//    [self.view addSubview:imgView];
    
    
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200,200)];
//    [imgView setImage:[ScreenCapture UIViewToImage:self.view]];
    [self.view addSubview:imgView];
    
    AVCaptureConnection *videoConnection;
    for( AVCaptureConnection *connection in self.stillImageOutput.connections )
    {
        for( AVCaptureInputPort *port in [connection inputPorts])
        {
            if( [[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
                break;
            }
        }
        if( videoConnection ) { break; }
    }
    
    if( videoConnection == nil )
        return;
    
    if ([videoConnection isVideoOrientationSupported])
    {
        if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait){
            [videoConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
        }
    }

    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection 
                                                       completionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         //[self captureOutput:imageSampleBuffer];
         //[self showPicturePreviewForCaptureOutput:stillImageOutput didOutputSampleBuffer:imageSampleBuffer fromConnection:videoConnection inView:imgView];
         
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *image = [[UIImage alloc] initWithData:imageData];
         
         NSLog(@"IMAGE WIDTH: %f", image.size.width);
         NSLog(@"IMAGE HEIGHT: %f", image.size.height);
         
         float width = image.size.width;
         float height = image.size.height;
         if( self.isShowingFrontFacingCamera )
         {
             image = [self fixOrientation:image DoFlip:YES];
         }
         else {
             image = [self fixOrientation:image DoFlip:NO];
         }
         image = [self imageByCropping:image toRect:CGRectMake(0, (height - width) / 2, width, width)];
         
         
         [self setPreviewImage:image];
         
         [self.btnToggleCamera setHidden:YES];
     }];
}

             
#pragma mark --- Image Functions ---
-(UIImage *)resizeHorizontalImage:(UIImage *)image
{
    return image;
}

-(UIImage *)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], rect);
    
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
}

- (UIImage *)fixOrientation:(UIImage *) imageToFix DoFlip:(BOOL)doflip{
    
    // No-op if the orientation is already correct
    if (imageToFix.imageOrientation == UIImageOrientationUp) return imageToFix;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    if( doflip )
    {
        transform = CGAffineTransformTranslate(transform, imageToFix.size.width, 0);
        transform = CGAffineTransformScale(transform, -1, 1);
    }
    
    switch (imageToFix.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, imageToFix.size.width, imageToFix.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, imageToFix.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, imageToFix.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
//    if( doflip )
//    {
//        switch (imageToFix.imageOrientation) {
//            case UIImageOrientationUpMirrored:
//            case UIImageOrientationDownMirrored:
//                transform = CGAffineTransformTranslate(transform, imageToFix.size.width, 0);
//                transform = CGAffineTransformScale(transform, -1, 1);
//                break;
//                
//            case UIImageOrientationLeftMirrored:
//            case UIImageOrientationRightMirrored:
//                transform = CGAffineTransformTranslate(transform, imageToFix.size.height, 0);
//                transform = CGAffineTransformScale(transform, -1, 1);
//                break;
//            case UIImageOrientationUp:
//            case UIImageOrientationDown:
//            case UIImageOrientationLeft:
//            case UIImageOrientationRight:
//                break;
//        }
//    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, imageToFix.size.width, imageToFix.size.height,
                                             CGImageGetBitsPerComponent(imageToFix.CGImage), 0,
                                             CGImageGetColorSpace(imageToFix.CGImage),
                                             CGImageGetBitmapInfo(imageToFix.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (imageToFix.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,imageToFix.size.height,imageToFix.size.width), imageToFix.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,imageToFix.size.width,imageToFix.size.height), imageToFix.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}



- (IBAction)pressBtnPostToFacebook:(id)sender {

    self.postToWhoKnowsWhat = [[PostToWhoKnowsWhat alloc] initWithObjects:nil withHaiku:self.haiku withView:self.view withNaviationController:self.navigationController withDelegate:self];
    [self.postToWhoKnowsWhat displayPostToWhoKnowsWhat];
}

- (IBAction)backToHome:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}

#pragma mark -- UpdateHaikuBrewsDelegate Event Handlers --
-(void)updateHaikuBrewsDidStart:(NSString *)userId
{
    NSLog(@"UPDATE STARETED");
    self.spinnerViewController = [[SpinnerViewController alloc] initWithParentView:self.view withLabel:@"Updating Haiku"];
    [self.spinnerViewController showSpinnerWithMessage:@"Updating Haiku"];
}

-(void)updateHaikuBrewsDidSucceed:(Haiku *)haiku
{
    NSLog(@"UPDATED SUCCEED");

    [self.spinnerViewController dismissSpinner];
    [self displayMessageViewController:@"Your Haiku has been brewed"];
    [self.confirmCancelToolbar setHidden:YES];
        [self.takePhotoToolbar setHidden:YES];
        [self.btnPostToFacebook setHidden:NO];
        
        [self.haikuEntryPanel.lbHaikuLine3 setText:self.haikuEntryPanel.tfHaikuLine3.text];
        [self.haikuEntryPanel.lbHaikuLine3 setHidden:NO];
        [self.haikuEntryPanel.tfHaikuLine3 setHidden:YES];

        [self.haiku.haikuLine3 setIsComplete:YES];
    
    
    for (id view in self.navigationController.viewControllers) {
        if( [view isKindOfClass:[NewHomeViewController class]] )
        {
            NewHomeViewController *newHomeVC = ((NewHomeViewController *)view);
            [newHomeVC updateHaikuInStack:self.haiku];
            break;
        }
    }
    
   

}

-(void)updateHaikuBrewsDidFail:(NSString *)reason
{
    NSLog(@"UPDATE FAIL");   
    [self.spinnerViewController dismissSpinner];

}

#pragma mark -- ConfirmViewControllerDelegate Event Handlers --
-(void)confirmViewControllerDismissed
{
    [self.takePhotoToolbar setHidden:YES];
    [self.confirmCancelToolbar setHidden:YES];
    
    
}


#pragma mark UIActionSheet Methods
-(IBAction)showActionSheet:(id)sender {
    
}

-(void) displayMessageViewController:(NSString *) _message
{
    [self displayMessageViewController:_message andPop:[NSNumber numberWithBool:NO]];
     
}
-(void) displayMessageViewController:(NSString *) _message andPop:(NSNumber *) isPop
{
    CGRect display = CGRectMake(0, 436, self.view.frame.size.width, 44);
    
    if(self.displayMessageViewController == nil)
    {
        self.displayMessageViewController = [[DIsplayMessageViewController alloc] initWithNibName:@"DIsplayMessageViewController" bundle:nil] ;
        self.displayMessageViewController.view.frame = display;
        
        [self.displayMessageViewController.messageLabel setText:_message];
        [self.view addSubview:self.displayMessageViewController.view];
        [self.view bringSubviewToFront:self.shareToolbar];
        [self.view bringSubviewToFront:self.libraryPreviewToolbar];
        [self.view bringSubviewToFront:self.takePhotoToolbar];
        [self.view bringSubviewToFront:self.confirmCancelToolbar];
    }
    self.displayMessageViewController.view.frame = display;

    __block NSNumber *blockIsPop = isPop;
    [self.displayMessageViewController.messageLabel setText:_message];
    [UIView animateWithDuration:.8 
                     animations:^{
                         CGRect rect = self.displayMessageViewController.view.frame;
                         rect.origin.y = self.displayMessageViewController.view.frame.origin.y - 50;
                         self.displayMessageViewController.view.frame = rect;
                         
                         
                         
                     } 
                     completion:^(BOOL finished){
                         [self performSelector:@selector(hideMessageViewController:) withObject:blockIsPop afterDelay:1.0];
                     }
     ];
}


-(void) hideMessageViewController:(NSNumber *) isPop
{
    CGRect offDisplay = CGRectMake(0, 436, self.view.frame.size.width, 44);
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
                             [self.navigationController popViewControllerAnimated:YES];
                         }
                     }
     ];
}


- (void) showImagePreviewBorder:(BOOL)visible
{
    if( visible )
    {
        self.uivPreviewView.layer.cornerRadius = 0.0;
        self.uivPreviewView.layer.masksToBounds = YES;
        self.uivPreviewView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.uivPreviewView.layer.borderWidth = 0.5;
    }
    else {
        self.uivPreviewView.layer.borderWidth = 0.0;
    }
}

- (void) showNonFinalUIElements:(BOOL)visible
{
    //header
    [self.btnPostToFacebook setHidden:!visible];
    [self.btnBackToHome setHidden:!visible];
 
    
    if(!visible)
    {
        self.uivPreviewView.layer.cornerRadius = 9.0;
        self.uivPreviewView.layer.masksToBounds = YES;
        self.uivPreviewView.layer.borderColor = [UIColor blackColor].CGColor;
        self.uivPreviewView.layer.borderWidth = 2.0;
        [self.view setBackgroundColor:[UIColor clearColor]];
        [self.uivPreviewView setBackgroundColor:[UIColor orangeColor]];
        [self.confirmCancelToolbar setHidden:YES];
        [self.takePhotoToolbar setHidden:YES];
        [self.shareToolbar setHidden:YES];
        
    }
    else {
        self.uivPreviewView.layer.cornerRadius = 0.0;
        self.uivPreviewView.layer.masksToBounds = NO;
        self.uivPreviewView.layer.borderColor = nil;
        self.uivPreviewView.layer.borderWidth = 0.0;

        [self.shareToolbar setHidden:NO];
    }
}




-(void)keyboardWillShow {
    // Animate the current view out of the way

        [self setViewMovedUp:YES];
}

-(void)keyboardWillHide {
           [self setViewMovedUp:NO];
    
}

//-(void)textFieldDidBeginEditing:(UITextField *)sender
//{
//    if ([sender isEqual:mailTf])
//    {
//        //move the main view, so that the keyboard does not hide it.
//        if  (self.view.frame.origin.y >= 0)
//        {
//            [self setViewMovedUp:YES];
//        }
//    }
//}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.haikuEntryPanel.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard 
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y = HAIKU_ENTRY_PANEL_SHOW_Y_POS;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y = self.haiku.yPosition == nil ? HAIKU_ENTRY_PANEL_SHOW_Y_POS : self.haiku.yPosition.intValue;
    }
    self.haikuEntryPanel.view.frame = rect;
    
    [UIView commitAnimations];
}



- (UIImage *) imageFromView:(UIView *)view {
    
    UIGraphicsBeginImageContext(view.frame.size);
    [[view layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return screenshot;
}


// Delegate routine that is called when a sample buffer was written
- (void)captureOutput:(CMSampleBufferRef)sampleBuffer 
{ 
    // Create a UIImage from the sample buffer data
    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [imageView setBackgroundColor:[UIColor greenColor]];
    [imageView setImage:image];
    [self.view addSubview:imageView];
}

// Create a UIImage from sample buffer data
- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer 
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer); 
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0); 
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer); 
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer); 
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer); 
    size_t height = CVPixelBufferGetHeight(imageBuffer); 
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); 
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8, 
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst); 
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context); 
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context); 
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return (image);
}

@end