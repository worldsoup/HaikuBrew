//
//  CreateHaikuRequest.m
//  testQuickBrew
//
//  Created by Haiku Brew on 2/25/12.
//  Copyright (c) 2012 Haiku Brew. All rights reserved.
//

#import "CreateHaikuRequest.h"
#import "GetHaikuBrewsForUserId.h"
#import "Haiku.h"
#import "HaikuLine.h"
#import "DataManager.h"
#import "JSON.h"
#import "SBJsonParser.h"
#import "SBJsonWriter.h"

@implementation CreateHaikuRequest

- (Haiku *) execute:(Haiku *) haiku
{
    super.urlString = @"create";
    [super addArgumentValue:haiku.haikuLine1.userId];
    [super addArgumentValue:haiku.haikuLine1.firstName];
    [super addArgumentValue:haiku.haikuLine1.lastName];
    [super addArgumentValue:haiku.haikuLine1.lineText];
    [super addArgumentValue:haiku.haikuLine1.lineText];
    
    //    user id, first name , last name, title, text, background image,line 2 id, line2first, line2 lastname
    
    
    // Add backgroung image to post
    
    //uploadedBackgroundImage

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
            imageData = UIImageJPEGRepresentation(haiku.backGroundImageData, compression);
        }
        
        [self setImagePic:UIImageJPEGRepresentation(haiku.backGroundImageData,0.5f)];
    }
    else {
        [super addArgumentValue:@"null"];
    }

    [super addArgumentValue:haiku.haikuLine2.userId];
    [super addArgumentValue:haiku.haikuLine2.firstName];
    [super addArgumentValue:haiku.haikuLine2.lastName];    
    
    NSDictionary *themeData = [[NSDictionary alloc] initWithObjectsAndKeys:haiku.yPosition, @"yPosition", nil];
    [super addArgumentValue:[themeData JSONRepresentation]];
    
    
    NSLog(@"CREATE REQUEST STRING: %@", [self urlString]);
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
            NSString *haikuImageLocation = [key objectForKey:@"uploadedBackgroundImage"];
            [haiku setBackGroundImage:haikuImageLocation];
            [haiku setHaikuId:theId];
            haiku.haikuLine1.isComplete = YES;
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
