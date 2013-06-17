//
//  Haiku.h
//
//  Created by Haiku Brew on 7/25/11.
//  Copyright 2011 Haiku Brew. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HaikuLine.h"

@interface Haiku : NSObject


@property (nonatomic, retain) NSString *haikuId;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *backGroundImage;
@property (nonatomic, retain) NSNumber *yPosition;
@property (nonatomic, retain) UIImage  *backGroundImageData;
@property (nonatomic, retain) UIImage  *publishImageData;
@property (nonatomic, retain) NSDate *modifiedDate;

@property (nonatomic, retain) HaikuLine *haikuLine1;
@property (nonatomic, retain) HaikuLine *haikuLine2;
@property (nonatomic, retain) HaikuLine *haikuLine3;

- (id) initWithHaikuId:(NSString *) _haikuId WithTitle:(NSString *) _title WithBackGroundImage:(NSNumber *) _backGroundImage;

- (Boolean) isBrewing;
- (Boolean) isBrewed;

- (NSString *) getNextUserId;
- (NSString *) getNextUserFirstName;

- (NSString *) getListOfUsers;
- (Boolean) needsAttentionForUser:(NSString *)userID;

- (HaikuLine *) getNextHaikuLine;
- (int) getNextHaikuLineNumber;

- (HaikuLine *) getHaikuLine:(int)number;
- (NSString *) getUserIdForLine:(int)number;
- (UIImage *) getUserImageForHaikuLine:(int)number;
- (void) getUserImageForHaikuLine:(int)number forImageView:(UIImageView *) imageView;
- (NSString *) getTableViewHaikuTextUnderImage;
@end
