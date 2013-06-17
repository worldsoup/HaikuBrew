//
//  HaikuBrewRequest.m
//
//  Created by Haiku Brew on 7/25/11.
//  Copyright 2011 Haiku Brew. All rights reserved.
//

#import "HaikuBrewRequest.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "NotificationManager.h"
#import "SBJsonParser.h"

@interface HaikuBrewRequest (Private)
-(void) sendNotificationWithString:(NSString *) noticationString;
@end

@implementation HaikuBrewRequest



@synthesize urlString, results, arguments, arrayResults, imagePic, finalImageShot;
@synthesize requestError;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void) addArgumentValue:(NSString *)value 
{
    if(arguments == nil)
        arguments = [[NSMutableArray alloc] init];
    
    CFStringRef escapedValue = CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge_retained CFStringRef)value, NULL, CFSTR("%:/?#[]@!$&'()*+,;="), kCFStringEncodingUTF8);
    
    [arguments addObject:(__bridge_transfer NSString *) escapedValue];
}


- (BOOL) execute{   
    
    NSString * scheme = @"http";
    NSString * host = @"23.23.184.163/api/";
//    NSString * host = @"dayspawn.com/api/";
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@://%@%@", scheme, host, self.urlString];
    
    // copy the arguments into the request
    if(arguments != nil)
    {
        for(int i = 0; i < [arguments count]; i ++)
        {
            NSString *argument = [arguments objectAtIndex:i];
            urlStr = [NSString stringWithFormat:@"%@/%@", urlStr, argument];
        }
    }
    
//    NSString* webStringURL = [urlStr stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
//    NSLog(@"WEbString Encoded: %@", webStringURL);
	
    NSURL * url = [NSURL URLWithString: urlStr ];
    

    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:url];
    if(self.imagePic != nil)
    {
        
        
        
        [request setData:self.imagePic withFileName:@"test.png" andContentType:@"image/png" forKey:@"uploadedBackgroundImage"];
//        UIImage *img = [UIImage imageNamed:@"sample.png"];
//        
//        NSData *imgData = UIImageJPEGRepresentation(img, 0);
        
        NSLog(@"Size of Image(bytes):%d",[self.imagePic length]);
    }
    
    if(self.finalImageShot != nil)
    {
        [request setData:self.imagePic withFileName:@"FinalImage.png" andContentType:@"image/png" forKey:@"finalImageShot"];
        //        UIImage *img = [UIImage imageNamed:@"sample.png"];
        //
        //        NSData *imgData = UIImageJPEGRepresentation(img, 0);
        
        NSLog(@"Size of Final Image Shot Uploaded(bytes):%d",[self.imagePic length]);
    }
       
    [request setTimeOutSeconds:20];
    [request setShouldRedirect:NO];
    
    NSLog(@"URL: %@", urlStr);
    
    // start the request
    [request startSynchronous];
    
    NSError * error = [request error];
    
    // get the resulting JSON and return 
    // the an unmarshalled array of dictionaries
    if (!error) {
		NSString *response = [request responseString];
        // check repsonse for HTML 
        // if it's present, then there's an error
        NSRange foundRange = [response rangeOfString:@"<HTML>" options:NSCaseInsensitiveSearch];
        NSRange foundRange1 = [response rangeOfString:@"<html" options:NSCaseInsensitiveSearch];
        if(foundRange.length != 0 || foundRange1.length != 0)
        {
//            [self sendNotificationWithString:@"ERROR"];
            [[NotificationManager getInstance] displayNotificationWithTitle:@"Error" withMessage:@"There has been an network communication error."];
            
            self.requestError = [NSError errorWithDomain:@"luminantDomain" code:100 userInfo:nil];
            return NO;
        }
        
        
        NSArray * jsonResults;
		id o = [response JSONValue];
        
        // if the results are a dictionary, wrap them in an array
        if([o isKindOfClass:[NSDictionary class]])
        {
            jsonResults = [[NSArray alloc] initWithObjects:o,nil];
        }
        else
            jsonResults = o;
        
        
        self.results = [[NSArray alloc] initWithArray:jsonResults];
        
        
        // check to see if the jason returned is an error
//        for(NSDictionary *resultDict in self.results){
//            if([resultDict objectForKey:@"flatReturnDetails"] != nil)
//            {          
//                NSDictionary *flatReturnDetails = [resultDict objectForKey:@"flatReturnDetails"];
//                if([[flatReturnDetails objectForKey:@"success"] isEqualToString:@"NO"])
//                {
//                    [[NotificationManager getInstance] displayNotificationWithTitle:@"RTD Error" withMessage:[flatReturnDetails objectForKey:@"details"]];
//                    return NO;
//                }
//            }
//        }
        return YES;
	}
	else{
        
        self.requestError = error;
        
        NSMutableString * message = [[NSMutableString alloc] init];
        NSMutableString * title = [[NSMutableString alloc] init];
        if(error.code == 3)
        {
           // [self sendNotificationWithString:RTDLoginBadCredentials];
            [title appendString:@"Invalid Login"];
            [message appendString:@"Please check your username and/or password and try again."];
            
        }
        else if(error.code == 1 || error.code == 2)
        {
           // [self sendNotificationWithString:RTDRequestErrorTimeout];
            [title appendString:@"Timeout"];
            [message appendString:@"Please make sure that you have a connection"];
        }
        else
        {
            [title appendString:@"Error"]; 
            [message appendString:[NSString stringWithFormat:@"Communication Error (%d) %@",  error.code, error.localizedDescription]]; 
            
            
        }
        
        [[NotificationManager getInstance] displayNotificationWithTitle:title withMessage:message];
        
        return NO;
	}
    
    
    
    return YES;    
}


-(void) sendNotificationWithString:(NSString *) noticationString
{
    NSNotification *notification;
    notification = [NSNotification notificationWithName:noticationString object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}


- (NSString *) getValueForDictionary:(NSDictionary *) dict withKey:(NSString *) key
{
    
    if([dict objectForKey:key] != nil)
    {
        id value = [dict objectForKey:key];
        if (value == nil) {
            return nil;

        }
        if(value == [NSNull null])
            return nil;
        
        if([[dict objectForKey:key] class] == NSNumber.class)
        {
            return [[dict objectForKey:key] stringValue];
        }
        
        if([[dict objectForKey:key] class] == NSDecimalNumber.class)
        {
            return [[dict objectForKey:key] stringValue];
        }
       
        return [dict objectForKey:key] ;
    }
    else {
        return nil;
    }
    
}


@end
