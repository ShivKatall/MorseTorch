//
//  NSString+MorseCode.h
//  MorseTorch
//
//  Created by Cole Bratcher on 4/15/14.
//  Copyright (c) 2014 Cole Bratcher. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MorseCode)

- (NSMutableArray *)morseArrayFromString;
- (NSMutableArray *)flashArrayFromString;
-(NSString *)englishLetterFromMorseLetter;

@end
