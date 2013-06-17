//
//  YesNoCancelViewController.m
//  HaikuBrew
//
//  Created by Brian Ellison on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YesNoCancelViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface YesNoCancelViewController ()

@end

@implementation YesNoCancelViewController
@synthesize lblWouldYouLike;
@synthesize btnYes;
@synthesize btnNo;
@synthesize btnCancel;
@synthesize backgroundView;
@synthesize borderColor;
@synthesize messageToUser;
@synthesize yesNoCancelViewDelegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil borderColor:(UIColor *) _borderColor withLabelText:(NSString *) _lableText withConfirmViewDelegate:(NSObject<YesNoCancelViewDelegate> *) _yesNoCancelViewDelegate
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setYesNoCancelViewDelegate:_yesNoCancelViewDelegate];
        [self setBorderColor:_borderColor];
        [self setMessageToUser:_lableText];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backgroundView.layer.cornerRadius = 9.0;
    self.backgroundView.layer.masksToBounds = YES;
    self.backgroundView.layer.borderColor = self.borderColor.CGColor;
    self.backgroundView.layer.borderWidth = 3.0;
    
    self.lblWouldYouLike.text = self.messageToUser;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setLblWouldYouLike:nil];
    [self setBtnYes:nil];
    [self setBtnNo:nil];
    [self setBtnCancel:nil];
    [self setBackgroundView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (IBAction)pressBtnYes:(id)sender {
    [yesNoCancelViewDelegate performSelectorOnMainThread:@selector(yesNoCancelYes) withObject:nil waitUntilDone:NO];
}

- (IBAction)pressBtnNo:(id)sender {
    [yesNoCancelViewDelegate performSelectorOnMainThread:@selector(yesNoCancelNo) withObject:nil waitUntilDone:NO];
}

- (IBAction)pressBtnCancel:(id)sender {
    [yesNoCancelViewDelegate performSelectorOnMainThread:@selector(yesNoCancelCancel) withObject:nil waitUntilDone:NO];
}
@end
