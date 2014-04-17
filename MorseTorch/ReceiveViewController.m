//
//  ReceiveViewController.m
//  MorseTorch
//
//  Created by Cole Bratcher on 4/17/14.
//  Copyright (c) 2014 Cole Bratcher. All rights reserved.
//

#import "ReceiveViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ReceiveViewController () <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *segueToTransmitModeButton;
@property (weak, nonatomic) IBOutlet UIButton *receiveStopButton;
@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *cameraPreviewLayer;

@end

@implementation ReceiveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.receiveStopButton addTarget:self action:@selector(receive:) forControlEvents:UIControlEventTouchUpInside];
    [self.segueToTransmitModeButton setTintColor:[UIColor blueColor]];
    

}

- (void)viewDidAppear:(BOOL)animated
{
    AVCaptureDevice *cameraDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *cameraInput = [AVCaptureDeviceInput deviceInputWithDevice:cameraDevice error:nil];
    AVCaptureSession *cameraSession  = [AVCaptureSession new];
    [cameraSession setSessionPreset:AVCaptureSessionPresetMedium];
    [cameraSession addInput:cameraInput];
    self.cameraPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:cameraSession];
       AVCaptureVideoDataOutput *cameraVideoDataOutput = [AVCaptureVideoDataOutput new];
    [cameraSession addOutput:cameraVideoDataOutput];
    [self.cameraView.layer addSublayer:self.cameraPreviewLayer];
    self.cameraPreviewLayer.frame = self.cameraView.bounds;
    self.cameraPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
 
    [cameraSession startRunning];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    self.cameraPreviewLayer.frame = self.cameraView.bounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)receive:(id)sender
{
    [self.receiveStopButton removeTarget:self action:@selector(receive:) forControlEvents:UIControlEventTouchUpInside];
    [self.receiveStopButton addTarget:self action:@selector(stop:) forControlEvents:UIControlEventTouchUpInside];
    [self.receiveStopButton setTitle:@"Stop" forState:UIControlStateNormal];
    [self.receiveStopButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.segueToTransmitModeButton.enabled = NO;
    [self.segueToTransmitModeButton setTintColor:[UIColor grayColor]];
    
}


-(void)stop:(id)sender
{
    [self.receiveStopButton removeTarget:self action:@selector(stop:) forControlEvents:UIControlEventTouchUpInside];
    [self.receiveStopButton addTarget:self action:@selector(receive:) forControlEvents:UIControlEventTouchUpInside];
    [self.receiveStopButton setTitle:@"Receive" forState:UIControlStateNormal];
    [self.receiveStopButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    self.segueToTransmitModeButton.enabled = YES;
    [self.segueToTransmitModeButton setTintColor:[UIColor blueColor]];
     
}
@end