//
//  HaikuBrewHomePageTableViewController.m
//  HaikuBrew
//
//  Created by Brian Ellison on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HaikuBrewHomePageTableViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "NeedsActionTableCell.h"
#import "InProgressTableCell.h"
#import "BrewedTableCell.h"
#import "UIImageView+WebCache.h"
#import "InboxTableCell.h"

@implementation HaikuBrewHomePageTableViewController
@synthesize brewsByBrewingAndBrewed, allBrews, inboxBrews, homePageViewController;
@synthesize indexPathToHide;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)getHaikuBrewsForUserDidStart:(NSString *)userId
{
    NSLog(@"GetHaikubrews START");
    [self.homePageViewController showSpinnerWithMessage:@"Loading Haikus"];
}

-(void)getHaikuBrewsDidFail:(NSString *)reason
{
    NSLog(@"GetHaikubrews FAILED");
    [self.homePageViewController dismissSpinner];
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:0.0];
    
}

- (void)getHaikuBrewsDidSucceed:(NSMutableArray *)haikuBrews
{
    NSLog(@"GetHaikubrews SUCCEED");
    [self.homePageViewController dismissSpinner];
    self.allBrews = haikuBrews;
    [self recategorizeBrewedAndBrewing];
    [self.tableView reloadData];
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:0.0];
    
}

- (void) recategorizeBrewedAndBrewing
{
//    NSMutableArray *brewedArray = [[NSMutableArray alloc] initWithObjects: nil];
//    NSMutableArray *brewingArray = [[NSMutableArray alloc] initWithObjects: nil];
//    for(int i = 0; i < [self.allBrews count]; i ++)
//    {
//        Haiku *haiku = [self.allBrews objectAtIndex:i];
//        if([haiku isBrewing])
//        {
//            
//            [brewingArray addObject:haiku];
//        }
//        else
//        {  
//            [brewedArray addObject:haiku];
//        }
//    }
//    
//    [self setBrewsByBrewingAndBrewed:nil];
//    self.brewsByBrewingAndBrewed = [[NSMutableDictionary alloc] init];
//    [self.brewsByBrewingAndBrewed setValue:brewingArray forKey:@"BREWING"];
//    [self.brewsByBrewingAndBrewed setValue:brewedArray forKey:@"BREWED"];
    
    [self setInboxBrews:nil];
    self.inboxBrews = [[NSMutableArray alloc] init];
    NSMutableArray *yourBrewHaikus = [[NSMutableArray alloc] initWithObjects: nil];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    for (Haiku *haiku in self.allBrews) {
        if( [haiku isBrewing]  &&  [haiku needsAttentionForUser:appDelegate.myUserID])
            [self.inboxBrews addObject:haiku];
        else {
            [yourBrewHaikus addObject:haiku];
        }
    }
    
    [homePageViewController setYourBrewsHaikus:yourBrewHaikus];
}


