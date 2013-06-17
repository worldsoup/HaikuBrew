//
//  DIsplayMessageViewController.h
//  Quick Budg
//
//  Created by Haiku Brew on 2/13/12.
//  Copyright (c) 2012 Haiku Brew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface DIsplayMessageViewController : UIViewController {
    UILabel *messageLabel;
    UIView *roundedCornersView;
}

@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UIView *roundedCornersView;

@end
