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

@property (nonatomic, strong) AVCaptureDevice *torchDevice;
@property (strong, nonatomic) NSOperationQueue *flashQueue;

@end

@implementation TorchController

-(id)init {
    self = [super init];                                                    // Calls from superclass (DON'T FULLY UNDERSTAND THIS)
    if (self) {
        self.torchDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
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
            NSString *pip = [morseLetter substringWithRange:NSMakeRange(i, 1)];
            
            if ([pip isEqualToString:@"."])
            {
                [self.flashQueue addOperationWithBlock:^{
                    if ([_torchDevice hasTorch] || [_torchDevice hasFlash]) {
                        [_torchDevice lockForConfiguration:nil];
                        [_torchDevice setTorchMode:AVCaptureTorchModeOn];
                        [_torchDevice setFlashMode:AVCaptureFlashModeOn];
                        [_torchDevice unlockForConfiguration];
                        usleep(100000);
                        [_torchDevice lockForConfiguration:nil];
                        [_torchDevice setTorchMode:AVCaptureTorchModeOff];
                        [_torchDevice setFlashMode:AVCaptureFlashModeOff];
                        [_torchDevice unlockForConfiguration];
                        usleep(100000);
                    }
                }];
            }
            else if ([pip isEqualToString:@"-"])
            {
                [self.flashQueue addOperationWithBlock:^{
                    if ([_torchDevice hasTorch] || [_torchDevice hasFlash]) {
                        [_torchDevice lockForConfiguration:nil];
                        [_torchDevice setTorchMode:AVCaptureTorchModeOn];
                        [_torchDevice setFlashMode:AVCaptureFlashModeOn];
                        [_torchDevice unlockForConfiguration];
                        usleep(300000);
                        [_torchDevice lockForConfiguration:nil];
                        [_torchDevice setTorchMode:AVCaptureTorchModeOff];
                        [_torchDevice setFlashMode:AVCaptureFlashModeOff];
                        [_torchDevice unlockForConfiguration];
                        usleep(100000);
                    }
                }];
                
            }
            else if ([pip isEqualToString:@"BREAK"])
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

-(void)cancelTransmission
{
    [self.flashQueue cancelAllOperations];
}

@end
