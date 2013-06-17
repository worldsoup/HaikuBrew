//
//  DataManager.h
//
//  Created by Haiku Brew on 7/23/11.
//  Copyright 2011 Haiku Brew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Haiku.h"
#import "HaikuLine.h"
#import "FacebookUser.h"

@interface DataManager : NSObject
{
    NSError * lastCommunicationError;
}


@property (retain) NSError * lastCommunicationError;

- (NSMutableArray *) getHaikuBrewsForUserId:(NSString *) _userId;
- (Haiku *) createHaiku:(Haiku *) haiku;
- (Haiku *) updateHaikuLine2:(Haiku *) haiku;
- (Haiku *) updateHaikuLine3:(Haiku *) haiku;
- (NSNumber *) syllableCountCheck:(NSString *) _string;
- (BOOL) hideHaiku:(Haiku *) pHaiku;
- (NSNumber *) countSyl:(NSString *) phrase;
- (BOOL) registerDevice:(FacebookUser *) user;

+ (id) getDataManager;

@end
