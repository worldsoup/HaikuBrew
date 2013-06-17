//
//  BrewTableViewCell.h
//  HaikuBrew
//
//  Created by Brian Ellison on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Haiku.h"
#import "NewHomeTableViewController.h"

@interface BrewTableViewCell : UITableViewCell


//Buttons
@property (retain, nonatomic) IBOutlet UIButton *btnTrash;
@property (retain, nonatomic) IBOutlet UIButton *btnPost;

//Button Actions
- (IBAction)pressBtnTrash:(id)sender;
- (IBAction)pressBtnPost:(id)sender;



//Image Views
@property (retain, nonatomic) IBOutlet UIImageView *ivHaikuImage;
@property (retain, nonatomic) IBOutlet UIImageView *ivBackgroundImage;

//Labels
@property (retain, nonatomic) IBOutlet UILabel *lblWho;



@property (retain, nonatomic) NewHomeTableViewController *tableViewController;
@property (retain, nonatomic) Haiku *haiku;


@end
