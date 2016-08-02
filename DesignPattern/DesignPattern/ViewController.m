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
    
    //singleton
    [self.testInstance test4SingletonDemo];
    
    //delegate
    [self.testInstance test4DelegateDemo];
    
    //KVC_KVO
    [self.testInstance test4KVC_KVODemo];

    //Strategy
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
