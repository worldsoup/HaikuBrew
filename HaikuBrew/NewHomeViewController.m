//
//  NewHomeViewController.m
//  HaikuBrew
//
//  Created by Brian Ellison on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewHomeViewController.h"
#import "AppDelegate.h"

@interface NewHomeViewController ()

@end

@implementation NewHomeViewController
@synthesize lblInboxCount;
@synthesize viInbox;
@synthesize viOutbox;
@synthesize viBrewed;

@synthesize ivPointer;
@synthesize visScrollView;
@synthesize allBrews;
@synthesize inboxTable, outboxTable, brewedTable;
@synthesize spinner;
@synthesize superPageViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


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
                     
                     [self refresh];
                     
                     NSLog(@"Name %@", user.first_name);
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
            
            [self showLoginView];
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


- (void) showLoginView {
    FacebookLoginViewController *login = [[FacebookLoginViewController alloc] initWithNibName:@"FacebookLoginViewController_iPhone" bundle:nil];
    [login setLoginViewDelegate:self];
    [self presentModalViewController:login animated:NO];
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];

    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        // Yes, so just open the session (this won't display any UX).
        [self openSession];
    } else {
        // No, display the login page.
        // login-needed account UI is shown whenever the session is closed
        [self showLoginView];
    }
    
    if (appDelegate.session.isOpen) {
        // valid account UI is shown whenever the session is open
        //        [self.buttonLoginLogout setTitle:@"Log out" forState:UIControlStateNormal];
        //        [self.textNoteOrLink setText:[NSString stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@",
        //                                      appDelegate.session.accessTokenData.accessToken]];
        
//        [self facebookLoginSuccessful];
    } else {

    }
   
    
//    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    [appDelegate.facebook setSessionDelegate:self];
//    if( ![appDelegate.facebook isSessionValid] )
//    {
//        FacebookLoginViewController *login = [[FacebookLoginViewController alloc] initWithNibName:@"FacebookLoginViewController_iPhone" bundle:nil];
//        [login setLoginViewDelegate:self];
//        [self presentModalViewController:login animated:NO];
//    }
//    else
//    {
//        [self facebookLoginSuccessful];
//    }

    self.viBrewed.alpha = .5;
    self.viInbox.alpha = 1.0;
    self.viOutbox.alpha = .5;
    
    [self.visScrollView setDelegate:self];
    
    UITapGestureRecognizer *inBoxTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
    [inBoxTapRecognizer setNumberOfTapsRequired:1];
    [inBoxTapRecognizer setDelegate:self];
    [self.viInbox setUserInteractionEnabled:YES];
    [self.viInbox addGestureRecognizer:inBoxTapRecognizer];
    
    UITapGestureRecognizer *outBoxTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
    [outBoxTapRecognizer setNumberOfTapsRequired:1];
    [outBoxTapRecognizer setDelegate:self];
    [self.viOutbox setUserInteractionEnabled:YES];
    [self.viOutbox addGestureRecognizer:outBoxTapRecognizer];
    
    UITapGestureRecognizer *brewedBoxTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
    [brewedBoxTapRecognizer setNumberOfTapsRequired:1];
    [brewedBoxTapRecognizer setDelegate:self];
    [self.viBrewed setUserInteractionEnabled:YES];
    [self.viBrewed addGestureRecognizer:brewedBoxTapRecognizer];
    
    
    self.inboxTable = [[NewHomeTableViewController alloc] initWithStyle:UITableViewStylePlain];
    self.inboxTable.homeViewController = self;
    self.inboxTable.lastRowImagName = @"ConceptE - Inbox Home Screen Table Cell Message.png";
    self.inboxTable.view.frame = CGRectMake(0,0,self.visScrollView.frame.size.width, self.visScrollView.frame.size.height);
    [self.visScrollView addSubview:self.inboxTable.view];
    
    self.outboxTable = [[NewHomeTableViewController alloc] initWithStyle:UITableViewStylePlain];
    self.outboxTable.homeViewController = self;
    self.outboxTable.lastRowImagName = @"ConceptE - Outbox Home Screen Table Cell Message.png";
    self.outboxTable.view.frame = CGRectMake(self.visScrollView.frame.size.width,0,self.visScrollView.frame.size.width, self.visScrollView.frame.size.height);
    [self.visScrollView addSubview:self.outboxTable.view];
    
    self.brewedTable = [[NewHomeTableViewController alloc] initWithStyle:UITableViewStylePlain];
    self.brewedTable.homeViewController = self;
    self.brewedTable.lastRowImagName = @"ConceptE - Brewed Home Screen Table Cell Message.png";
    self.brewedTable.view.frame = CGRectMake(self.visScrollView.frame.size.width * 2,0,self.visScrollView.frame.size.width, self.visScrollView.frame.size.height);
    [self.visScrollView addSubview:self.brewedTable.view];
    
    [self.visScrollView setContentSize:CGSizeMake(self.visScrollView.frame.size.width * 3, self.visScrollView.frame.size.height)];
    
    
    
       
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    RunBlockAfterDelay(0, ^{
        self.superPageViewController = [[SuperPageViewController alloc] initWithNibName:@"SuperPageViewController" bundle:nil andHaiku:nil];
    });
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.visScrollView.frame.size.width;
//    int page = floor((self.visScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
//    if([self.visScrollView isDragging] && [self.visScrollView isDecelerating])
//        [self goToPage:[NSNumber numberWithInt:page]];
    
    
        static NSInteger previousPage = 0;
        float fractionalPage = sender.contentOffset.x / pageWidth;
        NSInteger newPage = lround(fractionalPage);
        if (previousPage != newPage) {
            // Page has changed
            // Do your thing!
            previousPage = newPage;
            [self goToPage:[NSNumber numberWithInt:( newPage )] whileScrolling:YES];
        }
    
    
}








