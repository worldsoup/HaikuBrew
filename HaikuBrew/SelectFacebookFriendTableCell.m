//
//  SelectFacebookFriendTableCell.m
//  HaikuBrew
//
//  Created by Brian Ellison on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectFacebookFriendTableCell.h"

@implementation SelectFacebookFriendTableCell
@synthesize imgFacebookProfileImage;
@synthesize lblUserName;
@synthesize imgCheck;


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
