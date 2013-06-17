//
//  HideHaikuRequest.m
//  HaikuBrew
//
//  Created by Brian Ellison on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HideHaikuRequest.h"
#import "Haiku.h"
#import "AppDelegate.h"

@implementation HideHaikuRequest

- (BOOL)execute:(Haiku *)haiku
{
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    // hideFromUser/{haikuId}/{userId}
    super.urlString = @"hideFromUser";
    [super addArgumentValue:haiku.haikuId];
    [super addArgumentValue:appDelegate.myUserID];
    
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
