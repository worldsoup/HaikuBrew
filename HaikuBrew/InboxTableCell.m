//
//  InboxTableCell.m
//  HaikuBrew
//
//  Created by John Watson on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InboxTableCell.h"

@interface InboxTableCell ()

@end

@implementation InboxTableCell
@synthesize lblSentFrom;
@synthesize lblTitle;
@synthesize ivFacebookImage;

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
