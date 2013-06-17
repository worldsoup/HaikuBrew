//
//  UpdateHaikuRequest.m
//  testQuickBrew
//
//  Created by Haiku Brew on 7/25/11.
//  Copyright 2011 Haiku Brew. All rights reserved.
//

#import "UpdateHaikuLineThree.h"
#import "CreateHaikuRequest.h"
#import "GetHaikuBrewsForUserId.h"
#import "Haiku.h"
#import "HaikuLine.h"
#import "DataManager.h"

@implementation UpdateHaikuLineThree

- (Haiku *) execute:(Haiku *) haiku
{
    // addLineThree(haikuId, text, [themeData]) //POST image data as well
    super.urlString = @"addLineThree";
    [super addArgumentValue:[haiku haikuId]];
    [super addArgumentValue:haiku.haikuLine3.lineText];
    
    
    if(haiku.backGroundImageData != nil)
    {
        [super addArgumentValue:@"null"];
        
        CGFloat compression = 0.9f;
        CGFloat maxCompression = 0.1f;
        int maxFileSize = 1024*1024;
        
        NSData *imageData = UIImageJPEGRepresentation(haiku.backGroundImageData, compression);
        
        while ([imageData length] > maxFileSize && compression > maxCompression)
        {
            compression -= 0.1;
            imageData = UIImageJPEGRepresentation(haiku.publishImageData, compression);
        }
        
        [self setFinalImageShot:imageData];
    }

    
    
    NSLog(@"%@", [self urlString]);
    BOOL success = [super execute];
    
    if(!success)
        return nil;
    
    NSLog(@"%@", self.results);
    
    for (id key in self.results)
    {
        NSNumber *successResult = [key objectForKey:@"haikuSaveSuccess"];
        NSString *theId = [key objectForKey:@"haikuId"];
        
        NSString *errors = [key objectForKey:@"errors"];
        if([successResult boolValue])
        {
            [haiku setHaikuId:theId];
            haiku.haikuLine3.isComplete = YES;
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
