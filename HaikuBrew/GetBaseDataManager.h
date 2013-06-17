//
//  GetBaseDataManager.h
//
//  Created by Haiku Brew on 7/24/11.
//  Copyright 2011 Haiku Brew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"
//
// delegate protocol
//
@protocol GetHaikuBrewsDelegate <NSObject>
@optional
- (void) getHaikuBrewsForUserDidStart:(NSString *) userId; // called when a background login has been kicked off
- (void) getHaikuBrewsDidSucceed:(NSMutableArray *) haikuBrews; // called when a successful login has occured
- (void) getHaikuBrewsDidFail: (NSString *) reason; // called when a failed login has occured
@end


@protocol CreateHaikuBrewsDelegate <NSObject>
@optional
- (void) createHaikuBrewsDidStart:(NSString *) userId; // called when a background login has been kicked off
- (void) createHaikuBrewsDidSucceed:(Haiku *) haiku; // called when a successful login has occured
- (void) createHaikuBrewsDidFail: (NSString *) reason; // called when a failed login has occured
@end


@protocol UpdateHaikuLineBrewsDelegate <NSObject>
@optional
- (void) updateHaikuBrewsDidStart:(NSString *) userId; // called when a background login has been kicked off
- (void) updateHaikuBrewsDidSucceed:(Haiku *) haiku; // called when a successful login has occured
- (void) updateHaikuBrewsDidFail: (NSString *) reason; // called when a failed login has occured
@end


@protocol SyllablesCountDelegate <NSObject>
@optional
- (void) syllablesCountDidStart:(NSString *) userId; // called when a background login has been kicked off
- (void) syllablesCountDidComplete:(NSNumber *) theCount; // called when a successful login has occured
- (void) syllablesCountDidFail: (NSString *) reason; // called when a failed login has occured
@end

@protocol HideHaikuDelegate <NSObject>
@optional
- (void) hideHaikuDidStart; // called when a background login has been kicked off
- (void) hideHaikuDidComplete; // called when a successful hide Haiku has occured
- (void) hideHaikuDidFail; // called when a failed hide Haiku has occured
@end

@protocol RegisterDeviceDelegate <NSObject>
@optional
- (void) registerDeviceDidStart; // called when a background login has been kicked off
- (void) registerDeviceDidComplete; // called when a successful hide Haiku has occured
- (void) registerDeviceDidFail; // called when a failed hide Haiku has occured
@end


@interface GetBaseDataManager : NSObject{
    NSObject<GetHaikuBrewsDelegate> *delegate;
    NSObject<CreateHaikuBrewsDelegate> *createDelegate;
    NSObject<UpdateHaikuLineBrewsDelegate> *updateDelegate;
    NSOperationQueue * _operationQueue;
    DataManager * dataManager;
}

@property (nonatomic, retain) NSObject<GetHaikuBrewsDelegate> *delegate;
@property (nonatomic, retain) NSObject<CreateHaikuBrewsDelegate> *createDelegate;
@property (nonatomic, retain) NSObject<UpdateHaikuLineBrewsDelegate> *updateDelegate;
@property (nonatomic, retain) NSObject<HideHaikuDelegate> *hideHaikuDelegate;
@property (nonatomic, retain) NSObject<RegisterDeviceDelegate> *registerDeviceDelgate;
@property (nonatomic, retain) NSOperationQueue *operationQueue;


- (void) getHaikuBrewsForUser: (NSString *) userId;
- (void) createHaikuBrews: (Haiku *) userId;
- (void) updateHaikuLineTwo: (Haiku *) haiku;
- (void) updateHaikuLineThree: (Haiku *) haiku;
- (void) hideHaiku: (Haiku *) pHaiku;


@end
