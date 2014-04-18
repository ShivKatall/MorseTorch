//
//  ReceiveViewController.m
//  MorseTorch
//
//  Created by Cole Bratcher on 4/17/14.
//  Copyright (c) 2014 Cole Bratcher. All rights reserved.
//

#import "ReceiveViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/CGImageProperties.h>
#import "ReceiveDataController.h"

@interface ReceiveViewController () <AVCaptureVideoDataOutputSampleBufferDelegate, ReceiveDataControllerDelegate>

@property (strong, nonatomic) ReceiveDataController *myReceiveDataController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *segueToTransmitModeButton;
@property (weak, nonatomic) IBOutlet UIButton *receiveStopButton;
@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (strong, nonatomic)AVCaptureVideoPreviewLayer *cameraPreviewLayer;
@property (strong, nonatomic)AVCaptureMovieFileOutput *movieFileOutput;
@property (strong, nonatomic) NSString *brightnessValue;

@end

@implementation ReceiveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.myReceiveDataController.delegate = self;
    [self.receiveStopButton addTarget:self action:@selector(receive:) forControlEvents:UIControlEventTouchUpInside];
    [self.segueToTransmitModeButton setTintColor:[UIColor blueColor]];
    

}

- (void)viewDidAppear:(BOOL)animated
{
    
    // C written by John Clem (creates video queue for IOkit)
    dispatch_queue_t videoQueue = dispatch_queue_create("videoQueue", NULL);
    
    // Sets up camera
    AVCaptureDevice *cameraDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *cameraInput = [AVCaptureDeviceInput deviceInputWithDevice:cameraDevice error:nil];
    AVCaptureSession *cameraSession  = [AVCaptureSession new];
    [cameraSession setSessionPreset:AVCaptureSessionPresetMedium];
    [cameraSession addInput:cameraInput];
    
    // Creates camera preview
    self.cameraPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:cameraSession];
       AVCaptureVideoDataOutput *cameraVideoDataOutput = [AVCaptureVideoDataOutput new];
    [cameraVideoDataOutput setSampleBufferDelegate:self queue:videoQueue];
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

// Following method uses code from: http://www.ios-developer.net/iphone-ipad-programmer/development/camera/record-video-with-avcapturesession-2
-(void)receive:(id)sender
{
    // Create temporary URL for movie output
    NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"output.mov"];
    NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:outputPath])
    {
        NSError *error;
        if ([fileManager removeItemAtPath:outputPath error:&error] == NO)
        {
            //Error - handle if requried
        }
    }
    // Start recording
    // Bool property that tells it to something with the data.
    
    // Change button state
    [self.receiveStopButton removeTarget:self action:@selector(receive:) forControlEvents:UIControlEventTouchUpInside];
    [self.receiveStopButton addTarget:self action:@selector(stop:) forControlEvents:UIControlEventTouchUpInside];
    [self.receiveStopButton setTitle:@"Stop" forState:UIControlStateNormal];
    [self.receiveStopButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.segueToTransmitModeButton.enabled = NO;
    [self.segueToTransmitModeButton setTintColor:[UIColor grayColor]];
    
}


-(void)stop:(id)sender
{
    // Stop recording
    // Bool property that tells it to stop doing things with the data.
    
    // Change button state
    [self.receiveStopButton removeTarget:self action:@selector(stop:) forControlEvents:UIControlEventTouchUpInside];
    [self.receiveStopButton addTarget:self action:@selector(receive:) forControlEvents:UIControlEventTouchUpInside];
    [self.receiveStopButton setTitle:@"Receive" forState:UIControlStateNormal];
    [self.receiveStopButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    self.segueToTransmitModeButton.enabled = YES;
    [self.segueToTransmitModeButton setTintColor:[UIColor blueColor]];
     
}

// Method written by John Clem
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    NSDictionary* dict = (__bridge NSDictionary*)CMGetAttachment(sampleBuffer, kCGImagePropertyExifDictionary, NULL);
    
    self.brightnessValue = [dict objectForKey:(__bridge NSString *)kCGImagePropertyExifBrightnessValue];
    
    NSLog(@"%@", self.brightnessValue);
    
}

@end