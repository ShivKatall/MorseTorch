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
    self = [super init];
    if (self) {
        self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        self.flashQueue = [NSOperationQueue new];
        self.flashQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}

-(void) convertMorseFromString:(NSString *)userString
{
    NSMutableArray *MorseLetterArray = [userString flashArrayFromString];

    for (NSString *morseLetter in MorseLetterArray)
    {
        [self.flashQueue addOperationWithBlock:^{
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.delegate displayNewLetter:[morseLetter englishLetterFromMorseLetter]];
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
