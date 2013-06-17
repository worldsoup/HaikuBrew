//
//  UILazyImageView.h
//  HaikuBrew
//
//  Created by Brian Ellison on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YourBrewsIndividualDelegate <NSObject>
@optional
- (void) imageLoadComplete;
@end




@interface UILazyImageView : UIImageView
{

    
	BOOL _loading; 

}

@property (nonatomic, retain) NSMutableData *receivedData;  
@property (nonatomic, retain) NSObject<YourBrewsIndividualDelegate> *yourBrewsIndividualDelegate;

- (id)initWithURL:(NSURL *)pUrl withDelegate:(NSObject<YourBrewsIndividualDelegate> *) pDelegate;
- (void)loadWithURL:(NSURL *)url;


@property (nonatomic, retain) NSURL *url;

@end