//
//  TorchController.h
//  MorseTorch
//
//  Created by Cole Bratcher on 4/16/14.
//  Copyright (c) 2014 Cole Bratcher. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TorchControllerDelegate <NSObject>                               // Protocol makes it possible for other views to use these methods. (Question: can you send these protocol methods to multiple other classes?)

-(void)displayNewLetter:(NSString *)newLetter;
-(void)endOfDisplay;

@end

@interface TorchController : NSObject

@property (nonatomic, weak) id <TorchControllerDelegate> delegate;          // creates torch controller delegate other classes can grab?

-(void) convertToTorchSignalFromString:(NSString *)userString;

@end
