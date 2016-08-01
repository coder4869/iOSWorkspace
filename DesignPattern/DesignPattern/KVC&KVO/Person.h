/*
  Person.h

  Created by coder4869 on 7/30/16.
  Copyright © 2016 coder4869. All rights reserved.
*/

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *address;
@property(nonatomic, strong) Person *spouse; //配偶

@property(nonatomic, strong) NSString *KVOTestProperty; //测试KVO专用

#pragma mark - KVC
- (void) changeName:(NSString*)newName;
- (void) logMarriage;


#pragma mark - KVO
-(void) watchChangeForAddress;

@end
