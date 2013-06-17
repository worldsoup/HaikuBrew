//
//  HBImageRequest.h
//  HaikuBrew
//
//  Created by Brian Ellison on 5/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HBImageHelperGetImageSuccessBlock)(UIImage * image);
typedef void (^HBImageHelperGetImageFailureBlock)(NSError  * error);

@interface HBImageRequest : NSObject
@property (nonatomic, strong) NSString * urlString;
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, readonly) NSString * imageViewKey;
@property (nonatomic, copy) HBImageHelperGetImageSuccessBlock successBlock;
@property (nonatomic, copy) HBImageHelperGetImageFailureBlock failureBlock;
@end