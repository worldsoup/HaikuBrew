//
//  SelectFacebookFriendViewController.m
//  HaikuBrew
//
//  Created by Brian Ellison on 3/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectFacebookFriendViewController.h"
#import "AppDelegate.h"
#import "FacebookUser.h"
#import <FacebookSDK/FBRequest.h>
#import "SelectFacebookFriendTableCell.h"
#import "UIImageView+WebCache.h"
#import "UIImage+StackBlur.h"

@implementation SelectFacebookFriendViewController
@synthesize btnPlay;
@synthesize btnInvite;
@synthesize btnCancel;
@synthesize btnNext;
@synthesize lblHaikuTo;
@synthesize table, btnShareToWall,btnFriendsWithApp,btnFriendsWithoutApp, searchBar;
@synthesize friendsNotUsingAppList, friendsUsingAppList,selectedUser;
@synthesize spinnerViewController;
@synthesize isUpdate, haiku;
@synthesize searchedTableData;
@synthesize confirmViewController, blurredImageView;

UITapGestureRecognizer *backgroundTap;


typedef enum selectFacebookPageStatust {
    kPageLoadedStatus,  
    kCalToServerSuccess,
    kCallToFacebookSuccess,
    kCallToFacebookFailed
} selectFacebookPageStatust;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andHaiku:(Haiku *)_haiku
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.haiku = _haiku;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    selectedSegmentIndex = 1;
    self.btnPlay.layer.cornerRadius = 9.0;
    self.btnPlay.layer.masksToBounds = YES;
    self.btnPlay.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnPlay.layer.borderWidth = 1.0;
    
    saveToServerSuccess = false;
    postToFacebookSuccess = false;
    
    [self.table setDelegate:self];
    [self.table setDataSource:self];
    
    [self.btnNext setEnabled:NO];
    
    
    [self reloadFriendsFromFacebook];
    
    
    backgroundTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap)];
    backgroundTap.cancelsTouchesInView = NO;
    
    self.searchedTableData = [self getCurrentListOfFriends];
    NSLog(@"searchedTableData count: %i", self.searchedTableData.count);
    NSLog(@"getCurrentListOfFriends count: %i", [[self getCurrentListOfFriends] count]);
}

- (void) reloadFriendsFromFacebook
{
    [self showLoadingWithLabel:@"Loading Friends"];
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    NSString *pRequestString = @"me/friends?fields=first_name,last_name,installed";
    
    [[FBRequest requestForGraphPath:pRequestString ] startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if(!error)
        {
            NSArray *items = [(NSDictionary *)result objectForKey:@"data"];
            self.friendsUsingAppList = [[NSMutableArray alloc] initWithObjects: nil];
            self.friendsNotUsingAppList = [[NSMutableArray alloc] initWithObjects: nil];
            for (int i=0; i<[items count]; i++) {
                NSDictionary *friend = [items objectAtIndex:i];
                NSString *fbid = [friend objectForKey:@"id"];
                NSString *first_name = [friend objectForKey:@"first_name"];
                NSString *last_name = [friend objectForKey:@"last_name"];
                BOOL isInstalled = [(NSNumber *)[friend objectForKey: @"installed"] boolValue];
                
                FacebookUser *user = [[FacebookUser alloc] init];
                [user setFirst_name:first_name];
                [user setLast_name:last_name];
                [user setUserId:fbid];
                [user setIsUsingApp:isInstalled];
                
                if(isInstalled)
                    [self.friendsUsingAppList addObject:user];
                else
                    [self.friendsNotUsingAppList addObject:user];
                
            }
            
            [self.friendsUsingAppList sortUsingComparator:
             ^(FacebookUser *obj1, FacebookUser *obj2)
             {
                 NSString* key1 = obj1.first_name;
                 NSString* key2 = obj2.first_name;
                 return [key1 compare: key2];
             }];
            
            [self.friendsNotUsingAppList sortUsingComparator:
             ^(FacebookUser *obj1, FacebookUser *obj2)
             {
                 NSString* key1 = obj1.first_name;
                 NSString* key2 = obj2.first_name;
                 return [key1 compare: key2];
             }];
            
            self.searchedTableData = [self getCurrentListOfFriends];
            [self dismissLoading];
            [self.table reloadData];
        }
        else
        {
            //    [self hideActivityIndicator];
            NSLog(@"Error message: %@", [[error userInfo] objectForKey:@"error_msg"]);
            //[self showMessage:@"Oops, something went haywire."];
            [self.spinnerViewController showSpinnerWithMessage:@"Trying Facebook again..."];
            [self reloadFriendsFromFacebook];

        }
    }];
