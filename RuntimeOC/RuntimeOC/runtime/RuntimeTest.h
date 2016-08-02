/**
  RuntimeTest.h
    
  Created by coder4869 on 7/8/16.
  Copyright © 2016年 coder4869. All rights reserved.
**/

#import <Foundation/Foundation.h>

@interface RuntimeTest : NSObject

- (void) superAndself;

- (void) metaClassTest;

- (void) ex_registerClassPair;

void viewMetaClass(id self, SEL _cmd);

//- (void) assocateObject;

@end
