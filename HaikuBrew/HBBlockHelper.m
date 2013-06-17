//
//  HBBlockHelper.m
//  HaikuBrew
//
//  Created by Brian Ellison on 5/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HBBlockHelper.h"
#import <dispatch/dispatch.h>

@implementation HBBlockHelper

+ (void) executeBlock:(HBBlockHelperGenericBlock) block afterDelay:(NSTimeInterval) seconds {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [NSThread sleepForTimeInterval:seconds];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block();            
        });
    });
    
}
@end