//    [FBRequest requestWithGraphPath:@"me/friends?fields=first_name,last_name,installed" andDelegate:self];
}

- (void)viewDidUnload
{
    [self setBtnCancel:nil];
    [self setBtnNext:nil];
    [self setLblHaikuTo:nil];
    [self setBtnPlay:nil];
    [self setBtnInvite:nil];
    [self setBtnPlay:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return NO;
}

-(void) backgroundTap
{
    [self.view removeGestureRecognizer:backgroundTap];
    [self.searchBar resignFirstResponder];
}


- (IBAction)touchCancelButton:(id)sender {

        [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)touchNextButton:(id)sender {
    if(!saveToServerSuccess)
        [self friendSelected:self.selectedUser];
    else {
        if(!postToFacebookSuccess)
            [self sendToNewUser:self.selectedUser];
    }
//DONT USE THiS IT SHOULD BE CALLED IN THE RETURN DELEGATE METHOD    [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableArray *) getCurrentListOfFriends
{
    if(selectedSegmentIndex == 0)
    {
        return [[NSMutableArray alloc] initWithArray:self.friendsNotUsingAppList];
    }
    else {
        return [[NSMutableArray alloc] initWithArray:self.friendsUsingAppList];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    // if a valid search was entered but the user wanted to cancel, bring back the main list content
    [self.searchedTableData removeAllObjects];
    [self.searchedTableData addObjectsFromArray:[self getCurrentListOfFriends]];
    @try{
        [self.table reloadData];
    }
    @catch(NSException *e){
    }
    
    [self.view removeGestureRecognizer:backgroundTap];
    [self.searchBar resignFirstResponder];
    self.searchBar.text = @"";
}
// called when Search (in our case “Done”) button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view removeGestureRecognizer:backgroundTap];
    [self.searchBar resignFirstResponder];
}

#pragma mark - UISearchBar Delegate Methods
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // only show the status bar’s cancel button while in edit mode
    self.searchBar.showsCancelButton = YES;
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    
    [self.view addGestureRecognizer:backgroundTap];
    // flush the previous search content
    [searchedTableData removeAllObjects];
    searchedTableData = [self getCurrentListOfFriends];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    self.searchBar.showsCancelButton = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.searchedTableData removeAllObjects];// remove all data that belongs to previous search
    if([searchText isEqualToString:@""] || searchText==nil){
        self.searchedTableData = [self getCurrentListOfFriends];
        [self.lblHaikuTo setText:[NSString stringWithFormat:@"Haiku To: "]];
        [self.table reloadData];
        return;
    }

    for(FacebookUser *user in [self getCurrentListOfFriends])
    {
        NSString *firstName = user.first_name;
        NSString *lastName = user.last_name;
        NSRange firstNameRange = [[firstName uppercaseString] rangeOfString:[searchText uppercaseString]];
        NSRange lastNameRange = [[lastName uppercaseString] rangeOfString:[searchText uppercaseString]];
        if(firstNameRange.location != NSNotFound)
        {
            if(firstNameRange.location== 0)//that is we are checking only the start of the names.
            {
                [self.searchedTableData addObject:user];
            }
        }
        if(lastNameRange.location != NSNotFound)
        {
            if(lastNameRange.location== 0)//that is we are checking only the start of the names.
            {
                [self.searchedTableData addObject:user];
            }
        }
    }
    [self.table reloadData];
}

#pragma mark - UITableViewDatasource and UITableViewDelegate Methods

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.searchedTableData count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MyCellCCell";
    
    
    // The API title
    FacebookUser *user;
    if( [self.searchedTableData count] == 0 )
    {
        int x = 0;
        x++;
    }
    user = [self.searchedTableData objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [self.table dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //Determine device-specific nib to use
        NSString *suffix;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            suffix = @"_iPhone";
        } else {
            suffix = @"_iPad";
        }
        
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"SelectFacebookFriendTableCell%@", suffix] owner:nil options:nil];
        
        for( id currentObject in topLevelObjects )
        {
            if( [currentObject isKindOfClass:[UITableViewCell class]] )
            {
                SelectFacebookFriendTableCell *customCell = (SelectFacebookFriendTableCell *)currentObject;
                customCell.lblUserName.text = [NSString stringWithFormat:@"%@ %@", user.first_name, user.last_name];
                
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", user.userId]];
                
                [customCell.imgFacebookProfileImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"iPhone - Profile Icon Background.png"]];
                if([self.selectedUser.userId isEqualToString: user.userId])
                {
                    [customCell.imgCheck setHidden:NO];
                }
                else {
                       [customCell.imgCheck setHidden:YES];
                    }
                
                cell = customCell;
                return customCell;
            }
        }
    }
    else {
       
    }
   return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FacebookUser *user;

    user = [self.searchedTableData objectAtIndex:indexPath.row];
    self.selectedUser = user;
    [self.btnNext setEnabled:YES];
    [self.lblHaikuTo setText:[NSString stringWithFormat:@"Haiku To: %@ %@", user.first_name, user.last_name]];
    [self.table reloadData];

}


