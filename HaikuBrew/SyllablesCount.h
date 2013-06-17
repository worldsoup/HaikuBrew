//
//  SyllablesCount.h
//  HaikuBrew
//
//  Created by Brian Ellison on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HaikuBrewRequest.h"
#import "Haiku.h"

@interface SyllablesCount : HaikuBrewRequest

- (NSNumber *) execute:(NSString *) sentence;
@end
