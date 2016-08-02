/*
  Consignor.m

  Created by coder4869 on 7/30/16.
  Copyright © 2016 coder4869. All rights reserved.
*/

#import "Consignor.h"

@implementation Consignor

//委托者方法
-(void)callConsignor
{
    NSLog(@"[Delegate] 我是委托者");

    [self.delegate requiredDelegateMethod];

    NSString* value = @"Optional Method!";
    if ([self.delegate respondsToSelector:@selector(optionalDelegateMethod:)]) {
        [self.delegate optionalDelegateMethod:value];  //代理属性调用协议方法
    }
}

@end
