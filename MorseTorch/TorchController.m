//
//  TorchController.m
//  MorseTorch
//
//  Created by Cole Bratcher on 4/16/14.
//  Copyright (c) 2014 Cole Bratcher. All rights reserved.
//

#import "TorchController.h"
#import <AVFoundation/AVFoundation.h>
#import "NSString+MorseCode.h"

@interface TorchController ()

@property (nonatomic, strong) AVCaptureDevice *device;
@property (strong, nonatomic) NSOperationQueue *flashQueue;

@end

@implementation TorchController

-(id)init {
    self = [super init];                                                    // Calls from superclass (DON'T FULLY UNDERSTAND THIS)
    if (self) {
        self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        self.flashQueue = [NSOperationQueue new];
        self.flashQueue.maxConcurrentOperationCount = 1;                                // calls method that changes max operation count to 1. (only one thing at a time) (WHAT DOES THE FULL SYNTAX LOOK LIKE?)
    }
    return self;
}

-(void)convertToTorchSignalFromString:(NSString *)userString
{
    NSMutableArray *MorseLetterArray = [userString morseArrayFromString];
    for (NSString *morseLetter in MorseLetterArray)
    {
        [self.flashQueue addOperationWithBlock:^{                                   // need to know more about blocks.
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.delegate displayNewLetter:[morseLetter englishLetterFromMorseLetter]];  //So the delegate property referred to here is actually in ViewController.m?
            }];
            
        }];
        
        
        for (int i = 0;i <morseLetter.length; i++)
        {
            NSString *morseSymbol = [morseLetter substringWithRange:NSMakeRange(i, 1)];
            
            if ([morseSymbol isEqualToString:@"."])
            {
                [self.flashQueue addOperationWithBlock:^{
                    if ([_device hasTorch] || [_device hasFlash]) {
                        [_device lockForConfiguration:nil];
                        [_device setTorchMode:AVCaptureTorchModeOn];
                        [_device setFlashMode:AVCaptureFlashModeOn];
                        [_device unlockForConfiguration];
                        usleep(100000);
                        [_device lockForConfiguration:nil];
                        [_device setTorchMode:AVCaptureTorchModeOff];
                        [_device setFlashMode:AVCaptureFlashModeOff];
                        [_device unlockForConfiguration];
                        usleep(100000);
                    }
                }];
            }
            else if ([morseSymbol isEqualToString:@"-"])
            {
                [self.flashQueue addOperationWithBlock:^{
                    if ([_device hasTorch] || [_device hasFlash]) {
                        [_device lockForConfiguration:nil];
                        [_device setTorchMode:AVCaptureTorchModeOn];
                        [_device setFlashMode:AVCaptureFlashModeOn];
                        [_device unlockForConfiguration];
                        usleep(300000);
                        [_device lockForConfiguration:nil];
                        [_device setTorchMode:AVCaptureTorchModeOff];
                        [_device setFlashMode:AVCaptureFlashModeOff];
                        [_device unlockForConfiguration];
                        usleep(100000);
                    }
                }];
                
            }
            else if ([morseSymbol isEqualToString:@"BREAK"])
            {
                [self.flashQueue addOperationWithBlock:^{
                    usleep(400000);
                }];
            }
        }
        [self.flashQueue addOperationWithBlock:^{
            usleep(200000);
        }];
    }
    [self.flashQueue addOperationWithBlock:^{
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.delegate endOfDisplay];
        }];
        
    }];

}


@end
