//
//  HaikuBrewRequest.h
//
//  Created by Haiku Brew on 7/25/11.
//  Copyright 2011 Haiku Brew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HaikuBrewRequest : NSObject <NSURLConnectionDelegate>{
    
    
    NSString * urlString;
    NSMutableArray * arguments;
    
    NSArray *results;
    NSArray *arrayResults;
    NSError *requestError;
    
    NSData *imagePic;
    NSData *finalImageShot;

}


@property (retain) NSString * urlString;
@property (retain) NSMutableArray * arguments;
@property (nonatomic, retain)  NSArray *results;
@property (nonatomic, retain)  NSArray *arrayResults;
@property (nonatomic, retain)  NSError *requestError;
@property (nonatomic, retain)  NSData *imagePic;
@property (nonatomic, retain)  NSData *finalImageShot;

- (void) addArgumentValue: (NSString *) value ;
- (BOOL) execute;


- (NSString *) getValueForDictionary:(NSDictionary *) dict withKey:(NSString *) key;

@end
