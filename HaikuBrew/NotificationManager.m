//
//  NotificationManager.m
//  nodalTrack
//
//  Created by Haiku Brew on 7/25/11.
//  Copyright 2011 Haiku Brew. All rights reserved.
//
#import "NotificationManager.h"


@implementation NotificationManager


+ (NotificationManager *) getInstance{
    NotificationManager * nm = [[NotificationManager alloc] init];
    
    return nm;
}

// This method will allow for a title and message to be passed in and then a notification method
// will be called which will display a pop up on the screen.
- (void) displayNotificationWithTitle: (NSString *) title withMessage: (NSString *) message{
    NSArray * alertData = [NSArray arrayWithObjects:title, message, nil];
    
    [self performSelectorOnMainThread:@selector(displayAlert:) withObject:alertData waitUntilDone:NO];
}

// This method will display an alert on the screen with an alert data array containing message and title
- (void) displayAlert: (id) alertData {
    NSArray * alertDataArray = (NSArray *) alertData;
    
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle: [alertDataArray objectAtIndex:0]
                          message:  [alertDataArray objectAtIndex:1]
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    
    [alert show];
}
@end
