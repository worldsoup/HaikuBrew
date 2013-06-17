//
//  CreateHaikuRequest.h
//  testQuickBrew
//
//  Created by Haiku Brew on 2/25/12.
//  Copyright (c) 2012 Haiku Brew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HaikuBrewRequest.h"
#import "Haiku.h"

@interface CreateHaikuRequest :HaikuBrewRequest


- (Haiku *) execute:(Haiku *) haiku;

@end
