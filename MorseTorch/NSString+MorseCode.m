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
    //NSMutableArray *word = [NSMutableArray new];

    for (NSInteger i=0; i<inputString.length; i++) {
        NSString *letterString = [inputString substringWithRange:NSMakeRange(i, 1)];
        NSString *morseLetter = [morseDictionary objectForKey:letterString];
        if (morseLetter) {
            
            [morseArray addObject:morseLetter];
        }
        
    }
    return morseArray;
}

-(NSString *)durationForPip:(NSString *)pip
{
    if ([pip isEqualToString:@"."]) {
        return @"100000";
    } else {
        return @"300000";
    }
}

- (NSMutableArray *)flashArrayFromMorseArray:(NSArray *)morseArray
{
    NSMutableArray *flashArray = [NSMutableArray new];
    
    NSLog(@"Morse Array: %@", morseArray);
    for (NSMutableArray *word in morseArray){
        for (NSMutableArray *letter in word){
            for (NSString *pip in letter){
                [flashArray addObject:@"ON"];
                [flashArray addObject:[self durationForPip:pip]];
                [flashArray addObject:@"OFF"];
                [flashArray addObject:@"100000"]; //after a pip
            }
            [flashArray addObject:@"200000"]; // after a letter
        }
        [flashArray addObject:@"400000"]; // after a word
    }
    
    NSOperationQueue *flashQueue = [NSOperationQueue new];
    [flashQueue setMaxConcurrentOperationCount:1];

    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    for (NSString *flashOpString in flashArray) {
        NSBlockOperation *flashOperation;
        if ([flashOpString isEqualToString:@"ON"]) {
            flashOperation = [NSBlockOperation blockOperationWithBlock:^{
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    if ([device hasTorch] || [device hasFlash]) {
                        [device lockForConfiguration:nil];
                        [device setTorchMode:AVCaptureTorchModeOn];
                        [device setFlashMode:AVCaptureFlashModeOn];
                        [device unlockForConfiguration];
                    }
                }];
            }];
        } else if ([flashOpString isEqualToString:@"OFF"]) {
            flashOperation = [NSBlockOperation blockOperationWithBlock:^{
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    if ([device hasTorch] || [device hasFlash]) {
                        [device lockForConfiguration:nil];
                        [device setTorchMode:AVCaptureTorchModeOff];
                        [device setFlashMode:AVCaptureFlashModeOff];
                        [device unlockForConfiguration];
                    }
                }];
            }];
        } else {
            flashOperation = [NSBlockOperation blockOperationWithBlock:^{
                usleep([flashOpString integerValue]);
            }];
        }
        [flashQueue addOperation:flashOperation];
    }
    
    return flashArray;
    NSLog(@"Returned Flash Array");

}

- (NSMutableArray *)flashArrayFromString
{
    NSMutableArray *morsePhrase = [self morseArrayFromString];
    return morsePhrase;
    NSLog(@"flashArrayFromString finished");

}

@end
