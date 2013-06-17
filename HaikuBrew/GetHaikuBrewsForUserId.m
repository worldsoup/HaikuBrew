//
//  GetDashboardData.m
//
//  Created by Haiku Brew on 7/25/11.
//  Copyright 2011 Haiku Brew. All rights reserved.
//

#import "GetHaikuBrewsForUserId.h"
#import "Haiku.h"
#import "HaikuLine.h"
#import "DataManager.h"
@implementation GetHaikuBrewsForUserId
@synthesize stringDate;

- (NSMutableArray *)  execute:(NSString *) userId
{
    super.urlString = @"getAllFromUser";
    [super addArgumentValue:userId];
    BOOL success = [super execute];
    
    if(!success)
        return nil;
    
    NSMutableArray *haikuObjects = [[NSMutableArray alloc] init ];
    
    for(int i = 0; i < [self.results count] ; i ++)
    {   

        NSDictionary *flatHaiku = [self.results objectAtIndex:i];


        NSDictionary *brewingHaikus = [flatHaiku objectForKey:@"Brewing"];
        NSDictionary *brewedHaikus = [flatHaiku objectForKey:@"Brewed"];

        
        
        for (id key in brewingHaikus) {
            NSDictionary *HaikuDict = [key objectForKey:@"Haiku"];
            [haikuObjects addObject:[self createHaiku:HaikuDict]];
        }
        
        
        for (id key in brewedHaikus) {
            NSDictionary *HaikuDict = [key objectForKey:@"Haiku"];
            [haikuObjects addObject:[self createHaiku:HaikuDict]];
        }
    }
    
    return haikuObjects;
}


- (Haiku  *) createHaiku:(NSDictionary *) HaikuDict
{
    Haiku *haiku = [[Haiku alloc] init];
    
    [haiku setHaikuId:[self getValueForDictionary:HaikuDict withKey:@"id"]];
    //            [haiku setBackGroundImage:[self getValueForDictionary:HaikuDict withKey:@"publishURL"]];
    [haiku setTitle:[self getValueForDictionary:HaikuDict withKey:@"title"]];
    [haiku setBackGroundImage:[self getValueForDictionary:HaikuDict withKey:@"backgroundURL"]];
    
    //"2012-05-20 13:53:50"
    NSString *dateString = [self getValueForDictionary:HaikuDict withKey:@"updated"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [haiku setModifiedDate:[dateFormat dateFromString:dateString]];
    
    NSDictionary *themeData = [HaikuDict objectForKey:@"themeData"];
    if(themeData != nil && themeData.count > 0 && ![themeData isEqual:[NSNull null]])
    {
        if([themeData objectForKey:@"yPosition"])
        {
            NSNumber *yPosition = [themeData objectForKey:@"yPosition"];
            [haiku setYPosition:yPosition];
        }
    }
    
    
    NSDictionary *lineOneDictionary = [HaikuDict objectForKey:@"lineOne"];
    if(lineOneDictionary != nil)
        [haiku setHaikuLine1:[self createHaikuLineFromDictionary:lineOneDictionary]];           
    
    NSDictionary *lineTwoDictionary = [HaikuDict objectForKey:@"lineTwo"];
    if(lineTwoDictionary != nil)
        [haiku setHaikuLine2:[self createHaikuLineFromDictionary:lineTwoDictionary]];
    
    NSDictionary *lineThreeDictionary = [HaikuDict objectForKey:@"lineThree"];
    if(lineThreeDictionary != nil)
        [haiku setHaikuLine3:[self createHaikuLineFromDictionary:lineThreeDictionary]];
    return haiku;
}



- (HaikuLine  *) createHaikuLineFromDictionary:(NSDictionary *) dictionary
{
    HaikuLine *line = [[HaikuLine alloc] init];
    [line setUserId:[self getValueForDictionary:dictionary withKey:@"userId"]];
    [line setFirstName:[self getValueForDictionary:dictionary withKey:@"firstName"]];
    [line setLastName:[self getValueForDictionary:dictionary withKey:@"lastName"]];
    [line setLineText:[self getValueForDictionary:dictionary withKey:@"text"]];
    NSString * status = [self getValueForDictionary:dictionary withKey:@"status"];
    if([status isEqualToString:@"Brewed"])
    {
        line.isComplete = YES;
    }
    else {
        line.isComplete = NO;
    }
    return line;
}


@end
