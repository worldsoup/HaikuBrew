//
//  HaikuEntryPanel.m
//  ImageCapturePreviewTest
//
//  Created by John Watson on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HaikuEntryPanel.h"
#import "AppDelegate.h"

@interface HaikuEntryPanel ()

@end

@implementation HaikuEntryPanel

@synthesize ivBackgroundImage;
@synthesize ivProfileBackgroundImage;

@synthesize tfHaikuLine1;
@synthesize lbHaikuLine1;
@synthesize ivHaikuUser1;
@synthesize lbHaikuLine1SyllableCount;
@synthesize tfHaikuLine2;
@synthesize lbHaikuLine2;
@synthesize ivHaikuUser2;
@synthesize lbHaikuLine2SyllableCount;
@synthesize tfHaikuLine3;
@synthesize lbHaikuLine3;
@synthesize ivHaikuUser3;
@synthesize lbHaikuLine3SyllableCount;
@synthesize lblHaikuUsers;
@synthesize backgroundTap;

const int BORDER_OFFSET = 16;

@synthesize isEditMode;
@synthesize haiku;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil haiku:(Haiku *)_haiku
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.haiku = _haiku;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.ivBackgroundImage.layer.cornerRadius = 5;
    self.tfHaikuLine1.delegate = self;
    self.tfHaikuLine2.delegate = self;
    self.tfHaikuLine3.delegate = self;
    

    [self.tfHaikuLine1 addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingDidEnd];
    [self.tfHaikuLine2 addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
    [self.tfHaikuLine3 addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
    
    backgroundTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBackgroundTap)];
    backgroundTap.cancelsTouchesInView = NO;
	// Do any additional setup after loading the view. 
    if( [self.haiku isBrewed] )
    {
        [self displayAll];
    }
    else {
        NSLog(@"NextHaikuLineNumber: %i", [self.haiku getNextHaikuLineNumber]);
        [self displayForLine:[self.haiku getNextHaikuLineNumber]];
    }
}

- (void)displayAll
{
    [self displayForLine:0];
}

