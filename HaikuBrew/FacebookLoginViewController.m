//
//  FacebookLoginViewController.m
//  HaikuBrew
//
//  Created by Brian Ellison on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FacebookLoginViewController.h"
#import "AppDelegate.h"

@interface FacebookLoginViewController () <FBLoginViewDelegate>

@end

@implementation FacebookLoginViewController
@synthesize scrlTutorial;
@synthesize pageControl;
@synthesize btnFacebookLogin, loginViewDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.scrlTutorial setDelegate:self];
    [self.pageControl setNumberOfPages:3];
    [self.pageControl setCurrentPage:0];
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            // iPhone Classic
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Tutorial1.png"]];
            [imageView setFrame:CGRectMake(0, 0, 320,460)];
            
            UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Tutorial2.png"]];
            [imageView2 setFrame:CGRectMake(320, 0, 320,460)];
            
            UIImageView *imageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Tutorial3.png"]];
            [imageView3 setFrame:CGRectMake(640, 0, 320,460)];
            [self.scrlTutorial addSubview:imageView];
            [self.scrlTutorial addSubview:imageView2];
            [self.scrlTutorial addSubview:imageView3];
        }
        if(result.height == 568)
        {
            // iPhone 5
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Tutorial-1-1136.png"]];
            [imageView setFrame:CGRectMake(0, 0, 320,548)];
            
            UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Tutorial-2-1136.png"]];
            [imageView2 setFrame:CGRectMake(320, 0, 320,548)];
            
            UIImageView *imageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Tutorial-3-1136.png"]];
            [imageView3 setFrame:CGRectMake(640, 0, 320,548)];
            [self.scrlTutorial addSubview:imageView];
            [self.scrlTutorial addSubview:imageView2];
            [self.scrlTutorial addSubview:imageView3];
        }
    }
    

    
    [self.btnFacebookLogin setFrame:CGRectMake(640 + self.btnFacebookLogin.frame.origin.x, self.btnFacebookLogin.frame.origin.y, self.btnFacebookLogin.frame.size.width, self.btnFacebookLogin.frame.size.height)];
    

    [self.scrlTutorial setContentSize:CGSizeMake(640+320, 460)];
    [self.scrlTutorial addSubview:self.btnFacebookLogin];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if([prefs objectForKey:@"uid"] != nil && ![[prefs objectForKey:@"uid"] isEqualToString:@""])
    {
        [self.scrlTutorial setContentOffset:CGPointMake(640, 0) animated:NO];
        
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWidth = scrollView.frame.size.width;
    //    int page = floor((self.visScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    //    if([self.visScrollView isDragging] && [self.visScrollView isDecelerating])
    //        [self goToPage:[NSNumber numberWithInt:page]];
    
    
    static NSInteger previousPage = 0;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger newPage = lround(fractionalPage);
    if (previousPage != newPage) {
        [self.pageControl setCurrentPage:newPage];
        [scrollView setContentOffset:CGPointMake(newPage * 320, 0) animated:YES];
        previousPage = newPage;
    }

}


- (void)viewDidUnload
{
    [self setBtnFacebookLogin:nil];
    [self setScrlTutorial:nil];
    [self setPageControl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationPortrait == interfaceOrientation;
}

- (IBAction)touchFacebookLogin:(id)sender {
    
    [self openSession];
    
    
//    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    // this button's job is to flip-flop the session from open to closed
//    if (appDelegate.session.isOpen) {
//        // if a user logs out explicitly, we delete any cached token information, and next
//        // time they run the applicaiton they will be presented with log in UX again; most
//        // users will simply close the app or switch away, without logging out; this will
//        // cause the implicit cached-token login to occur on next launch of the application
//        [appDelegate.session closeAndClearTokenInformation];
//        
//    } else {
//        if (appDelegate.session.state != FBSessionStateCreated) {
//            // Create a new, logged out session.
//            appDelegate.session = [[FBSession alloc] init];
//        }
//    [FBSession setActiveSession:appDelegate.session];
//        // if the session isn't open, let's open it now and present the login UX to the user
//        [appDelegate.session openWithCompletionHandler:^(FBSession *session,
//                                                         FBSessionState status,
//                                                         NSError *error) {
//            // and here we make sure to update our UX according to the new session state
//
//            [self.loginViewDelegate facebookLoginSuccessful];
//            
//            [self dismissModalViewControllerAnimated:YES];
//        }];
//        
//        
//    }
    
//    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    [appDelegate.facebook setSessionDelegate:self];
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    if( [defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"] )
//    {
//        appDelegate.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
//        appDelegate.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];                                
//    }
//    
//    if( ![appDelegate.facebook isSessionValid] )
//    {
//        NSArray *permissions = [[NSArray alloc] initWithObjects:
//                                @"user_photos",
//                                @"publish_stream",
//                                nil];
//        [appDelegate.facebook authorize:permissions];
//    }
}

#pragma mark -- FBSessionDelegate Event Handlers --
//-(void)fbDidLogin
//{
//    
////    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
////
////    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
////    [defaults setObject:[appDelegate.facebook accessToken] forKey:@"FBAccessTokenKey"];
////    [defaults setObject:[appDelegate.facebook expirationDate] forKey:@"FBExpirationDateKey"];
////    
//    [self.loginViewDelegate facebookLoginSuccessful];
//    
//    [self dismissModalViewControllerAnimated:YES];
//}

//-(void)fbDidNotLogin:(BOOL)cancelled
//{
//    NSLog(@"fbDidNotLogin:");
//}
//
//-(void)fbDidLogout
//{
//    NSLog(@"fbDidLogout:");
//}
//
//-(void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt
//{
//    NSLog(@"fbDidExtendToken:");
//}
//
//-(void)fbSessionInvalidated
//{
//    NSLog(@"fbSessionInvalidated:");
//}


// ADDED NEXT TWO METHODS FROM FB SITE
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            [[FBRequest requestForMe] startWithCompletionHandler:
             ^(FBRequestConnection *connection,
               NSDictionary<FBGraphUser> *user,
               NSError *error) {
                 if (!error) {
                     //                     self.userNameLabel.text = user.name;
                     //                     self.userProfileImage.profileID = user.id;
                     AppDelegate * appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                     
                     [appDelegate setFirstName:user.first_name];
                     [appDelegate setLastName:user.last_name];
                     [appDelegate setMyUserID:user.id];
                     NSLog(@"User ID %@", user.id);
                     //             NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                     
                     //             [appDelegate setFirstName:[prefs objectForKey:@"first_name"]];
                     //             [appDelegate setLastName:[prefs objectForKey:@"last_name"]];
                     //             [appDelegate setMyUserID:[prefs objectForKey:@"uid"]];
                     
                     
                     
                     NSLog(@"Name %@", user.first_name);
                     [self.loginViewDelegate facebookLoginSuccessful];
                     //
                         [self dismissModalViewControllerAnimated:YES];
                 }
             }];
            
            //            UIViewController *topViewController =
            //            [self.navController topViewController];
            //            if ([[topViewController modalViewController]
            //                 isKindOfClass:[SCLoginViewController class]]) {
            //                [topViewController dismissModalViewControllerAnimated:YES];
            //            }
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            // Once the user has logged in, we want them to
            // be looking at the root view.
            //            [self.navController popToRootViewControllerAnimated:NO];
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
            //            [self showLoginView];
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)openSession
{
    [FBSession openActiveSessionWithReadPermissions:nil
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
}

@end
