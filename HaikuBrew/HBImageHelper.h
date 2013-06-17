//
//  HBImageHelper.h
//  HaikuBrew
//
//  Created by Brian Ellison on 5/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBImageRequest.h"

#define NMIMAGE_SIZE_LARGE 3
#define NMIMAGE_SIZE_MEDIUM 2
#define NMIMAGE_SIZE_SMALL 1
#define NMIMAGE_SIZE_SQUARE 4


@interface HBImageHelper : NSObject

@property (nonatomic, strong) NSMutableDictionary * cacheDict;
@property (nonatomic, strong) NSMutableDictionary * urlRequests;
@property (nonatomic, strong) NSMutableDictionary * imageViewRequestStash;


+ (HBImageHelper *) sharedInstance;

- (void) getImageWithURLString:(NSString *) urlString
                  forImageView:(UIImageView *) imageView
              withSuccessBlock:(HBImageHelperGetImageSuccessBlock)successBlock 
              withFailureBlock:(HBImageHelperGetImageFailureBlock)failureBlock;

- (void) getImageForFacebookFriend:(NSString *) facebookFriend
                      forImageView:(UIImageView *) imageView
                          withSize:(NSUInteger) size
                  withSuccessBlock:(HBImageHelperGetImageSuccessBlock)successBlock 
                  withFailureBlock:(HBImageHelperGetImageFailureBlock)failureBlock;

- (void) clearCache:(NSNotification *) notification;


@end