- (void) tapImage:(UITapGestureRecognizer *) tapGest
{
    if([tapGest.view isEqual:self.viInbox])
    {
        [self goToPage:[NSNumber numberWithInt:0] whileScrolling:NO];
    }
    else if([tapGest.view isEqual:self.viOutbox])
    {
        [self goToPage:[NSNumber numberWithInt:1] whileScrolling:NO];
    }
    else if([tapGest.view isEqual:self.viBrewed])
    {
       [self goToPage:[NSNumber numberWithInt:2] whileScrolling:NO];
    }
}
- (void) goToPage:(NSNumber *) pageNum whileScrolling:(BOOL) isScrolling
{
    
    CGRect ivPointerFrame = self.ivPointer.frame;

    if(pageNum.intValue == 0)
    {
        ivPointerFrame.origin.x = (viInbox.frame.size.width / 2) + viInbox.frame.origin.x - (ivPointerFrame.size.width / 2) ;
        
        [UIView animateWithDuration:.4
                         animations:^{
                             self.viBrewed.alpha = .5;
                             self.viInbox.alpha = 1.0;
                             self.viOutbox.alpha = .5;
                         } 
                         completion:^(BOOL finished){
                             
                         }];
        
        if(!isScrolling)
            [self.visScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else if(pageNum.intValue == 1)
    {
        ivPointerFrame.origin.x  = (viOutbox.frame.size.width / 2) + viOutbox.frame.origin.x - (ivPointerFrame.size.width / 2) ;
       
        [UIView animateWithDuration:.4
                         animations:^{
                             self.viBrewed.alpha = .5;
                             self.viInbox.alpha = .5;
                             self.viOutbox.alpha = 1.0;
                         } 
                         completion:^(BOOL finished){
                             
                         }];
        
        if(!isScrolling)
        [self.visScrollView setContentOffset:CGPointMake( self.outboxTable.view.frame.origin.x, 0) animated:YES];
    }
    else if(pageNum.intValue == 2)
    {
        ivPointerFrame.origin.x = (viBrewed.frame.size.width / 2) + viBrewed.frame.origin.x - (ivPointerFrame.size.width / 2) ;
        
        [UIView animateWithDuration:.4
                         animations:^{
                             self.viBrewed.alpha = 1.0;
                             self.viInbox.alpha = .5;
                             self.viOutbox.alpha = .5;
                         } 
                         completion:^(BOOL finished){
                             
                         }];
        
        
        if(!isScrolling)
            [self.visScrollView setContentOffset:CGPointMake( self.brewedTable.view.frame.origin.x,0 ) animated:YES];
    }
    [UIView animateWithDuration:.3
                     animations:^{
                         self.ivPointer.frame = ivPointerFrame;
                     } 
                     completion:^(BOOL finished){
                         
                     }];
    
}


# pragma  mark GetHaikuBrews Delegate Methods
- (void)getHaikuBrewsForUserDidStart:(NSString *)userId
{
    NSLog(@"GetHaikubrews START");
    // Start the spinner
    [self showMessageWithText:@"Loading Haikus"];
    
}

-(void)getHaikuBrewsDidFail:(NSString *)reason
{
    NSLog(@"GetHaikubrews FAILED");
    
    // Stop the spinner
    [self.inboxTable stopLoading];
    [self.outboxTable stopLoading];
    [self.brewedTable stopLoading];
    [self dismissLoadingView];
}

- (void)getHaikuBrewsDidSucceed:(NSMutableArray *)haikuBrews
{
    NSLog(@"GetHaikubrews SUCCEED");
   // STop THE SPINNER
    // [self performSelector:@selector(stopLoading) withObject:nil afterDelay:0.0];
    self.allBrews = haikuBrews;
    [self recategorizeBrewedAndBrewing];
    [self.inboxTable stopLoading];
    [self.outboxTable stopLoading];
    [self.brewedTable stopLoading];
    [self dismissLoadingView];
       
}

- (void) recategorizeBrewedAndBrewing
{    
    NSMutableArray *inboxBrews = [[NSMutableArray alloc] init];
    NSMutableArray *outboxBrews = [[NSMutableArray alloc] initWithObjects: nil];
    NSMutableArray *brewedBrews = [[NSMutableArray alloc] initWithObjects: nil];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    for (Haiku *haiku in self.allBrews) {
        if( [haiku isBrewing]  &&  [haiku needsAttentionForUser:appDelegate.myUserID])
            [inboxBrews addObject:haiku];
        else {
            if([haiku isBrewed])
            {
                [brewedBrews addObject:haiku];
            }
            else {
                [outboxBrews addObject:haiku];
            }
            
        }
    }
    
   
    
    self.inboxTable.brews = inboxBrews;
    self.outboxTable.brews = outboxBrews;
    self.brewedTable.brews = brewedBrews;
    
    [self updateLabels];
    
    [self refreshTables];
}

- (void) updateLabels
{
    self.lblInboxCount.text = [NSNumber numberWithInt:self.inboxTable.brews.count].stringValue;
  
}

- (void) refreshTables
{
    [self.inboxTable.tableView reloadData];
    [self.outboxTable.tableView reloadData];
    [self.brewedTable.tableView reloadData];
}


- (void) facebookLoginSuccessful
{
    NSLog(@"Facebook Login");
     
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
             
             [self refresh];
             
             NSLog(@"Name %@", user.first_name);
         }
         else{
             
             NSLog(@"Name %@", error.debugDescription);
         }
     }];
   
}


