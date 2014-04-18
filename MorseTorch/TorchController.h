//
//  TorchController.h
//  MorseTorch
//
//  Created by Cole Bratcher on 4/16/14.
//  Copyright (c) 2014 Cole Bratcher. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TorchControllerDelegate <NSObject>                               // Protocol makes it possible for other views to use these methods. (Question: can you send these protocol methods to multiple other classes? Answer: Yes, but the TorchController will only actively send to the delegate.
-(void)displayNewLetter:(NSString *)newLetter;
-(void)endOfDisplay;

@end

@interface TorchController : NSObject

@property (nonatomic, weak) id <TorchControllerDelegate> delegate;          // creates torch controller delegate that only ONE other class can grab.

-(void)convertToTorchSignalFromString:(NSString *)userString;
-(void)cancelTransmission;

@end


// Extra Questions:
// 1) How the hell did we do all that cocoaPod stuff? More Info Please?
