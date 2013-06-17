//
//  FacebookHelper.h
//  HaikuBrew
//
//  Created by Brian Ellison on 5/4/13.
//
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookHelper : NSObject


+ (FBSession *) sharedSession ;

@end
