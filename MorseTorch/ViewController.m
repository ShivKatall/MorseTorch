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

@interface ViewController () <UITextFieldDelegate>


@property (strong, nonatomic) TorchController *myTorchController;
@property (weak, nonatomic) IBOutlet UITextField *userTextField;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
        self.myTorchController = [TorchController new];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)transmit:(id)sender
{
    [self.myTorchController convertMorseFromString:self.userTextField.text];
}

@end