- (void)displayForLine:(int)lineNum
{
    int oneLineHeight = self.tfHaikuLine1.frame.origin.y + self.tfHaikuLine1.frame.size.height + BORDER_OFFSET;
    int twoLineHeight = self.tfHaikuLine2.frame.origin.y + self.tfHaikuLine1.frame.size.height + BORDER_OFFSET;
    int threeLineHeight = self.tfHaikuLine3.frame.origin.y + self.tfHaikuLine1.frame.size.height + BORDER_OFFSET;
    
    switch( lineNum )
    {
        case 1:
        {
            [self.ivHaikuUser1 setHidden:NO];
             [self.haiku getUserImageForHaikuLine:1 forImageView:self.ivHaikuUser1];
//            [self.ivHaikuUser1 setImage:[self.haiku getUserImageForHaikuLine:1]];
            [self.tfHaikuLine1 setHidden:NO];
            [self colorLineTextfield:tfHaikuLine1 withColor:[UIColor colorWithRed:86.0/255.0 green:149.0/255.0 blue:182.0/255.0 alpha:0.9]];
            [self.lbHaikuLine1SyllableCount setHidden:NO];
            
            self.ivBackgroundImage.frame = CGRectMake(self.ivBackgroundImage.frame.origin.x, 
                                                      self.ivBackgroundImage.frame.origin.x, 
                                                      self.ivBackgroundImage.frame.size.width, 
                                                      oneLineHeight);
            
            break;
        }
        case 2:
        {
            [self.ivHaikuUser1 setHidden:NO];
            [self.haiku getUserImageForHaikuLine:1 forImageView:self.ivHaikuUser1];
//            [self.ivHaikuUser1 setImage:[self.haiku getUserImageForHaikuLine:1]];
            [self.lbHaikuLine1 setHidden:NO];
            [self.lbHaikuLine1 setText:self.haiku.haikuLine1.lineText];
            
            [self colorLineBackground:self.lbHaikuLine1 withColor:[UIColor colorWithRed:86.0/255.0 green:149.0/255.0 blue:182.0/255.0 alpha:0.9]];
           

                [self.ivHaikuUser2 setHidden:NO];
                [self.haiku getUserImageForHaikuLine:2 forImageView:self.ivHaikuUser2];
//                [self.ivHaikuUser2 setImage:[self.haiku getUserImageForHaikuLine:2]];
            if(self.isEditMode)
            {
                [self.tfHaikuLine2 setHidden:NO];
                [self colorLineTextfield:tfHaikuLine2 withColor:[UIColor colorWithRed:86.0/255.0 green:149.0/255.0 blue:182.0/255.0 alpha:0.9]];
                [self.lbHaikuLine2SyllableCount setHidden:NO];
            }
                
            
            
            self.ivBackgroundImage.frame = CGRectMake(self.ivBackgroundImage.frame.origin.x, 
                                                      self.ivBackgroundImage.frame.origin.x, 
                                                      self.ivBackgroundImage.frame.size.width, 
                                                      self.isEditMode ? twoLineHeight : oneLineHeight);
            
            break;
        }
        case 3:
        {
            [self.ivHaikuUser1 setHidden:NO];
             [self.haiku getUserImageForHaikuLine:1 forImageView:self.ivHaikuUser1];
//            [self.ivHaikuUser1 setImage:[self.haiku getUserImageForHaikuLine:1]];
            [self.lbHaikuLine1 setHidden:NO];
            [self.lbHaikuLine1 setText:self.haiku.haikuLine1.lineText];
            [self colorLineBackground:self.lbHaikuLine1 withColor:[UIColor colorWithRed:86.0/255.0 green:149.0/255.0 blue:182.0/255.0 alpha:0.9]];
            
            [self.ivHaikuUser2 setHidden:NO];
             [self.haiku getUserImageForHaikuLine:2 forImageView:self.ivHaikuUser2];
//            [self.ivHaikuUser2 setImage:[self.haiku getUserImageForHaikuLine:2]];
            [self.lbHaikuLine2 setHidden:NO];
            [self.lbHaikuLine2 setText:self.haiku.haikuLine2.lineText];
            [self colorLineBackground:self.lbHaikuLine2 withColor:[UIColor colorWithRed:86.0/255.0 green:149.0/255.0 blue:182.0/255.0 alpha:0.9]];
            

                [self.ivHaikuUser3 setHidden:NO];
                 [self.haiku getUserImageForHaikuLine:3 forImageView:self.ivHaikuUser3];
//                [self.ivHaikuUser3 setImage:[self.haiku getUserImageForHaikuLine:3]];
            if(self.isEditMode)
            {
                [self.tfHaikuLine3 setHidden:NO];
                [self colorLineTextfield:tfHaikuLine3 withColor:[UIColor colorWithRed:86.0/255.0 green:149.0/255.0 blue:182.0/255.0 alpha:0.9]];
                [self.lbHaikuLine3SyllableCount setHidden:NO];
            }
               
            
            
            self.ivBackgroundImage.frame = CGRectMake(self.ivBackgroundImage.frame.origin.x, 
                                                      self.ivBackgroundImage.frame.origin.x, 
                                                      self.ivBackgroundImage.frame.size.width, 
                                                      self.isEditMode ? threeLineHeight : twoLineHeight);
            
            break;
        }
        default:
        {
            [self.ivHaikuUser1 setHidden:NO];
//            [self.ivHaikuUser1 setImage:[self.haiku getUserImageForHaikuLine:1]];
             [self.haiku getUserImageForHaikuLine:1 forImageView:self.ivHaikuUser1];
            [self.lbHaikuLine1 setHidden:NO];
            [self.lbHaikuLine1 setText:self.haiku.haikuLine1.lineText];
            [self colorLineBackground:self.lbHaikuLine1 withColor:[UIColor colorWithRed:86.0/255.0 green:149.0/255.0 blue:182.0/255.0 alpha:0.9]];
            
            [self.ivHaikuUser2 setHidden:NO];
             [self.haiku getUserImageForHaikuLine:2 forImageView:self.ivHaikuUser2];
//            [self.ivHaikuUser2 setImage:[self.haiku getUserImageForHaikuLine:2]];
            [self.lbHaikuLine2 setHidden:NO];
            [self.lbHaikuLine2 setText:self.haiku.haikuLine2.lineText];
            [self colorLineBackground:self.lbHaikuLine2 withColor:[UIColor colorWithRed:86.0/255.0 green:149.0/255.0 blue:182.0/255.0 alpha:0.9]];
            
            [self.ivHaikuUser3 setHidden:NO];
             [self.haiku getUserImageForHaikuLine:3 forImageView:self.ivHaikuUser3];
//            [self.ivHaikuUser3 setImage:[self.haiku getUserImageForHaikuLine:3]];
            [self.lbHaikuLine3 setHidden:NO];
            [self.lbHaikuLine3 setText:self.haiku.haikuLine3.lineText];
            [self colorLineBackground:self.lbHaikuLine3 withColor:[UIColor colorWithRed:86.0/255.0 green:149.0/255.0 blue:182.0/255.0 alpha:0.9]];
            
            
            if([self.haiku.haikuLine3.userId isEqualToString:self.haiku.haikuLine1.userId])
                self.lblHaikuUsers.text = [NSString stringWithFormat:@"%@ & %@", self.haiku.haikuLine1.firstName, self.haiku.haikuLine2.firstName];
            else
                self.lblHaikuUsers.text = [NSString stringWithFormat:@"%@, %@ & %@", self.haiku.haikuLine1.firstName, self.haiku.haikuLine2.firstName, self.haiku.haikuLine3.firstName];
            [self colorLineBackground:self.lblHaikuUsers withColor:[UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:0.9]];
            
            self.ivBackgroundImage.frame = CGRectMake(self.ivBackgroundImage.frame.origin.x, 
                                                      self.ivBackgroundImage.frame.origin.x, 
                                                      self.ivBackgroundImage.frame.size.width, 
                                                      threeLineHeight);
            
            break;
        }
    }
}

