    //
//  UILazyImageView.m
//  HaikuBrew
//
//  Created by Brian Ellison on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UILazyImageView.h"



@implementation UILazyImageView
@synthesize receivedData;
@synthesize yourBrewsIndividualDelegate;
@synthesize url;

- (id)initWithURL:(NSURL *)pUrl withDelegate:(NSObject<YourBrewsIndividualDelegate> *) pDelegate;
{
    self = [self init];
    
    if (self)
    {
	    self.receivedData = [[NSMutableData alloc] init];
        self.yourBrewsIndividualDelegate = pDelegate;
        NSLog(@"PURL: %@", pUrl);
        self.url = pUrl;
//        [self loadWithURL:pUrl];
    }
    
    return self;
}


- (void)loadWithURL:(NSURL *)pUrl    
{
    NSLog(@"URL: %@", pUrl);
    //	if (!self.image && self.url && !_loading)
	{
        
		_loading = YES;
		[self performSelectorInBackground:@selector(loadImageAtURL:) withObject:pUrl];
	}	
    
//	self.alpha = 0;
//    NSURLConnection *connection = [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:url]delegate:self];
//    [connection start];
}
//
//
//
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//{
//    [self.receivedData setLength:0];
//}
//
//
//
//-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//{
//   
//    [self.receivedData appendData:data];
//}
//
//
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//    [self.yourBrewsIndividualDelegate imageLoadComplete];
//    self.image = [[UIImage alloc] initWithData:self.receivedData];
//    [UIView beginAnimations:@"fadeIn" context:NULL];
//    [UIView setAnimationDuration:0.5];
//    self.alpha = 1.0;
//    [UIView commitAnimations];
//}


- (void)loadImageAtURL:(NSURL *) parUrl
{
	  NSLog(@"URL: %@", parUrl);
	NSData *data = [[NSData alloc] initWithContentsOfURL:parUrl];
    
	if (data)
	{
		UIImage *image = [[UIImage alloc] initWithData:data];
        
		[self performSelectorOnMainThread:@selector(setImage:) withObject:image 
                            waitUntilDone:YES];
        
	}
    
    _loading = NO;
    
}

//- (void)didMoveToSuperview
//{
//    NSLog(@"URL: %@", self.url);
////	if (!self.image && self.url && !_loading)
//	{
//        
//		_loading = YES;
//		[self performSelectorInBackground:@selector(loadImageAtURL:) withObject:self.url];
//	}	
//}




@end
