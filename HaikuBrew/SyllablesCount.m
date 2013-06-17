//
//  SyllablesCount.m
//  HaikuBrew
//
//  Created by Brian Ellison on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SyllablesCount.h"

@implementation SyllablesCount

- (NSNumber *)execute:(NSString *)sentence
{
    // addLineTwo(haikuId, text, nextLineUserId, nextLineFirstName, nextLineLastName);
    super.urlString = @"countSyllables";
    [super addArgumentValue:sentence];
    
    [super execute];
    
    NSLog(@"%@", self.results);
    
    for (id key in self.results)
    {
        NSNumber *flatReturnDetails = [key objectForKey:@"numberOfSyllables"] ;
        return flatReturnDetails;
        
    }     
    return nil;

}

@end
