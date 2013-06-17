//
//  DataConnector.h
//  HaikuBrew
//
//  Created by Brian Ellison on 5/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// typedefs make your code much more readable when using blocks
typedef void (^DataConnectorSuccessBlock)(NSData * returnData);
typedef void (^DataConnectorFailureBlock)(NSError  * error);
typedef void (^DataConnectorProgressBlock)(NSString * message, BOOL requestSent, BOOL responseRecieved, BOOL requestComplete, NSUInteger expectedBytes, NSUInteger bytesRecieved);

@interface DataConnector : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    dispatch_queue_t backgroundQueue;
    BOOL requestSent;
    BOOL responseRecieved;
    BOOL requestComplete; 
    NSUInteger expectedBytes;
    NSUInteger bytesRecieved;
}

@property (nonatomic, strong) NSMutableData * recievedData;
@property (nonatomic, strong) DataConnectorSuccessBlock successBlock;
@property (nonatomic, strong) DataConnectorFailureBlock failureBlock;
@property (nonatomic, strong) DataConnectorProgressBlock progressBlock;
@property (nonatomic, assign) BOOL isBusy;

- (void) getContentsOfURLFromString:(NSString *) urlString 
                   withSuccessBlock:(DataConnectorSuccessBlock) successBlock 
                   withFailureBlock:(DataConnectorFailureBlock) failureBlock;

- (void) getContentsOfURLFromString:(NSString *) urlString 
                  withProgressBlock:(DataConnectorProgressBlock) progressBlock
                   withSuccessBlock:(DataConnectorSuccessBlock) successBlock 
                   withFailureBlock:(DataConnectorFailureBlock) failureBlock;
@end
