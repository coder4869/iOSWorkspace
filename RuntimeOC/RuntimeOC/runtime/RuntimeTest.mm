/**
  RuntimeTest.m

  Created by coder4869 on 7/8/16.
  Copyright © 2016年 coder4869. All rights reserved.
**/

#import "RuntimeTest.h"

#import "RuntimeBase.h"
#import <objc/runtime.h>

@implementation RuntimeTest

-(void) superAndself {
    NSLog(@"self=%@", NSStringFromClass([self class]));
    NSLog(@"super=%@", NSStringFromClass([super class]));
}

-(void) metaClassTest {
    BOOL res1 = [(id)[NSObject class] isKindOfClass:[NSObject class]];
    BOOL res2 = [(id)[NSObject class] isMemberOfClass:[NSObject class]];
    BOOL res3 = [(id)[self class] isKindOfClass:[self class]];
    BOOL res4 = [(id)[self class] isMemberOfClass:[self class]];
    NSLog(@"%d %d %d %d", res1, res2, res3, res4);
}


- (void)ex_registerClassPair {
    
    Class newClass = objc_allocateClassPair([NSError class], "TestClass", 0);
    class_addMethod(newClass, @selector(testMetaClass), (IMP)viewMetaClass, "v@:");
    objc_registerClassPair(newClass);
    
    printIvarList(newClass);
    printPropertyList(newClass);
    printMethodList(newClass);

    id instance = [[newClass alloc] initWithDomain:@"some domain" code:0 userInfo:nil];
    [instance performSelector:@selector(testMetaClass)];
}

void viewMetaClass(id self, SEL _cmd) {
    
    NSLog(@"This objcet is %p", self);
    NSLog(@"Class is %@, super class is %@", [self class], [self superclass]);
    
    Class currentClass = [self class];
    for (int i = 0; i < 4; i++) {
        NSLog(@"Following the isa pointer %d times gives %p", i, currentClass);
        currentClass = objc_getClass([NSStringFromClass(currentClass) UTF8String]);
        //        currentClass = objc_getClass((__bridge void *)currentClass);
    }
    
    NSLog(@"NSObject's class is %p", [NSObject class]);
    NSLog(@"NSObject's meta class is %p", objc_getClass([NSStringFromClass([NSObject class]) UTF8String]));
    //    NSLog(@"NSObject's meta class is %p", objc_getClass((__bridge void *)[NSObject class]));
}

-(void) testMetaClass {
    
}

@end
