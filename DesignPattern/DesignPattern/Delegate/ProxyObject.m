/*
  ProxyObject.m

  Created by coder4869 on 7/30/16.
  Copyright © 2016 coder4869. All rights reserved.
*/

#import "ProxyObject.h"
#import "Consignor.h"

@implementation ProxyObject

//代理对象方法
- (void)callProxy {
    Consignor *C = [[Consignor alloc] init];
    C.delegate = self;
    [C callConsignor];
}


#pragma mark - 实现协议方法
#pragma mark - DemoDelegate method

-(void)requiredDelegateMethod {
    NSLog(@"[Delegate] 我是代理人\nRequired Method!");
}

//此方法可以注释掉,因为此方法为可选方法
- (void) optionalDelegateMethod: (NSString*)fromValue
{
    value = fromValue;
    NSLog(@"[Delegate] 我是代理人\n%@", value);
}

@end
