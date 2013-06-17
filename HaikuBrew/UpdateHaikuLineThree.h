//
//  UpdateHaikuRequest.h
//  testQuickBrew
//
//  Created by Haiku Brew on 7/25/11.
//  Copyright 2011 Haiku Brew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HaikuBrewRequest.h"
#import "Haiku.h"

@interface UpdateHaikuLineThree : HaikuBrewRequest


- (Haiku *) execute:(Haiku *) haiku;

@end
