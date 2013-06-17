//
//  HaikuEntryPanel.h
//  ImageCapturePreviewTest
//
//  Created by John Watson on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Haiku.h"
#import "HaikuLine.h"

@interface HaikuEntryPanel : UIViewController <UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UIImageView *ivBackgroundImage;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *ivProfileBackgroundImage;

@property (retain, nonatomic) IBOutlet UITextField *tfHaikuLine1;
@property (retain, nonatomic) IBOutlet UILabel *lbHaikuLine1;
@property (retain, nonatomic) IBOutlet UIImageView *ivHaikuUser1;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lbHaikuLine1SyllableCount;


@property (retain, nonatomic) IBOutlet UITextField *tfHaikuLine2;
@property (retain, nonatomic) IBOutlet UILabel *lbHaikuLine2;
@property (retain, nonatomic) IBOutlet UIImageView *ivHaikuUser2;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lbHaikuLine2SyllableCount;


@property (retain, nonatomic) IBOutlet UITextField *tfHaikuLine3;
@property (retain, nonatomic) IBOutlet UILabel *lbHaikuLine3;
@property (retain, nonatomic) IBOutlet UIImageView *ivHaikuUser3;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lbHaikuLine3SyllableCount;


@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblHaikuUsers;

@property BOOL isEditMode;
@property (retain, nonatomic) Haiku *haiku;
@property (retain, nonatomic) UITapGestureRecognizer *backgroundTap;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil haiku:(Haiku *)haiku;
-(void) onBackgroundTap;

- (void) colorLineBackground:(UILabel *) haikuLine withColor:(UIColor *) pColor;
- (void) colorLineTextfield:(UITextField *) haikuTextField withColor:(UIColor *) pColor;
@end