- (void)refresh
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    GetBaseDataManager *getBaseDataManager = [[GetBaseDataManager alloc] init];
    [getBaseDataManager setDelegate:self];
    
    if(appDelegate.myUserID != nil)
        [getBaseDataManager getHaikuBrewsForUser:appDelegate.myUserID];
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {	
	return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 30;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//      
//    CGRect headerFrame = CGRectMake(0, 0, self.tableView.frame.size.width, 24);
//    UIView *headerView = [[UIView alloc] initWithFrame:headerFrame];
//    
//    CGRect imageFrame = CGRectMake(10, 5, 158.5, 24);
//    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:imageFrame];
//    [headerImageView setImage:[UIImage imageNamed:@"BrewInbox.png"]];
//    
//    CGRect bubbleImageFrame = CGRectMake(176, 0, 17, 15);
//    UIImageView *bubbleImageView = [[UIImageView alloc] initWithFrame:bubbleImageFrame];
//    [bubbleImageView setImage:[UIImage imageNamed:@"bubble.png"]];
//    
//    
//    CGRect labelFrame;
//    if(self.inboxBrews.count > 9)
//    {
//        labelFrame= CGRectMake(180, 1, 12, 10);
//    }
//    else {
//        labelFrame= CGRectMake(182, 1, 12, 10);
//    }
//    
//    UILabel *bubbleLabel = [[UILabel alloc] initWithFrame:labelFrame];
//    [bubbleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:10]];
//    [bubbleLabel setBackgroundColor:[UIColor clearColor]];
//    [bubbleLabel setTextColor:[UIColor whiteColor]];
//    [bubbleLabel setText:[NSString stringWithFormat:@"%i", self.inboxBrews.count]];
//    
//    [headerView addSubview:headerImageView];
//    [headerView addSubview:bubbleImageView];
//    [headerView addSubview:bubbleLabel];
//    
//    return headerView;
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
    // Return the number of rows in the sections
//    if(section == 0)
//    {
//        NSMutableArray *array = [self.brewsByBrewingAndBrewed objectForKey:@"BREWING"];
//        
//        return [array count];
//    }
//    else
//    {
//        NSMutableArray *array = [self.brewsByBrewingAndBrewed objectForKey:@"BREWED"];
//        return [ array count];
//    }
    self.homePageViewController.lblBrewInboxCount.text = [NSNumber numberWithInt:self.inboxBrews.count].stringValue;
    return self.inboxBrews.count; 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyCellCCell";
    
    Haiku *haiku = [self.inboxBrews objectAtIndex:indexPath.row];

    //Retrieve or initialize a cell for our use
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //Set properties on the cell
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"InboxTableCell" owner:nil options:nil];
    for( id currentObject in topLevelObjects )
    {
        if( [currentObject isKindOfClass:[UITableViewCell class]] )
        {
            //NeedsActionTableCell *customCell = (NeedsActionTableCell *)currentObject;
            InboxTableCell *customCell = (InboxTableCell *)currentObject;
            customCell.selectionStyle = UITableViewCellSelectionStyleNone;
            customCell.lblTitle.text = haiku.title;
            
            int lastLineNumber = [haiku getNextHaikuLineNumber] - 1;
            HaikuLine *lastLine = [haiku getHaikuLine:lastLineNumber];
            NSString *sentFromText = [[NSString alloc] initWithFormat:@"%@ has sent you a haiku!", lastLine.firstName];
            customCell.lblSentFrom.text = sentFromText;
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", lastLine.userId]];
            [customCell.ivFacebookImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"iPhone - Profile Icon Background.png"]];
            
            cell = customCell;
            
            
            return cell;
        }
    }
    return cell;
//            else
//            {
                //IN PROGRESS CELL
//                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"InProgressTableCell%@", suffix] owner:nil options:nil];
//                
//                for( id currentObject in topLevelObjects )
//                {
//                    if( [currentObject isKindOfClass:[UITableViewCell class]] )
//                    {
//                        InProgressTableCell *customCell = (InProgressTableCell *)currentObject;
//                        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
//                        customCell.lblTitle.text = haiku.title;
//                        customCell.lblSubTitle.text = [NSString stringWithFormat:@"Waiting on %@ to write the next line!", [haiku getNextUserFirstName]];
//                        
//                        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", [haiku getNextUserId]]];
//                        [customCell.imgFacebookProfile setImageWithURL:url placeholderImage:[UIImage imageNamed:@"iPhone - Profile Icon Background.png"]];
//                        
//                        cell = customCell;
//                        break;
//                    }
//                }
//            }
//        }
//        else
//        {
            //BREWED CELL
