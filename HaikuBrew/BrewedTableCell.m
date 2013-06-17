//
//  BrewedTableCell.m
//  HaikuBrew
//
//  Created by John Watson on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BrewedTableCell.h"

@implementation BrewedTableCell
@synthesize lblTitle;
@synthesize lblSubTitle;
@synthesize imgFacebookProfile1;
@synthesize imgFacebookProfile2;
@synthesize imgFacebookProfile3;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
