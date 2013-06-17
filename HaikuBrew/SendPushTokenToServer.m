//
//  SendPushTokenToServer.m
//  HaikuBrew
//
//  Created by Brian Ellison on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SendPushTokenToServer.h"

@implementation SendPushTokenToServer

- (BOOL) executeWithFacebookUser:(FacebookUser *) user
{
    // /api/registerDevice/userId/deviceId

    super.urlString = @"registerDevice";
    [super addArgumentValue:user.userId];
    [super addArgumentValue:user.pushToken];
    
    [super execute];
    
    NSLog(@"%@", self.results);
    
    for (id key in self.results)
    {
        NSNumber *successResult = [key objectForKey:@"haikuSaveSuccess"];
        return [successResult boolValue];
    }     
    return NO;
    
}


@end
