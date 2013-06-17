//
//  BrewTableViewCell.m
//  HaikuBrew
//
//  Created by Brian Ellison on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BrewTableViewCell.h"

@implementation BrewTableViewCell
@synthesize lblWho;
@synthesize ivHaikuImage;
@synthesize ivBackgroundImage;
@synthesize btnTrash;
@synthesize btnPost;
@synthesize haiku;
@synthesize tableViewController;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)pressBtnTrash:(id)sender {
    NSLog(@"Press Trash");
    [self.tableViewController deleteHaiku:self.haiku];
    
}

- (IBAction)pressBtnPost:(id)sender {
    [self.tableViewController postToFacebook:self.haiku];
    NSLog(@"Press Post");
}
@end