#pragma mark -- Facebook SSO Redirect Handlers --
//-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
////    return [appDelegate.facebook handleOpenURL:url];
//}
//
//-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
////    return [appDelegate.facebook handleOpenURL:url];
//}


#pragma mark -- FBRequestDelegate Event Handlers --
//-(void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
//{
//    
//    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
//    
//    if ([httpResponse statusCode] >= 400) {
//        // do error handling here
//        NSLog(@"remote url returned error %d %@",[httpResponse statusCode],[NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]);
//    } else {
//        // start recieving data
//    }
//    
//    NSHTTPURLResponse *myResponse = (NSHTTPURLResponse *)response;
//    NSLog(@"%@", [myResponse allHeaderFields]);
//    
//    
//    NSLog(@"requestdidReceiveResponse: %@", response.description);
//    
//    
//}

//-(void)requestLoading:(FBRequest *)request
//{
//    NSLog(@"requestLoading:");
//}
//
//-(void)request:(FBRequest *)request didLoad:(id)result
//{
//    NSLog(@"requestdidLoad:");
//    NSString* uid = [result objectForKey:@"id"];
//    NSString* first_name = [result objectForKey:@"first_name"];
//    NSString* last_name = [result objectForKey:@"last_name"];
//    NSLog(@"UID %@, first_name:%@, last_name:%@", uid, first_name, last_name);
//    
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    // saving an NSString
//    [prefs setObject:uid forKey:@"uid"];
//    [prefs setObject:first_name forKey:@"first_name"];
//    [prefs setObject:last_name forKey:@"last_name"];
//    [prefs synchronize];
//    
//    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    [appDelegate setFirstName:first_name];
//    [appDelegate setLastName:last_name];
//    [appDelegate setMyUserID:uid];
//    
//
//    [self refresh];
//    
//}
//
//-(void)request:(FBRequest *)request didLoadRawResponse:(NSData *)data
//{
//    NSLog(@"requestdidLoadRawResponse: %@", data);
//}
//
//-(void)request:(FBRequest *)request didFailWithError:(NSError *)error
//{
//    NSLog(@"requestdidFailWithError:");
//}




