//
//  ConfirmViewController.m
//  HaikuBrew
//
//  Created by Brian Ellison on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ConfirmViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface ConfirmViewController ()

@end

@implementation ConfirmViewController
@synthesize lblConfirmText;
@synthesize btnOk;
@synthesize borderColor;
@synthesize backgroundView;
@synthesize confirmViewDelegate;
@synthesize messageToUser;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil borderColor:(UIColor *) _borderColor withLabelText:(NSString *) _lableText withConfirmViewDelegate:(NSObject<ConfirmViewControllerDelegate> *) _confirmViewDelegate
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setConfirmViewDelegate:_confirmViewDelegate];
        [self setBorderColor:_borderColor];
        [self setMessageToUser:_lableText];
        
    }
    return self;
}

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
    
    self.backgroundView.layer.cornerRadius = 9.0;
    self.backgroundView.layer.masksToBounds = YES;
    self.backgroundView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.backgroundView.layer.borderWidth = 3.0;
    
    self.lblConfirmText.text = self.messageToUser;
}

- (void)viewDidUnload
{
    [self setLblConfirmText:nil];
    [self setBtnOk:nil];
    [self setBackgroundView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)pressBtnOk:(id)sender {
    [confirmViewDelegate performSelectorOnMainThread:@selector(confirmViewControllerDismissed) withObject:nil waitUntilDone:NO];
}
@end
