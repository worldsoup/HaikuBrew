//
//  NewHomeTableViewController.m
//  HaikuBrew
//
//  Created by Brian Ellison on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewHomeTableViewController.h"
#import "Haiku.h"
#import "BrewTableViewCell.h"
#import "SuperPageViewController.h"
#import "NewHomeViewController.h"
#import "UIImage+StackBlur.h"

@interface NewHomeTableViewController ()

@end

@implementation NewHomeTableViewController
@synthesize brews;
@synthesize homeViewController;
@synthesize indexPathToHide;
@synthesize haikuToDelete;
@synthesize postToWhoKnowsWhat;
@synthesize blurredImageView;
@synthesize displayMessageViewController;
@synthesize lastRowImagName;

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
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


//Refresh is called on pull down
- (void)refresh
{
    [self.homeViewController refresh];
    
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.row == (self.brews.count + 1))
        return 70;
    else
        return 324;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
    return self.brews.count + 1; 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyCellCCell";
    
    
    //Retrieve or initialize a cell for our use
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSLog(@"Count : %i Row: %i", self.brews.count, indexPath.row);
    
    if(indexPath.row == (self.brews.count))
    {
        NSLog(@"Last Row");
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.lastRowImagName]]  ;
        [imageView setFrame:CGRectMake(0, 15, 320, 44)];
        [cell addSubview:imageView];
        return cell;
    }
    Haiku *haiku = [self.brews objectAtIndex:indexPath.row];
    
    //Set properties on the cell
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"BrewTableViewCell" owner:nil options:nil];
    for( id currentObject in topLevelObjects )
    {
        if( [currentObject isKindOfClass:[UITableViewCell class]] )
        {
            BrewTableViewCell *customCell = (BrewTableViewCell *)currentObject;
            customCell.tableViewController = self;
            customCell.haiku = haiku;
            
            customCell.lblWho.text = [haiku getTableViewHaikuTextUnderImage];

            
            if(haiku.backGroundImageData == nil)
            {
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", haiku.backGroundImage]];
                [customCell.ivHaikuImage setImageWithURL:url placeholderImage:nil withHaiku:haiku];
            }
            else{
                [customCell.ivHaikuImage setImage:haiku.backGroundImageData];
            }
            
            
            
            if([haiku isBrewing])
                [customCell.btnPost setHidden:YES];
            
            
            cell = customCell;
             [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            return cell;
        }
    }
    return cell;

}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


#pragma mark - Table view delegate
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Delete Haiku";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Haiku *haiku = [self.brews objectAtIndex:indexPath.row ];
    BrewTableViewCell *cell = (BrewTableViewCell *) [self.tableView cellForRowAtIndexPath:indexPath];
    [haiku setBackGroundImageData:cell.ivHaikuImage.image];
    
    SuperPageViewController *superPageViewController = [[SuperPageViewController alloc] initWithNibName:@"SuperPageViewController" bundle:nil andHaiku:haiku];
    [superPageViewController setIsCaptureMode:NO];
    
    [self.homeViewController.navigationController pushViewController:superPageViewController animated:YES];
}


- (void) deleteHaiku:(Haiku *) haiku
{
    self.haikuToDelete = haiku;
    [self imageWithView:self.homeViewController.view];
    
    UIAlertView *replay = [[UIAlertView alloc] initWithTitle:@"Confirm Delete Haiku" message:@"Are you sure you want to delete this Haiku?" 
                                                    delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
    
    [replay show];
}

#pragma mark UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	// NO = 0, YES = 1
    [UIView animateWithDuration:.5
                     animations:^{
                         self.blurredImageView.alpha = 0.0;
                     } 
                     completion:^(BOOL finished){
                         [self.blurredImageView removeFromSuperview];
                     }];
    
    
	if(buttonIndex == 0)
    {
        return;
    }
    else {
        [self deleteHaikuConfirmed];
    }
}

- (void) deleteHaikuConfirmed
{
    [self.homeViewController showMessageWithText:@"Deleting Haiku"];
    
    int indexOfDelete = [self.brews indexOfObject:self.haikuToDelete];
    NSIndexPath *path = [NSIndexPath indexPathForRow:indexOfDelete inSection:0] ;
    
    GetBaseDataManager *getBaseDataManager = [[GetBaseDataManager alloc] init];
    [getBaseDataManager setHideHaikuDelegate:self];
    self.indexPathToHide = path;
    [getBaseDataManager hideHaiku:self.haikuToDelete];
    
  
}

-(void)hideHaikuDidFail
{
    NSLog(@"Hide Failed");
    [self.homeViewController dismissLoadingView];
//    [self.homePageViewController dismissSpinner];
}

- (void)hideHaikuDidStart
{
    
//    NSLog(@"Hide Started");
}

- (void)hideHaikuDidComplete
{
    Haiku *haiku = [self.brews objectAtIndex:self.indexPathToHide.row ];
    [self.brews removeObject:haiku];
    [self.tableView deleteRowsAtIndexPaths:[[NSArray alloc] initWithObjects:self.indexPathToHide, nil] withRowAnimation:UITableViewRowAnimationFade];
    
    [self.homeViewController updateLabels];
    [self.homeViewController dismissLoadingView];
}


- (void) postToFacebook:(Haiku *)haiku
{
    
    self.postToWhoKnowsWhat = [[PostToWhoKnowsWhat alloc] initWithObjects:haiku.backGroundImageData withHaiku:haiku withView:self.homeViewController.view withNaviationController:self.homeViewController.navigationController withDelegate:self];
    [self.postToWhoKnowsWhat displayPostToWhoKnowsWhat];

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
    
    [self.homeViewController.view addSubview:self.blurredImageView];

}


-(void) displayMessageViewController:(NSString *) _message
{
    [self displayMessageViewController:_message andPop:[NSNumber numberWithBool:NO]];
    
}
-(void) displayMessageViewController:(NSString *) _message andPop:(NSNumber *) isPop
{
    CGRect display = CGRectMake(0, self.homeViewController.view.frame.size.height + 4, self.view.frame.size.width, 44);
    
    if(self.displayMessageViewController == nil)
    {
        self.displayMessageViewController = [[DIsplayMessageViewController alloc] initWithNibName:@"DIsplayMessageViewController" bundle:nil] ;
        self.displayMessageViewController.view.frame = display;
        
        [self.displayMessageViewController.messageLabel setText:_message];
        [self.homeViewController.view addSubview:self.displayMessageViewController.view];
        
    }
    self.displayMessageViewController.view.frame = display;
    
    __block NSNumber *blockIsPop = isPop;
    [self.displayMessageViewController.messageLabel setText:_message];
    [UIView animateWithDuration:.8 
                     animations:^{
                         CGRect rect = self.displayMessageViewController.view.frame;
                         rect.origin.y = self.displayMessageViewController.view.frame.origin.y - self.displayMessageViewController.view.frame.size.height -4 ;
                         self.displayMessageViewController.view.frame = rect;
                         
                         
                         
                     } 
                     completion:^(BOOL finished){
                         [self performSelector:@selector(hideMessageViewController:) withObject:blockIsPop afterDelay:1.0];
                     }
     ];
}


-(void) hideMessageViewController:(NSNumber *) isPop
{
    CGRect offDisplay = CGRectMake(0, self.homeViewController.view.frame.size.height + 6, self.view.frame.size.width, 44);
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
//                             [self.theNavController popViewControllerAnimated:YES];
                         }
                     }
     ];
}


@end
