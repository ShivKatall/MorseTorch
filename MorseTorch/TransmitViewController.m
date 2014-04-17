//
//  ViewController.m
//  MorseTorch
//
//  Created by Cole Bratcher on 4/14/14.
//  Copyright (c) 2014 Cole Bratcher. All rights reserved.
//

#import "TransmitViewController.h"
#import "NSString+MorseCode.h"
#import <AVFoundation/AVFoundation.h>
#import "TorchController.h"

@interface TransmitViewController () <UITextFieldDelegate, TorchControllerDelegate>

@property (strong, nonatomic) TorchController *myTorchController;
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UIButton *transmitCancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *segueToReceiveModeButton;

@end

@implementation TransmitViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.myTorchController = [TorchController new];
    self.myTorchController.delegate = self;
    [self.transmitCancelButton addTarget:self action:@selector(transmit:) forControlEvents:UIControlEventTouchUpInside];
    [self.segueToReceiveModeButton setTintColor:[UIColor yellowColor]];
}

- (void)didReceiveMemoryWarning                                     // LOOK UP MORE
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];                               // this makes the Keyboard go away NOT SURE WHY
    return YES;
}

-(void)displayNewLetter:(NSString *)newLetter
{
    [ProgressHUD show:newLetter];
}

-(void)endOfDisplay
{
    [ProgressHUD dismiss];
    [self.transmitCancelButton removeTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.transmitCancelButton addTarget:self action:@selector(transmit:) forControlEvents:UIControlEventTouchUpInside];
    [self.transmitCancelButton setTitle:@"Transmit" forState:UIControlStateNormal];
    [self.transmitCancelButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    self.segueToReceiveModeButton.enabled = YES;
    [self.segueToReceiveModeButton setTintColor:[UIColor yellowColor]];

}

-(void)transmit:(id)sender
{
    
    [self.myTorchController convertToTorchSignalFromString:self.userTextField.text];
    [self.transmitCancelButton removeTarget:self action:@selector(transmit:) forControlEvents:UIControlEventTouchUpInside];
    [self.transmitCancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.transmitCancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.transmitCancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.segueToReceiveModeButton.enabled = NO;
    [self.segueToReceiveModeButton setTintColor:[UIColor grayColor]];
}

-(void)cancel:(id)sender
{
    [self.myTorchController cancelTransmittion];
    [ProgressHUD dismiss];
    [self.transmitCancelButton removeTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.transmitCancelButton addTarget:self action:@selector(transmit:) forControlEvents:UIControlEventTouchUpInside];
    [self.transmitCancelButton setTitle:@"Transmit" forState:UIControlStateNormal];
    [self.transmitCancelButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    self.segueToReceiveModeButton.enabled = YES;
    [self.segueToReceiveModeButton setTintColor:[UIColor yellowColor]];
}
@end
