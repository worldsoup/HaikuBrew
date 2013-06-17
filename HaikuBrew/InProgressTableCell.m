//
//  InProgressTableCell.m
//  HaikuBrew
//
//  Created by John Watson on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InProgressTableCell.h"

@implementation InProgressTableCell
@synthesize lblTitle;
@synthesize lblSubTitle;
@synthesize imgFacebookProfile;

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
