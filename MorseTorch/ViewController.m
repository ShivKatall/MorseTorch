//
//  ViewController.m
//  MorseTorch
//
//  Created by Cole Bratcher on 4/14/14.
//  Copyright (c) 2014 Cole Bratcher. All rights reserved.
//

#import "ViewController.h"
#import "NSString+MorseCode.h"
#import <AVFoundation/AVFoundation.h>
#import "TorchController.h"

@interface ViewController () <UITextFieldDelegate, TorchControllerDelegate>

@property (strong, nonatomic) TorchController *myTorchController;
@property (weak, nonatomic) IBOutlet UITextField *userTextField;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
        self.myTorchController = [TorchController new];
        self.myTorchController.delegate = self;
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
}

- (IBAction)transmit:(id)sender
{
    [self.myTorchController convertToTorchSignalFromString:self.userTextField.text];
}

@end
