//
//  ConfirmViewController.h
//  HaikuBrew
//
//  Created by Brian Ellison on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConfirmViewControllerDelegate <NSObject>
@optional
- (void) confirmViewControllerDismissed; 
@end


@interface ConfirmViewController : UIViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil borderColor:(UIColor *) _borderColor withLabelText:(NSString *) _lableText withConfirmViewDelegate:(NSObject<ConfirmViewControllerDelegate> *) _confirmViewDelegate;

@property (nonatomic, retain) NSObject<ConfirmViewControllerDelegate> *confirmViewDelegate;
@property (nonatomic, retain) UIColor *borderColor;
@property (nonatomic, retain) NSString *messageToUser;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;

@property (strong, nonatomic) IBOutlet UILabel *lblConfirmText;
@property (strong, nonatomic) IBOutlet UIButton *btnOk;
- (IBAction)pressBtnOk:(id)sender;

@end
