//
//  HomePageViewController.m
//  HaikuBrew
//
//  Created by John Watson on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomePageViewController.h"
#import "FacebookLoginViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "BrewingHeader_iPhoneViewController.h"

@implementation HomePageViewController
@synthesize viInboxHeaderView;
@synthesize btnLogout;
@synthesize postToFacebook;
@synthesize needsRefresh;

@synthesize btnAdd;
@synthesize imgTitleBar;
@synthesize refreshButton;
@synthesize tableView;
@synthesize btnPostToWall;
@synthesize activityIndicator, needsAttentionImage, inProgressImage, brewedImage, spinnerViewController, haikuBrewTableViewController, yourBrewsViewController;

@synthesize internetReachable = _internetReachable;
@synthesize hostReachable = _hostReachable;
@synthesize lblBrewInboxCount;

@synthesize haiku = _haiku;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.needsRefresh = YES;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) facebookLoginSuccessful
{
//    NSLog(@"Facebook Login");
//    AppDelegate * appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    [appDelegate.facebook requestWithGraphPath:@"me?fields=id,first_name,last_name" andDelegate:self];
    
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.spinnerViewController showSpinnerWithMessage:@"Loading"];

    self.haikuBrewTableViewController = [[HaikuBrewHomePageTableViewController alloc] init];
    CGRect rect = CGRectMake(0, 90, 320, 165);
    [self.haikuBrewTableViewController setHomePageViewController:self];
    [self.haikuBrewTableViewController.tableView setFrame:rect];
    

    [self.view addSubview:self.haikuBrewTableViewController.tableView];
    [self.view bringSubviewToFront:self.imgTitleBar];
    [self.view bringSubviewToFront:self.btnPostToWall];
    [self.view bringSubviewToFront:self.btnAdd];
    [self.view bringSubviewToFront:self.btnLogout];
  
    self.needsAttentionImage = [UIImage imageNamed:@"iPhone - Needs Attention.png"];
    self.inProgressImage = [UIImage imageNamed:@"iPhone - In Progress.png"];
    self.brewedImage = [UIImage imageNamed:@"iPhone - Brewed.png"];
    
    FacebookLoginViewController *login = [[FacebookLoginViewController alloc] initWithNibName:@"FacebookLoginViewController_iPhone" bundle:nil];
    [login setLoginViewDelegate:self];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (appDelegate.session.isOpen) {
        // valid account UI is shown whenever the session is open
//        [self.buttonLoginLogout setTitle:@"Log out" forState:UIControlStateNormal];
//        [self.textNoteOrLink setText:[NSString stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@",
//                                      appDelegate.session.accessTokenData.accessToken]];
        [self facebookLoginSuccessful];
    } else {
        // login-needed account UI is shown whenever the session is closed
        [self presentModalViewController:login animated:NO];
    }

    
//    if(appDelegate.session.is)
//    [appDelegate.facebook setSessionDelegate:self];
//    if( ![appDelegate.facebook isSessionValid] )
//        [self presentModalViewController:login animated:NO];
//    else
//        [self facebookLoginSuccessful];
//    
//    self.viInboxHeaderView =  [[BrewingHeader_iPhoneViewController alloc] initWithNibName:@"BrewingHeader_iPhone" bundle:nil];
//    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"BrewingHeader_iPhone" owner:nil options:nil];
//    for( id currentObject in topLevelObjects )
//    {
//        if( [currentObject isKindOfClass:[UIView class]] )
//        {
//                       
//            BrewingHeader_iPhoneViewController *view = currentObject;
//            self.viInboxHeaderView = view;
//        }
//    }

    
    
}


