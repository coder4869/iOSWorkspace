/*
  ProxyObject.h

  Created by coder4869 on 7/30/16.
  Copyright © 2016 coder4869. All rights reserved.
*/

#import <Foundation/Foundation.h>
#import "DemoDelegate.h"

@interface ProxyObject : NSObject <DemoDelegate> {  //代理对象,设置代理对象的代理资格
    NSString *value;
}

//代理对象方法
- (void)callProxy;

@end