- (void)saveHaikuLineText
{
    NSString *lineText;
    switch( [self.haiku getNextHaikuLineNumber] )
    {
        case 1:
        {
            lineText = [[NSString alloc] initWithString:self.tfHaikuLine1.text];
            break;
        }
        case 2:
        {
            lineText = [[NSString alloc] initWithString:self.tfHaikuLine2.text];
            break;
        }
        case 3:
        {
            lineText = [[NSString alloc] initWithString:self.tfHaikuLine3.text];
            break;
        }
        default:
        {
            lineText = nil;
        }
    }
    
    [[self.haiku getNextHaikuLine] setLineText:lineText];
    
}

- (void)viewDidUnload
{
    [self setIvBackgroundImage:nil];
    [self setTfHaikuLine1:nil];
    [self setLbHaikuLine1:nil];
    [self setTfHaikuLine2:nil];
    [self setLbHaikuLine2:nil];
    [self setTfHaikuLine3:nil];
    [self setLbHaikuLine3:nil];
    [self setIvHaikuUser1:nil];
    [self setIvHaikuUser2:nil];
    [self setIvHaikuUser3:nil];
    [self setLbHaikuLine1SyllableCount:nil];
    [self setLbHaikuLine2SyllableCount:nil];
    [self setLbHaikuLine3SyllableCount:nil];
    [self setIvProfileBackgroundImage:nil];
    [self setLblHaikuUsers:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




- (void)textFieldDidBeginEditing:(UITextField *)textField 
{
    [self.parentViewController.view addGestureRecognizer:backgroundTap];
   }

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.parentViewController.view removeGestureRecognizer:backgroundTap];
    [textField resignFirstResponder];
//    [self countThoseSylables:textField];
    [self saveHaikuLineText];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.parentViewController.view removeGestureRecognizer:backgroundTap];
    [textField resignFirstResponder];
