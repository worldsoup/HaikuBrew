//
//  HBImageHelper.m
//  HaikuBrew
//
//  Created by Brian Ellison on 5/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HBImageHelper.h"
#import <dispatch/dispatch.h>
#import "HBBlockHelper.h"
#import "DataConnector.h"

#define kURLRequestSuccessNotification @"HBImageURLRequestSucceeded"
#define kURLRequestFailureNotification @"HBImageURLRequestFail"


@interface HBImageHelper()
- (void) executeImageRequest:(HBImageRequest *) request;
- (void) urlRequestSucceded:(NSNotification *) notification;
- (void) urlRequestFailed:(NSNotification *) notification;
@end

@implementation HBImageHelper

@synthesize cacheDict, urlRequests, imageViewRequestStash;


+ (HBImageHelper *) sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.cacheDict = [[NSMutableDictionary alloc] init];
        self.urlRequests = [[NSMutableDictionary alloc] init];
        self.imageViewRequestStash = [[NSMutableDictionary alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(urlRequestSucceded:) name:kURLRequestSuccessNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(urlRequestFailed:) name:kURLRequestFailureNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearCache:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void) getImageForFacebookFriend:(NSString *)facebookFriend
                      forImageView:(UIImageView *) imageView
                          withSize:(NSUInteger) size
                  withSuccessBlock:(HBImageHelperGetImageSuccessBlock)successBlock 
                  withFailureBlock:(HBImageHelperGetImageFailureBlock)failureBlock {
    
    if (facebookFriend == nil) {
//        failureBlock([HBErrorHelper errorWithCode:801 withMessage:@"can't get image for nil FacebookFriend object" withInfo:nil]);
        return;
    }
    else {
        NSString * sizeString;
        if (size == NMIMAGE_SIZE_LARGE) sizeString = @"large";
        else if (size == NMIMAGE_SIZE_MEDIUM) sizeString = @"normal";
        else if (size == NMIMAGE_SIZE_SMALL) sizeString = @"small";
        else if (size == NMIMAGE_SIZE_SQUARE) sizeString = @"square";
        else {
//            failureBlock([HBErrorHelper errorWithCode:802 withMessage:[NSString stringWithFormat:@"unknown image size [%d] requested from NMImageHelper", size] withInfo:nil]);
            return;
        }
        
        NSString * imageUrl = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=%@", facebookFriend, sizeString];
        
        HBImageRequest * request = [[HBImageRequest alloc] init];
        request.urlString = imageUrl;
        request.successBlock = successBlock;
        request.failureBlock = failureBlock;
        request.imageView = imageView;
        
        [self executeImageRequest:request];
    }
}

- (void) getImageWithURLString:(NSString *) urlString
                  forImageView:(UIImageView *) imageView
              withSuccessBlock:(HBImageHelperGetImageSuccessBlock)successBlock 
              withFailureBlock:(HBImageHelperGetImageFailureBlock)failureBlock {
    
    HBImageRequest * request = [[HBImageRequest alloc] init];
    request.urlString = urlString;
    request.successBlock = successBlock;
    request.failureBlock = failureBlock;
    request.imageView = imageView;
    
    [self executeImageRequest:request];
}


- (void) executeImageRequest:(HBImageRequest *)request {
    
    // check to see if there already a pending request for this image view
    // we do this so that we only hold onto the most recent success or failure blocks attached to a given image view
    // this should solve the issue of visible image catch up when fast scrolling in table views
    HBImageRequest * oldRequest = [self.imageViewRequestStash objectForKey:request.imageViewKey];
    [self.imageViewRequestStash setObject:request forKey:request.imageViewKey];
    
    // if the old request is still pending somewhere, remove it 
    NSMutableArray * oldRequestStash = [self.urlRequests objectForKey:oldRequest.urlString];
    if (oldRequestStash != nil) {
        [oldRequestStash removeObject:oldRequest];
        
        if ([oldRequestStash count] < 1) {
            // remove the unused stash
            [self.urlRequests removeObjectForKey:oldRequest.urlString];
        }
    }
    
    
    // check to see if the image requested is in the cache
    // if it is, return it and we are done
    UIImage * image = [self.cacheDict objectForKey:request.urlString];
    if (image != nil) {
        // NSLog(@"main - retrieved from cache - %@", urlString);
        request.imageView.image = image;
        request.successBlock(image);
        [self.imageViewRequestStash removeObjectForKey:request.imageViewKey];
        return;
    }
    
    request.imageView.image = nil;
    
    // if not,
    
    // check this image url to see if there are any other pending requests for for this image
    NSMutableArray * urlRequestStash = [self.urlRequests objectForKey:request.urlString];
    if (urlRequestStash != nil) {
        // add this request to the stash so it can be processed when the image is finished loading into the cache
        [urlRequestStash addObject:request];
    }
    else {
        // create the stash
        NSMutableArray * stash = [[NSMutableArray alloc] init];
        [stash addObject:request];
        [self.urlRequests setObject:stash forKey:request.urlString];
        
        // since this is the first time that this image is being requested, go get it and send a notification
        // when it has been retrieved
        
        // since this request could be from a fast scrolling table view, wait for a fraction of a second to see if it is still necessary to go get it
        [HBBlockHelper executeBlock:^{
            
            // check to see if we still need to get this image
            __block BOOL stillNeeded = NO;
            [self.imageViewRequestStash enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                HBImageRequest * req = (HBImageRequest *) obj;
                if ([req.urlString isEqualToString:request.urlString]) {
                    stillNeeded = YES;
                }
            }];
            
            if(stillNeeded) {
                //NSLog(@"requesting image from server");
                DataConnector * dataConnector = [[DataConnector alloc] init];
                [dataConnector 
                 getContentsOfURLFromString:request.urlString 
                 withSuccessBlock:^(NSData *returnData) {
                     // create the image and add it to the cache
                     UIImage * image = [UIImage imageWithData:returnData];
                     [self.cacheDict setObject:image forKey:request.urlString];
                     [[NSNotificationCenter defaultCenter] postNotificationName:kURLRequestSuccessNotification object:request.urlString];
                 } withFailureBlock:^(NSError *error) {
                     [[NSNotificationCenter defaultCenter] postNotificationName:kURLRequestSuccessNotification object:request.urlString userInfo:[NSDictionary dictionaryWithObject:error forKey:@"error"]];
                 }];
            }
            else {
                //NSLog(@"image request canceled");
            }
            
        } afterDelay:0.5];
        
    }
}

