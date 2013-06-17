//
//  NotificationManager.h
//  nodalTrack
//
//  Created by Haiku Brew on 7/25/11.
//  Copyright 2011 Haiku Brew. All rights reserved.

#import <Foundation/Foundation.h>


@interface NotificationManager : NSObject {
    
}


+ (NotificationManager *) getInstance;

- (void) displayNotificationWithTitle: (NSString *) title withMessage: (NSString *) message;
@end
