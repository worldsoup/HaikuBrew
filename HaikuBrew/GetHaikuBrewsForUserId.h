//
//  GetDashboardData.h
//
//  Created by Haiku Brew on 7/25/11.
//  Copyright 2011 Haiku Brew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HaikuBrewRequest.h"
#import "HaikuLine.h"
#import "Haiku.h"
@interface GetHaikuBrewsForUserId : HaikuBrewRequest
{
    NSString *stringDate;
}

@property (nonatomic, retain) NSString *stringDate;

- (NSMutableArray *) execute:(NSString *) userId;

- (HaikuLine  *) createHaikuLineFromDictionary:(NSDictionary *) dictionary;
- (Haiku  *) createHaiku:(NSDictionary *) HaikuDict;
@end
