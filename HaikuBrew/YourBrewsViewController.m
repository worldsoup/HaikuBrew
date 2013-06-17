//
//  YourBrewsViewController.m
//  HaikuBrew
//
//  Created by John Watson on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YourBrewsViewController.h"
#import "Haiku.h"
#import "UIImageView+WebCache.h"
#import <objc/runtime.h>
#import "SuperPageViewController.h"
#import "AppDelegate.h"
#import "YourBrewsIndividualImageViewController.h"

@interface YourBrewsViewController ()

@end

@implementation YourBrewsViewController
@synthesize yourHaikuBrews;
@synthesize scrlYourBrews;

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
    self.scrlYourBrews.delegate = self;
    
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    
    
}

- (void) loadAllHaikus
{
    NSArray *sortedArray = [self.yourHaikuBrews sortedArrayUsingComparator:^(id a, id b) {
        NSDate *first = [(Haiku*)a modifiedDate];
        NSDate *second = [(Haiku*)b modifiedDate];
        return [second compare:first];
    }];
    self.yourHaikuBrews = [sortedArray mutableCopy];

    recycledPages = [[NSMutableSet alloc] init];
    visiblePages  = [[NSMutableSet alloc] init];
    
    int xPosition = 5;
    for(int counter = 0; counter < self.yourHaikuBrews.count; counter ++)
    {
        Haiku *haiku = [self.yourHaikuBrews objectAtIndex:counter];
        YourBrewsIndividualImageViewController *yourBrewImage = [[YourBrewsIndividualImageViewController alloc] initWithNibName:@"YourBrewsIndividualImageViewController" bundle:nil withHaiku:haiku];
        
        UIView *holderView = [[UIView alloc] initWithFrame:CGRectMake(xPosition, 5, 96, 152)];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
        [tapRecognizer setNumberOfTapsRequired:1];
        [tapRecognizer setDelegate:self];
        [holderView addGestureRecognizer:tapRecognizer];
        // set an associated object with the Tap
        objc_setAssociatedObject(tapRecognizer, @"HaikuObject", haiku, OBJC_ASSOCIATION_RETAIN);
                    
        [holderView addSubview:yourBrewImage.view];
        [self.scrlYourBrews addSubview:holderView];
        xPosition = xPosition + yourBrewImage.view.frame.size.width + 5;
    }
    
    [self.scrlYourBrews setContentSize:CGSizeMake(xPosition, self.scrlYourBrews.frame.size.height)];
}


- (void) tapImage:(UITapGestureRecognizer *) theTap
{
    // get the associated object with the tap
    Haiku *haiku = objc_getAssociatedObject(theTap, @"HaikuObject");
    
    SuperPageViewController *superPageViewController = [[SuperPageViewController alloc] initWithNibName:@"SuperPageViewController" bundle:nil andHaiku:haiku];
    [superPageViewController setIsCaptureMode:NO];
    AppDelegate * appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.homePageViewController.navigationController pushViewController:superPageViewController animated:YES];
}



/*- (void)tilePages 
{
    // Calculate which pages are visible
    CGRect visibleBounds = self.scrlYourBrews.bounds;
    int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
    int lastNeededPageIndex  = floorf((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds));
    firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
    lastNeededPageIndex  = MIN(lastNeededPageIndex, self.yourHaikuBrews.count - 1);
    
    // Recycle no-longer-visible pages 
    for (UIView *page in visiblePages) {
        if (page.index < firstNeededPageIndex || page.index > lastNeededPageIndex) {
            [recycledPages addObject:page];
            [page removeFromSuperview];
        }
    }
    [visiblePages minusSet:recycledPages];
    
    // add missing pages
    for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) {
        if (![self isDisplayingPageForIndex:index]) {
            ImageScrollView *page = [self dequeueRecycledPage];
            if (page == nil) {
                page = [[[ImageScrollView alloc] init] autorelease];
            }
            [self configurePage:page forIndex:index];
            [pagingScrollView addSubview:page];
            [visiblePages addObject:page];
        }
    }    
}*/






- (void)viewDidUnload
{
    [self setScrlYourBrews:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
