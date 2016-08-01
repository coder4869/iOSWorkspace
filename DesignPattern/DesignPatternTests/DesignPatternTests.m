/*
  DesignPatternTests.m

  Created by coder4869 on 7/27/16.
  Copyright © 2016 coder4869. All rights reserved.
*/

#import <XCTest/XCTest.h>
#import "Test4DesignPattern.h"

@interface DesignPatternTests : XCTestCase

@end

@implementation DesignPatternTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    Test4DesignPattern * testInstance = [[Test4DesignPattern alloc] init];
    
    [testInstance test4SingletonDemo];
    [testInstance test4DelegateDemo];
    [testInstance test4KVC_KVODemo];
    [testInstance test4StrategyDemo]; 
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
