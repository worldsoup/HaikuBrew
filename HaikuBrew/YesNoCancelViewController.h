//
//  YesNoCancelViewController.h
//  HaikuBrew
//
//  Created by Brian Ellison on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YesNoCancelViewDelegate <NSObject>
- (void) yesNoCancelYes; 
- (void) yesNoCancelNo; 
- (void) yesNoCancelCancel; 
@end

@interface YesNoCancelViewController : UIViewController
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblWouldYouLike;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnYes;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnNo;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnCancel;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *backgroundView;

- (IBAction)pressBtnYes:(id)sender;
- (IBAction)pressBtnNo:(id)sender;
- (IBAction)pressBtnCancel:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil borderColor:(UIColor *) _borderColor withLabelText:(NSString *) _lableText withConfirmViewDelegate:(NSObject<YesNoCancelViewDelegate> *) _yesNoCancelViewDelegate;

@property (nonatomic, retain) NSObject<YesNoCancelViewDelegate> *yesNoCancelViewDelegate;
@property (nonatomic, retain) UIColor *borderColor;
@property (nonatomic, retain) NSString *messageToUser;


@end
