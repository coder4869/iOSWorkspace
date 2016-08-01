/*
  Consignor.h

  Created by authen on 7/30/16.
  Copyright © 2016 coder4869. All rights reserved.
*/

#import <Foundation/Foundation.h>
#import "DemoDelegate.h"

@interface Consignor : NSObject//协议委托者

@property(nonatomic, weak) id <DemoDelegate> delegate; //代理属性

//委托者方法
-(void)callConsignor;

@end