- (void) urlRequestSucceded:(NSNotification *)notification {
    NSString * urlString = [notification object];
    
    // NSLog(@"success notification recieved for %@", urlString);
    
    // get the success stash and call all of the success blocks with the new image
    NSArray * requests = [self.urlRequests objectForKey:[NSString stringWithFormat:@"%@", urlString]];
    
    __block BOOL used = NO;
    [requests enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        HBImageRequest * req = (HBImageRequest *) obj;
        UIImage * image = [self.cacheDict objectForKey:urlString]; 
        
        if (image == nil) {
            NSLog(@"nil image returned from cache for %@", urlString); 
        }
        else {
            //NSLog(@"wait queue - retrieved from cache - %@", urlString);
            
            // make sure that this image is still required
            HBImageRequest * mostRecentImageRequestedForImageView = [self.imageViewRequestStash objectForKey:req.imageViewKey];
            if ([mostRecentImageRequestedForImageView.urlString isEqualToString:req.urlString]) {
                req.successBlock(image);
                req.imageView.image = image;
                [self.imageViewRequestStash removeObjectForKey:req.imageViewKey];
                used = YES;
            }
            
        }
        
    }];
    
    // clear out the stash
    [self.urlRequests removeObjectForKey:[NSString stringWithFormat:urlString]];
}

- (void) urlRequestFailed:(NSNotification *)notification {
    NSString * urlString = [notification object];
    NSError * error = [[notification userInfo] objectForKey:@"error"];
    
    //NSLog(@"failure notification recieved for %@", urlString);
    
    NSArray * requests = [self.urlRequests objectForKey:[NSString stringWithFormat:@"%@", urlString]];
    [requests enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        HBImageRequest * req = (HBImageRequest *) obj;
        
        // make sure that this image is still required
        HBImageRequest * mostRecentImageRequestedForImageView = [self.imageViewRequestStash objectForKey:req.imageViewKey];
        if ([mostRecentImageRequestedForImageView.urlString isEqualToString:req.urlString]) {
            req.failureBlock(error);
        }
    }];
    
    
    // clear out the stashes
    [self.urlRequests removeObjectForKey:urlString];
}

- (void) clearCache:(NSNotification *)notification {
    // NSLog(@"clearing cache");
    [self.cacheDict removeAllObjects];
}


@end
