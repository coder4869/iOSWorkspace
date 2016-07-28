/*
  Test4DesignPattern.m

  Created by coder4869 on 7/27/16.
  Copyright © 2016 coder4869. All rights reserved.
*/

#import "Test4DesignPattern.h"

#import "InputValidator.h"
#import "EmailValidator.h"
#import "PhoneValidator.h"

@implementation Test4DesignPattern

//策略模式调用案例
- (void) test4StrategyDemo {
    InputValidator * IV = [[InputValidator alloc] init];
    [IV setValidator:[[EmailValidator alloc] init]];
    [IV validateInput:nil error:nil];
    [IV setValidator:[[PhoneValidator alloc] init]];
    [IV validateInput:nil error:nil];
}

@end
