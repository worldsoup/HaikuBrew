//
//  Haiku.m
//
//  Created by Haiku Brew on 7/25/11.
//  Copyright 2011 Haiku Brew. All rights reserved.
//

#import "Haiku.h"
#import "AppDelegate.h"

@implementation Haiku
@synthesize haikuId, title, backGroundImage, backGroundImageData, publishImageData, yPosition;

@synthesize haikuLine1 = _haikuLine1;
@synthesize haikuLine2 = _haikuLine2;
@synthesize haikuLine3 = _haikuLine3;
@synthesize modifiedDate;

- (id) initWithHaikuId:(NSString *) _haikuId WithTitle:(NSString *) _title WithBackGroundImage:(NSString *) _backGroundImage
{
    self = [super init];
    if (self) {
        // Initialization code here.
        [self setHaikuId:_haikuId];
        [self setTitle:_title];
        [self setBackGroundImage:_backGroundImage];
    }
    
    return self; 
}

- (id)init 
{
    self = [super init];
    if (self) {
        self.haikuId = nil;
        self.title = nil;
        self.backGroundImage = nil;
        
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        self.haikuLine1 = [[HaikuLine alloc] init];
        self.haikuLine1.userId = appDelegate.myUserID;
        self.haikuLine1.firstName = appDelegate.firstName;
        self.haikuLine1.lastName = appDelegate.lastName;
        self.haikuLine1.isComplete = NO;
    }
    return self;
}

- (Boolean) needsAttentionForUser:(NSString *)userID
{
    return [ [userID uppercaseString] isEqualToString:[[self getNextUserId] uppercaseString]] ;
}

- (Boolean) isBrewing
{
    return [self getNextHaikuLineNumber] != 0;
}

- (Boolean) isBrewed
{
    return ![self isBrewing];
}

- (NSString *) getNextUserId
{
    return [[self getNextHaikuLine] userId];
}

- (NSString *) getUserIdForLine:(int)number
{
    return [[self getHaikuLine:number] userId];
}

- (NSString *) getNextUserFirstName
{
    return [[self getNextHaikuLine] firstName];
}

- (HaikuLine *) getNextHaikuLine
{
    if( [self getNextHaikuLineNumber] == 1 )
        return self.haikuLine1;
    else if( [self getNextHaikuLineNumber] == 2 )
        return self.haikuLine2;
    else if( [self getNextHaikuLineNumber] == 3 )
        return self.haikuLine3;
    else 
        return nil;
}

- (int) getNextHaikuLineNumber
{
    if( !self.haikuLine1.isComplete )
        return 1;
    else if( !self.haikuLine2.isComplete )
        return 2;
    else if( !self.haikuLine3.isComplete )
        return 3;
    else
        return 0;
}

- (UIImage *) getUserImageForHaikuLine:(int)number
{
    NSLog(@"userID: %@", [self getUserIdForLine:number]);
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", [self getUserIdForLine:number]]];

    return [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
}

- (void) getUserImageForHaikuLine:(int)number forImageView:(UIImageView *) imageView
{
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", [self getUserIdForLine:number]]];
    [imageView setImageWithURL:url];
}



- (HaikuLine *) getHaikuLine:(int)number
{
    switch (number) {
        case 1:
            return self.haikuLine1;
        case 2:
            return self.haikuLine2;
        case 3:
            return self.haikuLine3;
        default:
            return nil;
    }
}

- (NSString *) getTableViewHaikuTextUnderImage
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if([self isBrewed])
        return [self getListOfUsers];
    else {
        if([[self getNextUserId] isEqualToString:appDelegate.myUserID])
        {
            return [self getListOfUsers]; 
        }
        else {
            return [NSString stringWithFormat:@"Waiting on %@", [self getNextUserFirstName]];
        }
    }
    
}


- (NSString *) getListOfUsers
{
    NSMutableDictionary *listOfUsers = [[NSMutableDictionary alloc] initWithObjectsAndKeys: nil];
    NSMutableArray *arrayOfUsers = [[NSMutableArray alloc] initWithObjects: nil];
    if(self.haikuLine1 != nil)
    {
        [listOfUsers setObject:self.haikuLine1.firstName forKey:self.haikuLine1.userId];
        [arrayOfUsers addObject:self.haikuLine1.firstName];
    }
    if(self.haikuLine2 != nil)
    {
        if([listOfUsers objectForKey:self.haikuLine2.userId] == nil)
        {
            [listOfUsers setObject:self.haikuLine2.firstName forKey:self.haikuLine2.userId];
            [arrayOfUsers addObject:self.haikuLine2.firstName];
        }
    }
    if(self.haikuLine3 != nil && self.haikuLine3.userId != nil && self.haikuLine3.firstName != nil)
    {
       
        if([listOfUsers objectForKey:self.haikuLine3.userId] == nil)
        {
            [listOfUsers setObject:self.haikuLine3.firstName forKey:self.haikuLine3.userId];
            [arrayOfUsers addObject:self.haikuLine3.firstName];
        }
    }

    
    if(arrayOfUsers.count == 1)
        return [arrayOfUsers objectAtIndex:0];
    else if (arrayOfUsers.count == 2)
        return [NSString stringWithFormat:@"%@ & %@", [arrayOfUsers objectAtIndex:0], [arrayOfUsers objectAtIndex:1] ]; 
    else if (arrayOfUsers.count == 3)
        return [NSString stringWithFormat:@"%@, %@, & %@", [arrayOfUsers objectAtIndex:0], [arrayOfUsers objectAtIndex:1], [arrayOfUsers objectAtIndex:2] ]; 

return @"";
    
    
}

@end
