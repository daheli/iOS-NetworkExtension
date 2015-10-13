//
//  ViewController.m
//  ExperimentVPN
//
//  Created by lidahe on 15/10/8.
//  Copyright © 2015年 lidahe. All rights reserved.
//

#import "ViewController.h"
#import "AddEditConfiguration.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startButtonClicked:(id)sender {
    NSLog(@"test");
    [[AddEditConfiguration sharedInstance] start];
    
}

- (IBAction)closeButtonClicked:(id)sender {
    [[AddEditConfiguration sharedInstance] loadProfile];
}

- (IBAction)stopButtonClicked:(id)sender {
    [[AddEditConfiguration sharedInstance] stop];
}
- (IBAction)checkButtonClicked:(id)sender {
    [[AddEditConfiguration sharedInstance] check];
}

@end
