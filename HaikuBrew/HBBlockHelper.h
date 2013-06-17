//
//  HBBlockHelper.h
//  HaikuBrew
//
//  Created by Brian Ellison on 5/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HBBlockHelperGenericBlock)(void);
@interface HBBlockHelper : NSObject

+ (void) executeBlock:(HBBlockHelperGenericBlock) block afterDelay:(NSTimeInterval) seconds;


@end
