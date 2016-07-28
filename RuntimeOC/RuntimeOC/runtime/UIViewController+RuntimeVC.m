/**
  UIViewController+RuntimeVC.m
 
  Created by coder4869 on 7/15/16.
  Copyright © 2016 coder4869. All rights reserved.
**/

#import "UIViewController+RuntimeVC.h"

#import <objc/runtime.h>

@implementation UIViewController (RuntimeVC)

//method load will be called at the first time loading
//this method's called time is early, fitting for making methods exchange here
+ (void)load{
    //method exchange action should be ensure just run once
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL systemSel = @selector(viewWillAppear:); //get system selector to be exchanged
        SEL swizzSel = @selector(swiz_viewWillAppear:); //get self-defined selector used for exchanging
        
        //get method of the above two selectors
        Method systemMethod = class_getInstanceMethod([self class], systemSel);
        Method swizzMethod = class_getInstanceMethod([self class], swizzSel);
        
        //首先动态添加方法，实现是被交换的方法，返回值表示添加成功还是失败
        BOOL isAdd = class_addMethod(self, systemSel, method_getImplementation(swizzMethod), method_getTypeEncoding(swizzMethod));
        if (isAdd) { //adding method succeed, which means the method implementation doesn't exist in the class, make replacement
            class_replaceMethod(self, swizzSel, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
        } else { //exchange the two method's implementation
            method_exchangeImplementations(systemMethod, swizzMethod);
        }
    });
}

- (void)swiz_viewWillAppear:(BOOL)animated {
    //这时候调用自己，看起来像是死循环
    //但是其实自己的实现已经被替换了
    [self swiz_viewWillAppear:animated];
    NSLog(@"swizzle");
}

@end
