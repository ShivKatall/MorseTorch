//
//  ViewController.m
//  MorseTorch
//
//  Created by Cole Bratcher on 4/14/14.
//  Copyright (c) 2014 Cole Bratcher. All rights reserved.
//

#import "ViewController.h"
#import "NSString+MorseCode.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userString;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *myString = @"SOS";
    
    NSMutableArray *myArray = [myString flashArrayFromString];
    
    NSLog(@"%@", myArray);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)transmit:(id)sender {
    
}

@end
