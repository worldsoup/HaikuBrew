//
//  DelegateMethods.h
//  HaikuBrew
//
//  Created by Brian Ellison on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef HaikuBrew_DelegateMethods_h
#define HaikuBrew_DelegateMethods_h


@protocol PostToWhoKnowsWhatDelegate <NSObject>
-(void) displayMessageViewController:(NSString *) _message;
-(void) displayMessageViewController:(NSString *) _message andPop:(NSNumber *) isPop;

@end


#endif
