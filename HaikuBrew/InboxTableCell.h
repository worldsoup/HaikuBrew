//
//  InboxTableCell.h
//  HaikuBrew
//
//  Created by John Watson on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InboxTableCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *lblSentFrom;
@property (retain, nonatomic) IBOutlet UILabel *lblTitle;
@property (retain, nonatomic) IBOutlet UIImageView *ivFacebookImage;
@end
