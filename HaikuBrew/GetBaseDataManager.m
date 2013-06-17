//
//  GetBaseDataManager.m
//
//  Created by Haiku Brew on 7/24/11.
//  Copyright 2011 Haiku Brew. All rights reserved.
//

#import "GetBaseDataManager.h"
#import "Haiku.h"
#import "FacebookUser.h"


@implementation GetBaseDataManager


@synthesize delegate, operationQueue, createDelegate, updateDelegate, hideHaikuDelegate, registerDeviceDelgate;

- (id)init
{
    self = [super init];
    if (self) {
        NSOperationQueue * tmpOQ = [[NSOperationQueue alloc] init];
        self.operationQueue = tmpOQ;
        [self.operationQueue setMaxConcurrentOperationCount:1];
        
        dataManager = [DataManager getDataManager];
    }
    return self;
}

- (void) getHaikuBrewsForUser: (NSString *) userId
{
    [delegate performSelectorOnMainThread:@selector(getHaikuBrewsForUserDidStart:) withObject: nil waitUntilDone:NO];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getHaikuBrews:) object:userId ] ;
    [self.operationQueue addOperation:operation];
}


- (void) getHaikuBrews:(NSString *) userId
{
    NSMutableArray * haikuBrews = [dataManager getHaikuBrewsForUserId:userId] ;
    
    if(haikuBrews == nil || [haikuBrews count] == 0){
        [delegate performSelectorOnMainThread:@selector(getHaikuBrewsDidFail:) withObject: @"No base data retrieved" waitUntilDone:NO];
    }
    else
    {
        [delegate performSelectorOnMainThread:@selector(getHaikuBrewsDidSucceed:) withObject: haikuBrews waitUntilDone:NO];

    }
}



- (void) createHaikuBrews: (Haiku *) haiku
{
    [createDelegate performSelectorOnMainThread:@selector(createHaikuBrewsDidStart:) withObject: nil waitUntilDone:NO];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(createHaikuOperation:) object:haiku ] ;
    [self.operationQueue addOperation:operation];
}


- (void) createHaikuOperation:(Haiku *) haiku
{
    Haiku * haikuReturned = [dataManager createHaiku:haiku] ;
    
    if(haikuReturned == nil){
        [createDelegate performSelectorOnMainThread:@selector(createHaikuBrewsDidFail:) withObject: @"No base data retrieved" waitUntilDone:NO];
    }
    else
    {
        [createDelegate performSelectorOnMainThread:@selector(createHaikuBrewsDidSucceed:) withObject: haiku waitUntilDone:NO];
        
    }
}


- (void) updateHaikuLineTwo: (Haiku *) haiku
{
    [updateDelegate performSelectorOnMainThread:@selector(updateHaikuBrewsDidStart:) withObject: nil waitUntilDone:NO];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(updateHaikuLineTwoOperation:) object:haiku ] ;
    [self.operationQueue addOperation:operation];
}


- (void) updateHaikuLineTwoOperation:(Haiku *) haiku
{
    Haiku * haikuReturned = [dataManager updateHaikuLine2:haiku] ;
    
    if(haikuReturned == nil){
        [updateDelegate performSelectorOnMainThread:@selector(updateHaikuBrewsDidFail:) withObject: @"No base data retrieved" waitUntilDone:NO];
    }
    else
    {
        [updateDelegate performSelectorOnMainThread:@selector(updateHaikuBrewsDidSucceed:) withObject: haiku waitUntilDone:NO];
        
    }
}


- (void) updateHaikuLineThree: (Haiku *) haiku
{
    [updateDelegate performSelectorOnMainThread:@selector(updateHaikuBrewsDidStart:) withObject: nil waitUntilDone:NO];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(updateHaikuLineThreeOperation:) object:haiku ] ;
    [self.operationQueue addOperation:operation];
}


- (void) updateHaikuLineThreeOperation:(Haiku *) haiku
{
    Haiku * haikuReturned = [dataManager updateHaikuLine3:haiku] ;
    
    if(haikuReturned == nil){
        [updateDelegate performSelectorOnMainThread:@selector(updateHaikuBrewsDidFail:) withObject: @"No base data retrieved" waitUntilDone:NO];
    }
    else
    {
        [updateDelegate performSelectorOnMainThread:@selector(updateHaikuBrewsDidSucceed:) withObject: haiku waitUntilDone:NO];
        
    }
}

- (void) countSyllables: (NSString *) _string
{
    [delegate performSelectorOnMainThread:@selector(syllablesCountDidStart:) withObject: nil waitUntilDone:NO];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(countSyllablesOperation:) object:_string ] ;
    [self.operationQueue addOperation:operation];
}


- (void) countSyllablesOperation:(NSString *) _string
{
    NSNumber * syllablesCount = [dataManager syllableCountCheck:_string] ;
    
    if(syllablesCount == nil){
        [updateDelegate performSelectorOnMainThread:@selector(syllablesCountDidFail:) withObject: @"No base data retrieved" waitUntilDone:NO];
    }
    else
    {
        [updateDelegate performSelectorOnMainThread:@selector(syllablesCountDidComplete:) withObject: syllablesCount waitUntilDone:NO];
        
    }
}


- (void) hideHaiku: (Haiku *) pHaiku
{
    [hideHaikuDelegate performSelectorOnMainThread:@selector(hideHaikuDidStart) withObject: nil waitUntilDone:NO];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(hideHaikueOperation:) object:pHaiku ] ;
    [self.operationQueue addOperation:operation];
}


- (void) hideHaikueOperation:(Haiku *) pHaiku
{
    BOOL hideHaikuResult = [dataManager hideHaiku:pHaiku] ;
    
    if(! hideHaikuResult){
        [hideHaikuDelegate performSelectorOnMainThread:@selector(hideHaikuDidFail) withObject:nil waitUntilDone:NO];
    }
    else
    {
        [hideHaikuDelegate performSelectorOnMainThread:@selector(hideHaikuDidComplete) withObject: nil waitUntilDone:NO];
    }
}

- (void) registerDevice: (FacebookUser *) user
{
    [registerDeviceDelgate performSelectorOnMainThread:@selector(registerDeviceDidStart) withObject: nil waitUntilDone:NO];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(registerDeviceOperation:) object:user ] ;
    [self.operationQueue addOperation:operation];
}


- (void) registerDeviceOperation:(FacebookUser *) user
{
    BOOL registerDeviceResult = [dataManager registerDevice:user] ;
    
    if(! registerDeviceResult){
        [registerDeviceDelgate performSelectorOnMainThread:@selector(registerDeviceDidFail) withObject:nil waitUntilDone:NO];
    }
    else
    {
        [registerDeviceDelgate performSelectorOnMainThread:@selector(registerDeviceDidComplete) withObject: nil waitUntilDone:NO];
    }
}


@end
