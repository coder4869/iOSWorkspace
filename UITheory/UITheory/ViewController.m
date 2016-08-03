/*
  ViewController.m

  Created by coder4869 on 8/1/16.
  Copyright © 2016 coder4869. All rights reserved.
*/

#import "ViewController.h"

#import "Test4UI.h"
#import "ViewProperty.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    Test4UI *testUI = [[Test4UI alloc] init];
    [testUI test4CGViewDIY:self.view];
    [testUI test4ViewProperty:self.view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
