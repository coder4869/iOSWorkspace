/*
  Test4DesignPattern.m

  Created by coder4869 on 7/27/16.
  Copyright © 2016 coder4869. All rights reserved.
*/

#import "Test4DesignPattern.h"

//singleton
#import "Singleton.h"

//delegate
#import "ProxyObject.h"

//KVC&KVO
#import "Person.h"

//strategy
#import "InputValidator.h"
#import "EmailValidator.h"
#import "PhoneValidator.h"

@implementation Test4DesignPattern

//单例模式调用案例
- (void) test4SingletonDemo {
    [[Singleton sharedInstance] setDemoVar:@"Singleton call demo"];
}

//代理模式调用案例
- (void) test4DelegateDemo {
    [[ProxyObject alloc] callProxy];
}

//KVC&KVO调用案例
- (void) test4KVC_KVODemo {
    Person *p = [[Person alloc] init];
    [p changeName:@"(this is new name)"];
    [p setAddress:@"(setting address)"];
    [p setKVOTestProperty:@"KVOTestProperty"];
    
    Person *sp = [[Person alloc] init]; //配偶
    sp.name = @"sopuse";
    p.spouse = sp;
    
    [p logMarriage];
}

//策略模式调用案例
- (void) test4StrategyDemo {
    InputValidator * IV = [[InputValidator alloc] init];
    [IV setValidator:[[EmailValidator alloc] init]];
    [IV validateInput:nil error:nil];
    [IV setValidator:[[PhoneValidator alloc] init]];
    [IV validateInput:nil error:nil];
}

@end
