//
//  NSString+MorseCode.m
//  MorseTorch
//
//  Created by Cole Bratcher on 4/15/14.
//  Copyright (c) 2014 Cole Bratcher. All rights reserved.
//

#import "NSString+MorseCode.h"
#import <AVFoundation/AVFoundation.h>

@implementation NSString (MorseCode)

- (NSMutableArray *)morseArrayFromString
{
    NSString *inputString = [self uppercaseString];
    
    NSDictionary *morseDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
            @".-", @"A",
            @"-...", @"B",
            @"-.-.", @"C",
            @"-..", @"D",
            @".", @"E",
            @"..-.", @"F",
            @"--.", @"G",
            @"....", @"H",
            @"..", @"I",
            @".---", @"J",
            @"-.-", @"K",
            @".-..", @"L",
            @"--", @"M",
            @"-.", @"N",
            @"---", @"O",
            @".--.", @"P",
            @"--.-", @"Q",
            @".-.", @"R",
            @"...", @"S",
            @"-", @"T",
            @"..-", @"U",
            @"...-", @"V",
            @".--", @"W",
            @"-..-", @"X",
            @"-.--", @"Y",
            @"--..", @"Z",
            @".----", @"1",
            @"..---", @"2",
            @"...--", @"3",
            @"....-", @"4",
            @".....", @"5",
            @"-....", @"6",
            @"--...", @"7",
            @"---..", @"8",
            @"----.", @"9",
            @"-----", @"0",
            @"BREAK", @" ",
            @"STOP", @".",
            nil];
    
    NSMutableArray *morseArray = [NSMutableArray new];

    for (NSInteger i=0; i<inputString.length; i++) {
        NSString *letterString = [inputString substringWithRange:NSMakeRange(i, 1)];
        NSString *morseLetter = [morseDictionary objectForKey:letterString];
        if (morseLetter) {
            [morseArray addObject:morseLetter];
        }
    }
    return morseArray;
}

-(NSString *)englishLetterFromMorseLetter
{
    NSDictionary *morseDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"A", @".-",
                                     @"B", @"-...",
                                     @"C", @"-.-.",
                                     @"D", @"-..",
                                     @"E", @".",
                                     @"F", @"..-.",
                                     @"G", @"--.",
                                     @"H", @"....",
                                     @"I", @"..",
                                     @"J", @".---",
                                     @"K", @"-.-",
                                     @"L", @".-..",
                                     @"M", @"--",
                                     @"N", @"-.",
                                     @"O", @"---",
                                     @"P", @".--.",
                                     @"Q", @"--.-",
                                     @"R", @".-.",
                                     @"S", @"...",
                                     @"T", @"-",
                                     @"U", @"..-",
                                     @"V", @"...-",
                                     @"W", @".--",
                                     @"X", @"-..-",
                                     @"Y", @"-.--",
                                     @"Z", @"--..",
                                     @"1", @".----",
                                     @"2", @"..---",
                                     @"3", @"...--",
                                     @"4", @"....-",
                                     @"5", @".....",
                                     @"6", @"-....",
                                     @"7", @"--...",
                                     @"8", @"---..",
                                     @"9", @"----.",
                                     @"0", @"-----",
                                     @" ", @" ",
                                     @".", @".",
                                     nil];

    return [morseDictionary objectForKey:self];
}

@end