#pragma mark - FBSessionDelegate Methods
/**
 * Called when the user has logged in successfully.
 */


- (void)storeAuthData:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}


/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout {
    
    // Remove saved authorization information if it exists and it is
    // ok to clear it (logout, session invalid, app unauthorized)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    FacebookLoginViewController *login = [[FacebookLoginViewController alloc] initWithNibName:@"FacebookLoginViewController_iPhone" bundle:nil];
    [login setLoginViewDelegate:self];
    
//    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    [appDelegate.facebook setSessionDelegate:self];
//    if( ![appDelegate.facebook isSessionValid] )
//        [self presentModalViewController:login animated:NO];
//    else
//        [self facebookLoginSuccessful];
}

/**
 * Called when the session has expired.
 */
- (void)fbSessionInvalidated {
    [self fbDidLogout];
}


/**
 * Called when the user successfully logged in.
 */
- (void)fbDidLogin
{
    
}

/**
 * Called after the access token was extended. If your application has any
 * references to the previous access token (for example, if your application
 * stores the previous access token in persistent storage), your application
 * should overwrite the old access token with the new one in this method.
 * See extendAccessToken for more details.
 */
- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt
{
    
}

/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)fbDidNotLogin:(BOOL)cancelled
{
    
}


- (IBAction)pressBtnLogout:(id)sender {
    
    [FBSession.activeSession closeAndClearTokenInformation];
    
    AppDelegate * appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [appDelegate setFirstName:nil];
    [appDelegate setLastName:nil];
    [appDelegate setMyUserID:nil];
    
    [self showLoginView];
//    AppDelegate * appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    [appDelegate.facebook logout];
//    appDelegate.facebook = [[Facebook alloc] initWithAppId: @"149371725183092" andDelegate:nil];
//    [appDelegate.facebook setSessionDelegate:self];
}


- (void)viewDidUnload
{
    [self setViInbox:nil];
    [self setViOutbox:nil];
    [self setViBrewed:nil];
    [self setLblInboxCount:nil];
    [self setIvPointer:nil];
    [self setVisScrollView:nil];
    
    [self setViInbox:nil];
    [self setViOutbox:nil];
    [self setViBrewed:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)refresh
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    GetBaseDataManager *getBaseDataManager = [[GetBaseDataManager alloc] init];
    [getBaseDataManager setDelegate:self];
    
    if(appDelegate.myUserID != nil)
        [getBaseDataManager getHaikuBrewsForUser:appDelegate.myUserID];
    
}


- (void) showMessageWithText:(NSString *) textToDisplay
{
    self.spinner = [[SpinnerViewController alloc] initWithParentView:self.view withLabel:textToDisplay];
    [self.spinner showSpinnerWithMessage:textToDisplay];

    
}

- (void) dismissLoadingView
{
    [self.spinner dismissSpinner];
    self.spinner = nil;
}

