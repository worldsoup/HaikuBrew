//
//  SpinnerViewController.h
//  nodalTrack
//
//  Created by Haiku Brew on 7/25/11.
//  Copyright 2011 Haiku Brew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface SpinnerViewController : UIViewController
{
    UIActivityIndicatorView * spinner;
    UIView * parentView; 
    UIImageView *lightningImage;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView * spinner;
@property (nonatomic, retain) IBOutlet UILabel * loadingLabel;
@property (nonatomic, retain) IBOutlet UIView * roundedView; 
@property (nonatomic, retain) UIView * parentView; 
@property (nonatomic, retain) NSString *loadingText;

@property (nonatomic, assign) float height;
@property (nonatomic, assign) float width;

- (id)initWithParentView:(UIView *)parent withLabel:(NSString *) ploadingText;

- (void) showSpinner;
- (void) showSpinnerWithMessage:(NSString *) message;
- (void) dismissSpinner;


@end