//    [self countThoseSylables:textField];
    [self saveHaikuLineText];
    
    // The following makes it so that if the user presses go... it goes!!
    [self.parentViewController performSelector:@selector(confirmImage:) withObject:nil afterDelay:0];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    [self countThoseSylables:textField];
    if(textField == self.tfHaikuLine1)
    {
//        [self.lbHaikuLine1 setHidden:NO];
//        CGRect rect = self.lbHaikuLine1.frame;
//        rect.origin.y = 75;
//        self.lbHaikuLine1.frame = rect;
//        
//        self.lbHaikuLine1.text = self.tfHaikuLine1.text;
//        CGSize labelSize = [[self.lbHaikuLine1 text] sizeWithFont:[self.lbHaikuLine1 font]];
//        int sizeLabel = labelSize.width + self.lbHaikuLine1.frame.origin.x;
//        
//        if([string isEqualToString:@""])
//            return YES;
//        
//        if((self.lbHaikuLine1.frame.origin.x + self.lbHaikuLine1.frame.size.width - 6) < sizeLabel)
//        {
//            [self.parentViewController performSelector:@selector(displayMessageViewController:) withObject:@"Line too long" afterDelay:0];
//            self.tfHaikuLine1.text = [self.tfHaikuLine1.text substringToIndex:[self.tfHaikuLine1.text length]];
//            return NO;
//        }
        
    }
    else if(textField == self.tfHaikuLine2)
    {
        
    }
    else if(textField == self.tfHaikuLine3)
    {
        
    }

    return YES;
    
    
}


- (void) textFieldValueChange:(UITextField *) textField
{
//    [self countThoseSylables:textField];
    
 }

- (void) countThoseSylables:(UITextField *) textField
{
    NSDate *duration = [[NSDate alloc] init];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    
    if(textField == self.tfHaikuLine1)
    {
//        dispatch_async(<#dispatch_queue_t queue#>, <#^(void)block#>)
        
        dispatch_async(queue, ^{
            NSNumber *syl = [[DataManager getDataManager] countSyl:textField.text] ;
            dispatch_async(dispatch_get_main_queue(),^{
                self.lbHaikuLine1SyllableCount.text = syl.stringValue;
                self.lbHaikuLine1SyllableCount.alpha = 1;
                if(syl.intValue > 6 || syl.intValue < 4)
                    [self.tfHaikuLine1 performSelectorOnMainThread:@selector(setBackgroundColor:) withObject:[UIColor redColor] waitUntilDone:NO];
                if(syl.intValue == 4 || syl.intValue == 6)
                {
                    [self.tfHaikuLine1 performSelectorOnMainThread:@selector(setBackgroundColor:) withObject:[UIColor yellowColor] waitUntilDone:NO];
                }
                if(syl.intValue == 5)
                {
                    [self.tfHaikuLine1 performSelectorOnMainThread:@selector(setBackgroundColor:) withObject:[UIColor greenColor] waitUntilDone:NO];                      
                }

            });
                           
        });
    }
    if(textField == self.tfHaikuLine2)
    {
        dispatch_async(queue, ^{
                           NSNumber *syl = [[DataManager getDataManager] countSyl:textField.text] ;
                           self.lbHaikuLine2SyllableCount.text = syl.stringValue;
                           self.lbHaikuLine2SyllableCount.alpha = 1;
                           if(syl.intValue > 8 || syl.intValue < 6)
                               [self.tfHaikuLine2 performSelectorOnMainThread:@selector(setBackgroundColor:) withObject:[UIColor redColor] waitUntilDone:NO];
                           if(syl.intValue == 6 || syl.intValue == 8)
                           {
                               [self.tfHaikuLine2 performSelectorOnMainThread:@selector(setBackgroundColor:) withObject:[UIColor yellowColor] waitUntilDone:NO];
                           }
                           if(syl.intValue == 7)
                           {
                               [self.tfHaikuLine2 performSelectorOnMainThread:@selector(setBackgroundColor:) withObject:[UIColor greenColor] waitUntilDone:NO];                      
                           }
                           
                       });
    }
    if(textField == self.tfHaikuLine3)
    {
        dispatch_async(queue,^{
                           NSNumber *syl = [[DataManager getDataManager] countSyl:textField.text] ;
                           self.lbHaikuLine3SyllableCount.text = syl.stringValue;
                           self.lbHaikuLine3SyllableCount.alpha = 1;
                           if(syl.intValue > 6 || syl.intValue < 4)
                               [self.tfHaikuLine3 performSelectorOnMainThread:@selector(setBackgroundColor:) withObject:[UIColor redColor] waitUntilDone:NO];
                           if(syl.intValue == 4 || syl.intValue == 6)
                           {
                               [self.tfHaikuLine3 performSelectorOnMainThread:@selector(setBackgroundColor:) withObject:[UIColor yellowColor] waitUntilDone:NO];
                           }
                           if(syl.intValue == 5)
                           {
                               [self.tfHaikuLine3 performSelectorOnMainThread:@selector(setBackgroundColor:) withObject:[UIColor greenColor] waitUntilDone:NO];                      
                           }
                           
                       });    
    }

    NSTimeInterval interval = [[[NSDate alloc] init] timeIntervalSinceDate: duration];
    NSLog(@"Date time : %f", interval);

}