- (IBAction)pressBtnNewHaiku:(id)sender {
    if(self.superPageViewController == nil)
    {
        self.superPageViewController = [[SuperPageViewController alloc] initWithNibName:@"SuperPageViewController" bundle:nil andHaiku:nil];
    }
    [self.navigationController pushViewController:self.superPageViewController animated:YES];
}


- (void) updateHaikuInStack:(Haiku *) haikuToUpdate
{
    RunBlockAfterDelay(0.8, ^{
        int indexOfDelete = [self.inboxTable.brews indexOfObject:haikuToUpdate];
        NSIndexPath *path = [NSIndexPath indexPathForRow:indexOfDelete inSection:0] ;
        
        [self.inboxTable.brews removeObject:haikuToUpdate];
        [self.inboxTable.tableView deleteRowsAtIndexPaths:[[NSArray alloc] initWithObjects:path, nil] withRowAnimation:UITableViewRowAnimationFade];
        [self updateLabels];
        
        RunBlockAfterDelay(.4, ^{
            if([haikuToUpdate isBrewed])
            {
                if (self.brewedTable.brews.count > 0)
                {
                   [self.brewedTable.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
                
                [self goToPage:[NSNumber numberWithInt:2] whileScrolling:NO];
                [self.visScrollView setContentOffset:CGPointMake( self.brewedTable.view.frame.origin.x, 0) animated:YES];
                RunBlockAfterDelay(.4, ^{
                    [self.brewedTable.brews insertObject:haikuToUpdate atIndex:0];
                    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0] ;
                    [self.brewedTable.tableView insertRowsAtIndexPaths:[[NSArray alloc] initWithObjects:path, nil] withRowAnimation:UITableViewRowAnimationFade];
                    [self updateLabels];

                });
            }
            else {
                if(self.outboxTable.brews.count > 0)
                {
                     [self.outboxTable.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
                
                [self goToPage:[NSNumber numberWithInt:1] whileScrolling:NO];
                [self.visScrollView setContentOffset:CGPointMake( self.outboxTable.view.frame.origin.x, 0) animated:YES];
                RunBlockAfterDelay(.4, ^{
                    [self.outboxTable.brews insertObject:haikuToUpdate atIndex:0];
                    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0] ;
                    [self.outboxTable.tableView insertRowsAtIndexPaths:[[NSArray alloc] initWithObjects:path, nil] withRowAnimation:UITableViewRowAnimationFade];
                    [self updateLabels];
                });
            }
        });
    });
    

    
    
}


// This only gets called when a new Haiku is added.  It goes directly to the Outbox stack.
- (void) addHaikuToStack:(Haiku *) haikuToAdd
{
    [self goToPage:[NSNumber numberWithInt:1] whileScrolling:NO];
    [self.visScrollView setContentOffset:CGPointMake( self.outboxTable.view.frame.origin.x, 0) animated:YES];
    
    
    RunBlockAfterDelay(.7, ^{
        [self.allBrews addObject:haikuToAdd];
        
        [self.outboxTable.brews insertObject:haikuToAdd atIndex:0];
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0] ;
        [self.outboxTable.tableView insertRowsAtIndexPaths:[[NSArray alloc] initWithObjects:path, nil] withRowAnimation:UITableViewRowAnimationFade];
        [self updateLabels];
    });

}


- (void) removeHaikuFromBrewedHaikus:(Haiku *) haikuToDelete
{
    RunBlockAfterDelay(3.5, ^{
        int indexOfDelete = [self.brewedTable.brews indexOfObject:haikuToDelete];
        NSIndexPath *path = [NSIndexPath indexPathForRow:indexOfDelete inSection:0] ;
        
        [self.brewedTable.brews removeObject:haikuToDelete];
        [self.brewedTable.tableView deleteRowsAtIndexPaths:[[NSArray alloc] initWithObjects:path, nil] withRowAnimation:UITableViewRowAnimationFade];
        
        [self.allBrews removeObject:haikuToDelete];
        [self updateLabels];
    });
}


void RunBlockAfterDelay(NSTimeInterval delay, void (^block)(void))
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*delay),
                   dispatch_get_current_queue(), block);
}

@end