//            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"BrewedTableCell%@", suffix] owner:nil options:nil];
//            
//            for( id currentObject in topLevelObjects )
//            {
//                if( [currentObject isKindOfClass:[UITableViewCell class]] )
//                {
//                    BrewedTableCell *customCell = (BrewedTableCell *)currentObject;
//                    customCell.selectionStyle = UITableViewCellSelectionStyleNone;
//                    customCell.lblTitle.text = haiku.title;
//                    
//                    
//                    // TODO - The following code needs to be reworked
//                    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//                    NSString *brewedWith = @"Brewed with ";
//                    int brewedWithNumber = 0;
//                    if(! [haiku.haikuLine1.userId isEqualToString:appDelegate.myUserID])
//                    {
//                        if(brewedWithNumber == 0)
//                            brewedWith = [NSString stringWithFormat:@"%@ %@",brewedWith,haiku.haikuLine1.firstName];
//                        else
//                            brewedWith = [NSString stringWithFormat:@"%@ and %@",brewedWith,haiku.haikuLine1.firstName];
//                        brewedWithNumber ++;
//                    }
//                    
//                    if(! [haiku.haikuLine2.userId isEqualToString:appDelegate.myUserID])
//                    {
//                        if(brewedWithNumber == 0)
//                            brewedWith = [NSString stringWithFormat:@"%@ %@",brewedWith,haiku.haikuLine2.firstName];
//                        else
//                            brewedWith = [NSString stringWithFormat:@"%@ and %@",brewedWith,haiku.haikuLine2.firstName];
//                        brewedWithNumber ++;
//                    }
//                    
//                    if(! [haiku.haikuLine3.userId isEqualToString:appDelegate.myUserID])
//                    {
//                        if(brewedWithNumber == 0)
//                            brewedWith = [NSString stringWithFormat:@"%@ %@",brewedWith,haiku.haikuLine3.firstName];
//                        else
//                            brewedWith = [NSString stringWithFormat:@"%@ and %@",brewedWith,haiku.haikuLine3.firstName];
//                        brewedWithNumber ++;
//                    }
//                    
//                    
//                    
//                    customCell.lblSubTitle.text = brewedWith;
//                    
//                    
//                    NSURL *url1 = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", haiku.haikuLine1.userId]];
//                    [customCell.imgFacebookProfile1 setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"iPhone - Profile Icon Background.png"]];
//                    
//                    NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", haiku.haikuLine2.userId]];
//                    [customCell.imgFacebookProfile2 setImageWithURL:url2 placeholderImage:[UIImage imageNamed:@"iPhone - Profile Icon Background.png"]];
//                    
//                    NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", haiku.haikuLine3.userId]];
//                    [customCell.imgFacebookProfile3 setImageWithURL:url3 placeholderImage:[UIImage imageNamed:@"iPhone - Profile Icon Background.png"]];
//                    
//                    
//                    
//                    cell = customCell;
//                    break;
//                }
//            }
//        }
//    
//    return cell;
}



 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 


 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
     if (editingStyle == UITableViewCellEditingStyleDelete) {
         // Delete the row from the data source
//         NSMutableArray *valuesForBrewedOrBrewing = nil;
//         if(indexPath.section == 0)
//         {
//             valuesForBrewedOrBrewing = [self.brewsByBrewingAndBrewed objectForKey:@"BREWING"];
//         }
//         else
//         {
//             valuesForBrewedOrBrewing = [self.brewsByBrewingAndBrewed objectForKey:@"BREWED"];
//         }
         
         Haiku *haiku = [self.inboxBrews objectAtIndex:indexPath.row];
         GetBaseDataManager *getBaseDataManager = [[GetBaseDataManager alloc] init];
         [getBaseDataManager setHideHaikuDelegate:self];
         self.indexPathToHide = indexPath;
         [getBaseDataManager hideHaiku:haiku];

         
    }   
     else if (editingStyle == UITableViewCellEditingStyleInsert) {
         // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }   
 }
 

-(void)hideHaikuDidFail
{
    NSLog(@"Hide Failed");
    [self.homePageViewController dismissSpinner];
}

- (void)hideHaikuDidStart
{
    [self.homePageViewController showSpinnerWithMessage: @"Hiding Haiku"];
    NSLog(@"Hide Started");
}

- (void)hideHaikuDidComplete
{
//    NSMutableArray *valuesForBrewedOrBrewing = nil;
//    if(self.indexPathToHide.section == 0)
//    {
//        valuesForBrewedOrBrewing = [self.brewsByBrewingAndBrewed objectForKey:@"BREWING"];
//    }
//    else
//    {
//        valuesForBrewedOrBrewing = [self.brewsByBrewingAndBrewed objectForKey:@"BREWED"];
//    }
    
    Haiku *haiku = [self.inboxBrews objectAtIndex:self.indexPathToHide.row];
    [self.allBrews removeObject:haiku];
    [self.inboxBrews removeObject:haiku];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.indexPathToHide] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadData];
    [self.homePageViewController dismissSpinner];
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */




#pragma mark - Table view delegate
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Delete Haiku";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSArray *valuesForBrewedOrBrewing = nil;
//    if(indexPath.section == 0)
//    {
//        valuesForBrewedOrBrewing = [self.brewsByBrewingAndBrewed objectForKey:@"BREWING"];
//    }
//    else
//    {
//        valuesForBrewedOrBrewing = [self.brewsByBrewingAndBrewed objectForKey:@"BREWED"];
//    }
    
    Haiku *haiku = [self.inboxBrews objectAtIndex:indexPath.row ];
    SuperPageViewController *superPageViewController = [[SuperPageViewController alloc] initWithNibName:@"SuperPageViewController" bundle:nil andHaiku:haiku];
    [superPageViewController setIsCaptureMode:NO];

    [self.homePageViewController.navigationController pushViewController:superPageViewController animated:YES];
}



@end
