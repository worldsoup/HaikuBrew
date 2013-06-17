//
//  SpinnerViewController.m
//  nodalTrack
//
//  Created by Haiku Brew on 7/25/11.
//  Copyright 2011 Haiku Brew. All rights reserved.
//

#import "SpinnerViewController.h"

@implementation SpinnerViewController

@synthesize spinner, parentView, height,width, loadingLabel, roundedView, loadingText;

- (id)initWithParentView:(UIView *)parent withLabel:(NSString *) ploadingText
{
    self = [super initWithNibName:@"SpinnerViewController" bundle:nil];
    if(self)
    {
        self.parentView = parent;
        self.loadingText = ploadingText;
//        self.height = self.parentView.frame.size.height;
//        self.width = self.parentView.frame.size.width;
        
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
    self.view.frame = self.parentView.frame;
    [self.roundedView.layer setCornerRadius:30.f];
    self.loadingLabel.text = self.loadingText;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.spinner = nil;
    self.parentView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

#pragma mark - custom methods

- (void) showSpinnerWithMessage:(NSString *) message
{
    self.loadingLabel.text = message;
    [self showSpinner];
}
- (void) showSpinner
{
    if(parentView == nil)
        return;
    
    [self.view setHidden:NO];
    
    [parentView addSubview:self.view];
    [parentView bringSubviewToFront:self.view];
    
    [self.spinner startAnimating];
    // fade the view in
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:.2];
    [UIView commitAnimations];
}

- (void) dismissSpinner
{
    if(parentView == nil)
        return;

    [self.spinner stopAnimating];
    [self.view setHidden:YES];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:.2];
    [self.view  setAlpha:0.0f];
    [self.spinner setAlpha:0.0f];
    [UIView commitAnimations];

    
}
@end
