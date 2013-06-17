//
//  DIsplayMessageViewController.m
//  Quick Budg
//
//  Created by Haiku Brew on 2/13/12.
//  Copyright (c) 2012 Haiku Brew. All rights reserved.
//

#import "DIsplayMessageViewController.h"
@implementation DIsplayMessageViewController
@synthesize messageLabel;
@synthesize roundedCornersView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.roundedCornersView.layer.cornerRadius = 9.0;
    self.roundedCornersView.layer.masksToBounds = YES;

}

- (void)viewDidUnload
{
    [self setMessageLabel:nil];
    [self setRoundedCornersView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