- (void) viewDidAppear:(BOOL)animated
{
//    [super viewDidAppear:animated];
    
    if( self.needsRefresh )
    {
        [self.haikuBrewTableViewController refresh];
        self.needsRefresh = NO;
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    self.internetReachable = [Reachability reachabilityForInternetConnection];
    [self.internetReachable startNotifier];
    
    self.hostReachable = [Reachability reachabilityWithHostName:@"www.haikubrew.com"];
    [self.hostReachable startNotifier];
}

- (void) checkNetworkStatus:(NSNotification *)notice
{
    NetworkStatus internetStatus = [self.internetReachable currentReachabilityStatus];
    NetworkStatus hostStatus = [self.hostReachable currentReachabilityStatus];
    
    switch (internetStatus) {
        case NotReachable:
            NSLog(@"=== Internet Not Reachable ===");
            break;
        case ReachableViaWiFi:
            NSLog(@"=== Internet available via WiFi ===");
            break;
        case ReachableViaWWAN:
            NSLog(@"=== Internet available via WWAN ===");
            break;
        default:
            break;
    }
    
    switch (hostStatus) {
        case NotReachable:
            NSLog(@"=== Host www.haikubrew.com Not Reachable ===");
            break;
        case ReachableViaWiFi:
            NSLog(@"=== Host www.haikubrew.com available via WiFi ===");
            break;
        case ReachableViaWWAN:
            NSLog(@"=== Host www.haikubrew.com available via WWAN ===");
            break;
        default:
            break;
    }
}

- (void) showSpinnerWithMessage:(NSString *) message
{
    if(self.spinnerViewController == nil)
    {
        self.spinnerViewController = [[SpinnerViewController alloc] initWithNibName:@"SpinnerViewController" bundle:nil];
        [self.spinnerViewController setParentView:self.view];
    }
        [self.spinnerViewController showSpinnerWithMessage:message];

}
- (void) dismissSpinner
{
    [self.spinnerViewController dismissSpinner];
    self.spinnerViewController = nil;
}





- (void)viewDidUnload
{
    [self setActivityIndicator:nil];
    [self setTableView:nil];
    [self setRefreshButton:nil];
    [self setBtnPostToWall:nil];
    [self setBtnAdd:nil];
    [self setImgTitleBar:nil];
    [self setBtnLogout:nil];
    [self setViInboxHeaderView:nil];
    [self setLblBrewInboxCount:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)btnAddClick:(id)sender 
{
    //TODO add camera controller to start Haiku
    SuperPageViewController *viewController = [[SuperPageViewController alloc] initWithNibName:@"SuperPageViewController" bundle:nil andHaiku:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}



//#pragma mark -- Facebook SSO Redirect Handlers --
//-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    return [appDelegate.facebook handleOpenURL:url];
//}
//
//-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    return [appDelegate.facebook handleOpenURL:url];
//}
//
//
//#pragma mark -- FBRequestDelegate Event Handlers --
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
//
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
//    [self.haikuBrewTableViewController refresh];
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
//
//
//
//
//#pragma mark - FBSessionDelegate Methods
///**
// * Called when the user has logged in successfully.
// */
//
//
//- (void)storeAuthData:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
//    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
//    [defaults synchronize];
//}
//
//
///**
// * Called when the request logout has succeeded.
// */
//- (void)fbDidLogout {
//    
//    // Remove saved authorization information if it exists and it is
//    // ok to clear it (logout, session invalid, app unauthorized)
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults removeObjectForKey:@"FBAccessTokenKey"];
//    [defaults removeObjectForKey:@"FBExpirationDateKey"];
//    [defaults synchronize];
//    
//    FacebookLoginViewController *login = [[FacebookLoginViewController alloc] initWithNibName:@"FacebookLoginViewController_iPhone" bundle:nil];
//    [login setLoginViewDelegate:self];
//    
//    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    [appDelegate.facebook setSessionDelegate:self];
//    if( ![appDelegate.facebook isSessionValid] )
//        [self presentModalViewController:login animated:NO];
//    else
//        [self facebookLoginSuccessful];
//}
//
///**
// * Called when the session has expired.
// */
//- (void)fbSessionInvalidated {
//    [self fbDidLogout];
//}
//
//
//- (IBAction)pressedPostToWall:(id)sender {
//    SBJSON *jsonWriter = [SBJSON new];
//    
//    // The action links to be shown with the post in the feed
//    NSArray* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                      @"Get Started",@"name",@"http://www.haikubrew.com/",@"link", nil], nil];
//    NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
//    // Dialog parameters
//    //TODO add teh picture in after link line
//    //TODO when the post is complete... let the user know.
//    //@"http://www.facebookmobileweb.com/hackbook/img/facebook_icon_large.png", @"picture",
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                   @"I'm using the Haiku Brew for iOS app", @"name",
//                                   @"Haiku Brew for iOS.", @"caption",
//                                   @"Check out Haiku Brew for iOS to create Haikus with your friends.", @"description",
//                                   @"http://www.haikubrew.com/", @"link",
//                                   actionLinksStr, @"actions",
//                                   nil];
//    
//    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [[delegate facebook] dialog:@"feed"
//                      andParams:params
//                    andDelegate:self];
//    
//}
//
//
///**
// * Called when the user successfully logged in.
// */
//- (void)fbDidLogin
//{
//    
//}
//
///**
// * Called after the access token was extended. If your application has any
// * references to the previous access token (for example, if your application
// * stores the previous access token in persistent storage), your application
// * should overwrite the old access token with the new one in this method.
// * See extendAccessToken for more details.
// */
//- (void)fbDidExtendToken:(NSString*)accessToken
//               expiresAt:(NSDate*)expiresAt
//{
//    
//}
//
///**
// * Called when the user dismissed the dialog without logging in.
// */
//- (void)fbDidNotLogin:(BOOL)cancelled
//{
//    
//}
//
//
//
//#pragma mark - FBDialogDelegate Methods
//
///**
// * Called when a UIServer Dialog successfully return. Using this callback
// * instead of dialogDidComplete: to properly handle successful shares/sends
// * that return ID data back.
// */
//- (void)dialogCompleteWithUrl:(NSURL *)url {
//    if (![url query]) {
//        NSLog(@"User canceled dialog or there was an error");
//        return;
//    }
//    
//    NSDictionary *params = [self parseURLParams:[url query]];
//
//    // Successful posts return a post_id
//    if ([params valueForKey:@"post_id"]) {
//        NSLog(@"Feed post ID: %@", [params valueForKey:@"post_id"]);
//    }
// }
//
//- (void)dialogDidNotComplete:(FBDialog *)dialog {
//    NSLog(@"Dialog dismissed.");
//}
//
//- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError *)error {
//    NSLog(@"didFailWithError: Error message: %@", [[error userInfo] objectForKey:@"error_msg"]);
//
//}
//

/**
 * Helper method to parse URL query parameters
 */
- (NSDictionary *)parseURLParams:(NSString *)query {
	NSArray *pairs = [query componentsSeparatedByString:@"&"];
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	for (NSString *pair in pairs) {
		NSArray *kv = [pair componentsSeparatedByString:@"="];
		NSString *val =
        [[kv objectAtIndex:1]
         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
		[params setObject:val forKey:[kv objectAtIndex:0]];
	}
    return params;
}


-(void) setYourBrewsHaikus:(NSMutableArray *) pYourBrewHaikus
{
    if(self.yourBrewsViewController == nil)
    {
        self.yourBrewsViewController = [[YourBrewsViewController alloc] init];
        [self.yourBrewsViewController.view setFrame:CGRectMake(4, 265, 311, 195)];
    }
    [self.yourBrewsViewController setYourHaikuBrews:pYourBrewHaikus];
    
    [self.view addSubview:self.yourBrewsViewController.view];
    
    [self.yourBrewsViewController loadAllHaikus];
    
}

- (IBAction)pressBtnLogout:(id)sender {
//    AppDelegate * appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    [appDelegate.facebook logout:self];
}

@end
