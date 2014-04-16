//
//  TorchController.h
//  MorseTorch
//
//  Created by Cole Bratcher on 4/16/14.
//  Copyright (c) 2014 Cole Bratcher. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TorchControllerDelegate <NSObject>

-(void)displayNewLetter:(NSString *)newLetter;

@end

@interface TorchController : NSObject

@property (nonatomic, weak) id <TorchControllerDelegate> delegate;

-(void) convertMorseFromString:(NSString *)userString;


@end