#pragma mark Loading Methods
- (void) showLoadingWithLabel:(NSString *) label
{
    if(self.spinnerViewController == nil)
    {
        self.spinnerViewController =  [[SpinnerViewController alloc] initWithParentView:self.view withLabel:label];
        [self.spinnerViewController setParentView:self.view];

    }
    [self.spinnerViewController showSpinnerWithMessage:label];
}
- (void) dismissLoading
{
    [self.spinnerViewController dismissSpinner];
    self.spinnerViewController = nil;
}


#pragma mark -- CreateHaikuBrewsDelegate Event Handlers --
-(void)createHaikuBrewsDidStart:(NSString *)userId
{
//    NSLog(@"createHaikuBrewsDidStart");
    [self showLoadingWithLabel:@"Creating Haiku"];
}

-(void)createHaikuBrewsDidSucceed:(Haiku *)haiku
{
//    NSLog(@"createHaikuBrewsDidSucceed");
    saveToServerSuccess = true;
    [self dismissLoading];
    [self sendToNewUser:self.selectedUser];
}

-(void)createHaikuBrewsDidFail:(NSString *)reason
{
//    NSLog(@"createHaikuBrewsDidFail");  
    saveToServerSuccess = false;
    [self dismissLoading];
}



#pragma mark -- UpdateHaikuBrewsDelegate Event Handlers --
-(void)updateHaikuBrewsDidStart:(NSString *)userId
{
//    NSLog(@"UPDATE STARETED");
    
    [self showLoadingWithLabel:@"Updating Haiku"];
}

-(void)updateHaikuBrewsDidSucceed:(Haiku *)haiku
{
//    NSLog(@"UPDATED SUCCEED");
    saveToServerSuccess = true;
    [self dismissLoading];
    [self sendToNewUser:self.selectedUser];
}

-(void)updateHaikuBrewsDidFail:(NSString *)reason
{
    NSLog(@"UPDATE FAIL");   
    saveToServerSuccess = false;
    [self dismissLoading];
}



- (void) friendSelected:(FacebookUser *) facebookUser
{
    NSLog(@"%d",[self.haiku getNextHaikuLineNumber]);
    if([self.haiku getNextHaikuLineNumber] == 1)
    {
        self.haiku.haikuLine2 = [[HaikuLine alloc] init];
        [self.haiku.haikuLine2 setUserId:facebookUser.userId];
        [self.haiku.haikuLine2 setFirstName:facebookUser.first_name];
        [self.haiku.haikuLine2 setLastName:facebookUser.last_name];
 
        
    }
    else if([self.haiku getNextHaikuLineNumber] == 2)
    {
        self.haiku.haikuLine3 = [[HaikuLine alloc] init];
        [self.haiku.haikuLine3 setUserId:facebookUser.userId];
        [self.haiku.haikuLine3 setFirstName:facebookUser.first_name];
        [self.haiku.haikuLine3 setLastName:facebookUser.last_name];
    }

    [self submitHaiku];
}

- (void)submitHaiku
{
    GetBaseDataManager *manager = [[GetBaseDataManager alloc] init];
    
    if(self.isUpdate)
    {
        [manager setUpdateDelegate:self];
        if([self.haiku getNextHaikuLineNumber] == 2)
        {
            [manager updateHaikuLineTwo:self.haiku];
        }
        //Line 3 is handled in the super page.  It should never get here if line 3 is in being submitted.
    }
    else
    {
        [manager setCreateDelegate:self];
        [manager createHaikuBrews:self.haiku];
    }
}


/*
 * Dialog: Requests - send to select users, in this case friends
 * that are currently using the app.
 */
- (void)sendToExistingUsers:(NSArray *)selectIDs {
    NSString *selectIDsStr = [selectIDs componentsJoinedByString:@","];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"It's your turn to write a line for this Haiku.",  @"message",
                                   selectIDsStr, @"suggestions",
                                   nil];
    
//    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[FBRequest requestWithGraphPath: @"newsfeed"
                         parameters: params
                         HTTPMethod: @"POST"]startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if(!error)
        {
            postToFacebookSuccess = true;
            [self showConfirmMessage:@"Your Haiku has been Brewed!" withColor:[UIColor greenColor]];
        }
        else {
        postToFacebookSuccess = false;
            [self showConfirmMessage:@"Facebook Request has not been sent" withColor:[UIColor yellowColor]];
        }
    }];
}

