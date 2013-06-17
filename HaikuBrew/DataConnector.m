//
//  DataConnector.m
//  HaikuBrew
//
//  Created by Brian Ellison on 5/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataConnector.h"

@implementation DataConnector
@synthesize recievedData, successBlock, failureBlock, progressBlock, isBusy;
- (id) init
{
    if (self = [super init]) {
        requestSent = NO;
        responseRecieved = NO;
        requestComplete = NO;
        expectedBytes = 0;
        bytesRecieved = 0;
    }
    return self;
}

- (void) getContentsOfURLFromString:(NSString *) urlString 
                   withSuccessBlock:(DataConnectorSuccessBlock) _successBlock 
                   withFailureBlock:(DataConnectorFailureBlock) _failureBlock {
    
    
    
    DataConnectorProgressBlock _progressBlock = ^(NSString * message, BOOL _requestSent, BOOL _responseRecieved, BOOL _requestComplete, NSUInteger _expectedBytes, NSUInteger _bytesRecieved) {
        //  NSLog(@"message = [%@], requstSent = [%d], responseRecieved = [%d], requestComplete = [%d], expectedBytes = [%d], bytesRecieved = [%d]",  message, _requestSent, _responseRecieved, _requestComplete, _expectedBytes, _bytesRecieved);
    };
    
    
    [self getContentsOfURLFromString:urlString 
                   withProgressBlock:_progressBlock
                    withSuccessBlock:_successBlock 
                    withFailureBlock:_failureBlock];
}

- (void) getContentsOfURLFromString:(NSString *) urlString 
                  withProgressBlock:(DataConnectorProgressBlock)_progressBlock  
                   withSuccessBlock:(DataConnectorSuccessBlock) _successBlock 
                   withFailureBlock:(DataConnectorFailureBlock) _failureBlock
{
    
    if (self.isBusy) {
        NSLog(@"DataConnector busy, go away!");
//        _failureBlock([NMErrorHelper errorWithCode:711 withMessage:@"data connector is busy" withInfo:nil]);
        return;
    }
    
    self.isBusy = YES;
    self.failureBlock = _failureBlock;
    self.successBlock = _successBlock;
    self.progressBlock = _progressBlock;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    requestSent = NO;
    responseRecieved = NO;
    requestComplete = NO;
    expectedBytes = 0;
    bytesRecieved = 0;
    
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    requestSent = YES;
    if (theConnection) {
        // init the container to hold the data returned
        self.recievedData = [NSMutableData data];
        
        if (self.progressBlock) {
            progressBlock(@"Request Sent", requestSent, responseRecieved, requestComplete, expectedBytes, bytesRecieved);
        }
    }
    else {
//        failureBlock([NMErrorHelper errorWithCode:777 withMessage:[NSString stringWithFormat:@"Error connection for url [%@]", urlString] withInfo:nil]);
    }    
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.recievedData = nil;
    self.successBlock = nil;
    self.progressBlock = nil;
    
    self.failureBlock(error);
    self.failureBlock = nil;
    self.isBusy = NO;
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    responseRecieved = YES;
    expectedBytes = [response expectedContentLength];
    
    if (self.progressBlock) {
        progressBlock(@"Response Recieved", requestSent, responseRecieved, requestComplete, expectedBytes, bytesRecieved);
    }
    
    [recievedData setLength:0];
    
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [recievedData appendData:data];
    bytesRecieved = [self.recievedData length];
    if (self.progressBlock) {
        progressBlock(@"Recieving Data", requestSent, responseRecieved, requestComplete, expectedBytes, bytesRecieved);
    }
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection 
{
    requestComplete = YES;
    bytesRecieved = [self.recievedData length];
    if (self.progressBlock) 
    {
        progressBlock(@"Complete", requestSent, responseRecieved, requestComplete, expectedBytes, bytesRecieved); 
    }
    
    // NSString * dataString = [[NSString alloc] initWithData:recievedData encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", dataString);
    self.successBlock([NSData dataWithData:recievedData]);
    
    self.recievedData = nil;
    self.successBlock = nil;
    self.progressBlock = nil;
    self.failureBlock = nil;
    self.isBusy = NO;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}

- (void) connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSLog(@"authentication challenge");
}

@end