//
//  ReceiveDataController.h
//  MorseTorch
//
//  Created by Cole Bratcher on 4/18/14.
//  Copyright (c) 2014 Cole Bratcher. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ReceiveDataControllerDelegate <NSObject>

-(void)displayRecievedMessage:(NSString *)newMessage;

@end

@interface ReceiveDataController : NSObject

@property (nonatomic, weak) id <ReceiveDataControllerDelegate> delegate;

-(NSString *)convertBrightnessValueToMessage:(NSString *)brightnessValue;

@end
