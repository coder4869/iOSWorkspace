/**
  RuntimeOCTests.m

  Created by coder4869 on 7/1/16.
  Copyright © 2016 coder4869. All rights reserved.
**/

#import <XCTest/XCTest.h>

#import "RuntimeBase.h"
#import "RuntimeTest.h"

@interface RuntimeOCTests : XCTestCase

@end

@implementation RuntimeOCTests

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
    
    printIvarList([self superclass]);
    printPropertyList([self superclass]);
    printMethodList([self superclass]);
    
    
    RuntimeTest *runTest = [[RuntimeTest alloc] init];
    [runTest superAndself];
    [runTest metaClassTest];
    [runTest ex_registerClassPair];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
