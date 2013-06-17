//
//  HBImageRequest.m
//  HaikuBrew
//
//  Created by Brian Ellison on 5/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HBImageRequest.h"

@implementation HBImageRequest
@synthesize urlString, imageView, successBlock, failureBlock;

- (NSString *) imageViewKey {
    return [NSString stringWithFormat:@"%d", [self.imageView hash]];
}

- (NSUInteger) hash {
    
    NSUInteger result = 1;
    
    result += [urlString hash];
    result += [imageView hash];
    
    return result;
    
}

@end
