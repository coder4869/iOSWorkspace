/*
  ViewController.m

  Created by coder4869 on 7/27/16.
  Copyright © 2016 coder4869. All rights reserved.
*/

#import "ViewController.h"
#import "Test4DesignPattern.h"

@interface ViewController ()
@property(nonatomic, strong) Test4DesignPattern *testInstance;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //策略模式运行
    [self.testInstance test4StrategyDemo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setter and getter

- (Test4DesignPattern*) testInstance {
    if (!_testInstance) {
        _testInstance = [[Test4DesignPattern alloc] init];
    }
    return _testInstance;
}

@end