/*
 * Dialog: Request - send to a targeted friend.
 */
- (void)sendToNewUser:(FacebookUser *)user {
    NSString *messageTouser;
    if([user isUsingApp])
    {
        messageTouser = @"You have a Haiku Brewing!!  Write the next line now!!";
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       messageTouser,  @"message",
                                       user.userId, @"to",
                                       @"1",@"frictionless",
                                       nil];
        [params setObject: @"1" forKey:@"frictionless"];
        //    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [[FBRequest requestWithGraphPath: @"me/apprequests"
                              parameters: params
                              HTTPMethod: @"POST"] startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            NSLog(@"%@",error);
            if(!error)
            {
                postToFacebookSuccess = true;
                [self showConfirmMessage:@"Your Haiku has been Brewed!" withColor:[UIColor greenColor]];
            }
            else {
                postToFacebookSuccess = false;
                [self showConfirmMessage:@"Facebook Request has not been sent" withColor:[UIColor yellowColor]];
            }
        }];
    }
    else
    {
        messageTouser = @"Let's Brew a Haiku together!!";
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:user.userId, @"to",nil];
        
        [FBWebDialogs
         presentRequestsDialogModallyWithSession:nil
         message:messageTouser
         title:nil
         parameters:params
         handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
             if (error) {
                 postToFacebookSuccess = false;
                 [self showConfirmMessage:@"Facebook Request has not been sent" withColor:[UIColor yellowColor]];
                 // Error launching the dialog or sending the request.
                 NSLog(@"Error sending request.");
             } else {
                     NSLog(@"Request sent.");
                     postToFacebookSuccess = true;
                     [self showConfirmMessage:@"Your Haiku has been Brewed!" withColor:[UIColor greenColor]];
                 }
         }];
    }
}


- (void)showConfirmMessage:(NSString *) message withColor:(UIColor *) theColor
{
    [self imageWithView:self.view];
    
    if(self.confirmViewController == nil)
    {
        self.confirmViewController = [[ConfirmViewController alloc] initWithNibName:@"ConfirmViewController" bundle:nil borderColor:theColor withLabelText:message withConfirmViewDelegate:self];
    }
    
    self.confirmViewController.view.alpha = 0;
    [self.view addSubview:self.confirmViewController.view];
    
    
    [UIView animateWithDuration:.5
                     animations:^{
                         self.confirmViewController.view.alpha = 1.0;
                     } 
                     completion:^(BOOL finished){
                         
                     }];
}


- (void) confirmViewControllerDismissed
{
    
    [self dismissConfirmMessage];
    
}
- (void) dismissConfirmMessage
{
    
    [UIView animateWithDuration:.5
                     animations:^{
                         self.confirmViewController.view.alpha = 0.0;
                         self.blurredImageView.alpha = 0.0;
                     } 
                     completion:^(BOOL finished){
                         [self.confirmViewController.view removeFromSuperview];
                         [self.blurredImageView removeFromSuperview];
                         self.confirmViewController = nil;
                     }];
    
    
    if(saveToServerSuccess && postToFacebookSuccess)
    {
        for (id view in self.navigationController.viewControllers) {
            if( [view isKindOfClass:[NewHomeViewController class]] )
            {
                NewHomeViewController *newHomeVC = ((NewHomeViewController *)view);
                if(self.isUpdate)
                {
                    [newHomeVC updateHaikuInStack:self.haiku];
                }
                else {
                    [newHomeVC addHaikuToStack:self.haiku];
                }
            }
        }
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (IBAction)pressBtnPlay:(id)sender {
    
    selectedSegmentIndex = 1;
    [self getCurrentListOfFriends];
    self.searchedTableData = [self getCurrentListOfFriends];
    [self.table reloadData];
}

- (IBAction)pressBtnInvite:(id)sender {
    selectedSegmentIndex = 0;
    [self getCurrentListOfFriends];
    self.searchedTableData = [self getCurrentListOfFriends];
    [self.table reloadData];
}
- (void) imageWithView:(UIView *)view
{
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    self.blurredImageView = [[UIImageView alloc] initWithFrame:view.frame];
    UIImage *theIm = [img stackBlur:7];
    self.blurredImageView.image = theIm;
    
    self.blurredImageView.alpha = 0;
    
    [UIView animateWithDuration:.5
                     animations:^{
                         self.blurredImageView.alpha = 1.0;
                     } 
                     completion:^(BOOL finished){
                     }];
    
    [self.view addSubview:self.blurredImageView];
    
}

@end
