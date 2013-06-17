//
//  FacebookUser.h
//  HaikuBrew
//
//  Created by Brian Ellison on 3/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FacebookUser : NSObject

@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *first_name;
@property (nonatomic, retain) NSString *last_name;
@property (nonatomic, retain) NSString *pushToken;
@property BOOL isUsingApp;

@end
