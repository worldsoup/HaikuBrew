//
//  SendPushTokenToServer.h
//  HaikuBrew
//
//  Created by Brian Ellison on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HaikuBrewRequest.h"
#import "FacebookUser.h"

@interface SendPushTokenToServer : HaikuBrewRequest

- (BOOL) executeWithFacebookUser:(FacebookUser *) user;

@end
