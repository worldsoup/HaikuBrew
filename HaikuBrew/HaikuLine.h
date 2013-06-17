//
//  HaikuLine.h
//  nodalTrack
//
//  Created by Brian Ellison on 2/25/12.
//  Copyright (c) 2012 Haiku Brew All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HaikuLine : NSObject
{
    NSString *userId;
    NSString *firstName;
    NSString *lastName;
    NSString *lineText;
    NSString *status;
    BOOL isComplete;
}

@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *lineText;
@property (assign) BOOL isComplete;

@end