-(void) onBackgroundTap
{
    [self.parentViewController.view removeGestureRecognizer:backgroundTap];
    [self.tfHaikuLine1 resignFirstResponder];
    [self.tfHaikuLine2 resignFirstResponder];
    [self.tfHaikuLine3 resignFirstResponder];
    [self saveHaikuLineText];
}

- (void) colorLineBackground:(UILabel *) haikuLine withColor:(UIColor *) pColor
{
    CGSize labelSize = [[haikuLine text] sizeWithFont:[haikuLine font]];
    UIView *line1BackView = [[UIView alloc] initWithFrame:CGRectMake(haikuLine.frame.origin.x - 8, haikuLine.frame.origin.y - 6, labelSize.width + 12, labelSize.height + 5)];
    [line1BackView setBackgroundColor:pColor];
    line1BackView.layer.cornerRadius = 3.0;
    line1BackView.layer.masksToBounds = YES;
    [line1BackView setAlpha:.7];
    [self.view addSubview:line1BackView];
    [self.view bringSubviewToFront:haikuLine];
    [self.view bringSubviewToFront:self.ivProfileBackgroundImage];
    [self.view bringSubviewToFront:self.ivHaikuUser1];
    [self.view bringSubviewToFront:self.ivHaikuUser2];
    [self.view bringSubviewToFront:self.ivHaikuUser3];
}

- (void) colorLineTextfield:(UITextField *) haikuTextField withColor:(UIColor *) pColor
{
    UIView *line1BackView = [[UIView alloc] initWithFrame:haikuTextField.frame];
    [line1BackView setBackgroundColor:pColor];
    line1BackView.layer.cornerRadius = 6.0;
    line1BackView.layer.masksToBounds = YES;
    [line1BackView setAlpha:.7];
    [self.view addSubview:line1BackView];
    [self.view bringSubviewToFront:haikuTextField];
    [self.view bringSubviewToFront:self.ivProfileBackgroundImage];
    [self.view bringSubviewToFront:self.ivHaikuUser1];
    [self.view bringSubviewToFront:self.ivHaikuUser2];
    [self.view bringSubviewToFront:self.ivHaikuUser3];
}




@end
