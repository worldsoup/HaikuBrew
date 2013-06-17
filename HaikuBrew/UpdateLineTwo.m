//
//  UpdateLineTwo.m
//  HaikuBrew
//
//  Created by Brian Ellison on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UpdateLineTwo.h"

#import "CreateHaikuRequest.h"
#import "GetHaikuBrewsForUserId.h"
#import "Haiku.h"
#import "HaikuLine.h"
#import "DataManager.h"

@implementation UpdateLineTwo

- (Haiku *) execute:(Haiku *) haiku
{
    // addLineTwo(haikuId, text, nextLineUserId, nextLineFirstName, nextLineLastName);
    super.urlString = @"addLineTwo";
    [super addArgumentValue:[haiku haikuId]];
    [super addArgumentValue:haiku.haikuLine2.lineText];
    [super addArgumentValue:haiku.haikuLine3.userId];
    [super addArgumentValue:haiku.haikuLine3.firstName];
    [super addArgumentValue:haiku.haikuLine3.lastName];
    
 
    NSLog(@"%@", [self urlString]);
    [super execute];
    
    NSLog(@"%@", self.results);
    
    for (id key in self.results)
    {
        NSNumber *successResult = [key objectForKey:@"haikuSaveSuccess"];
        NSString *theId = [key objectForKey:@"haikuId"];
        
        NSString *errors = [key objectForKey:@"errors"];
        if([successResult boolValue])
        {
            [haiku setHaikuId:theId];
            haiku.haikuLine2.isComplete = YES;
            return haiku;
        }
        
        else
        {
            NSLog(@"ERROR Creating Haiku: %@", errors);
            return nil; 
        }
    }     
    return nil;
}
@end
