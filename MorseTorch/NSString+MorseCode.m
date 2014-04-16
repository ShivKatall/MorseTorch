//
//  NSString+MorseCode.m
//  MorseTorch
//
//  Created by Cole Bratcher on 4/15/14.
//  Copyright (c) 2014 Cole Bratcher. All rights reserved.
//

#import "NSString+MorseCode.h"

@implementation NSString (MorseCode)

+ (NSMutableArray *)morseArrayFromString:(NSString *)inputString
{
    inputString = [inputString uppercaseString];
    
    NSMutableArray *morsePhrase = [NSMutableArray new];
    
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
            @"BREAK", @" ",
            @"STOP", @".",
            nil];

    for (NSInteger i=0; i<inputString.length; i++) {
        NSString *letterString = [inputString substringWithRange:NSMakeRange(i, 1)];
        NSString *morseValue = [morseDictionary objectForKey:letterString];
        if (morseValue) {
            if ([morseValue isEqualToString:@"BREAK"]) {
                // new word
            }
            NSMutableArray *symbols = [NSMutableArray new];
            for (NSInteger j=0; j<morseValue.length; j++) {
                NSString *symbol = [morseValue substringWithRange:NSMakeRange(j, 1)];
                [symbols addObject:symbol];
            }
            // split symbols
            [morsePhrase addObject:symbols];
        };
    }
    return morsePhrase;
}
@end
