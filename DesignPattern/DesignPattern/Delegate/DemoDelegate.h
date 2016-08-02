/*
  DemoDelegate.h

  Created by coder4869 on 7/30/16.
  Copyright © 2016 coder4869. All rights reserved.
*/

#import <Foundation/Foundation.h>

@protocol DemoDelegate <NSObject> //协议

@required
- (void) requiredDelegateMethod; //无参数的协议方法

@optional
- (void) optionalDelegateMethod: (NSString*)fromValue; //含一个参数的协议方法

@end
