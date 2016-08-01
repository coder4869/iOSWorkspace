/*
  Person.m
  
  KVC分析:
    Person 对象分别有一个 value 对应他的 name 和 address 的 key。 
    key 只是一个字符串, 它对应的值可以是任意类型的对象。
    从最基础的层次上看, KVC 有两个方法: 一个是设置 key 的值, 另一个是获取 key 的值。
 
  KVO分析:
    用代码观察一个 person 对象的 address 变化，以下是实现的三个方法：
    [1].watchChangeForAddress: 实现观察
    [2].observeValueForKeyPath:ofObject:change:context: 在被观察的 key path 的值变化时调用。
    [3].dealloc 停止观察
 
  Created by coder4869 on 7/30/16.
  Copyright © 2016 coder4869. All rights reserved.
*/

#import "Person.h"

@implementation Person

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self watchChangeForAddress];
//        []
    }
    return self;
}

#pragma mark - KVC
/*
    如果有访问器方法，则运行时会在访问器方法中调用will/didChangeValueForKey:方法；
    没用访问器方法，运行时会在setValue:forKey方法中调用will/didChangeValueForKey:方法。
 */

- (void) changeName:(NSString*)newName {
    // using KVC accessor (getter) method
    NSString *originalName = [self valueForKey:@"name"];
    
    // using KVC accessor (setter) method.
    [self setValue:newName forKey:@"name"];
    
    NSLog(@"[KVC] Changed %@'s name to: %@", originalName, newName);
}

/*
 key 与 key path 要区分开来，key 可以从一个对象中获取值,
 而 key path 可以将多个 key 用点号 “.” 分割连接起来
 */
- (void) logMarriage {
    // just using the accessor again, same as example above
    NSString *personsName = [self valueForKey:@"name"];
    
    // using "key path" get value of spouse's name property
    NSString *spousesName = [self valueForKeyPath:@"spouse.name"];
    // using normal "key" get value of spouse's name property
    NSString *spousesName2 = [[self valueForKey:@"spouse"] valueForKey:@"name"];

    NSLog(@"[KVC] %@ is happily married to %@(way 2:%@)", personsName, spousesName, spousesName2);
}


#pragma mark - KVO

static NSString *const KVO_CONTEXT_ADDRESS_CHANGED = @"KVO_CONTEXT_ADDRESS_CHANGED";

-(void) watchChangeForAddress
{
    // this begins the observing, remember to stop observing in dealloc method
    
    [self addObserver:self
           forKeyPath:@"name"
              options:0
              context:(__bridge void * _Nullable)(KVO_CONTEXT_ADDRESS_CHANGED)];
    
    [self addObserver:self
        forKeyPath:@"address"
           options:0
           context:(__bridge void * _Nullable)(KVO_CONTEXT_ADDRESS_CHANGED)];
    
    [self addObserver:self
           forKeyPath:@"KVOTestProperty"
              options:0
              context:(__bridge void * _Nullable)(KVO_CONTEXT_ADDRESS_CHANGED)];
}

// whenever an observed key path changes, this method will be called
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    // use the context to make sure this is a change in the address,
    // because we may also be observing other things
    if(context == (__bridge void * _Nullable)(KVO_CONTEXT_ADDRESS_CHANGED)) {
        NSString *name = [object valueForKey:@"name"];
        NSString *address = [object valueForKey:@"address"];
        NSLog(@"[KVC] %@‘s new address: %@", name, address);
    }
}

// must stop observing everything before this object is deallocated to avoid crashes
-(void) dealloc;
{
    [self removeObserver:self forKeyPath:@"name"];
    [self removeObserver:self forKeyPath:@"address"];
    [self removeObserver:self forKeyPath:@"KVOTestProperty"];
}


#pragma mark - override parents' methods (value change called methods)

- (void) willChangeValueForKey:(NSString *)key {
    
    if ([key isEqualToString:@"name"]) {
        NSLog(@"[KVO] name will change!");
    } else if([key isEqualToString:@"address"]) {
        NSLog(@"[KVO] address will change!");
    } else if([key isEqualToString:@"spouse"]) {
        NSLog(@"[KVO] spouse will change!");
    } else {
        NSLog(@"[KVO] unknown property value will change value!");
    }
}

- (void) didChangeValueForKey:(NSString *)key {
    
    if ([key isEqualToString:@"name"]) {
        NSLog(@"[KVO] name changed!");
    } else if([key isEqualToString:@"address"]) {
        NSLog(@"[KVO] address changed!");
    } else if([key isEqualToString:@"spouse"]) {
        NSLog(@"[KVO] spouse changed!");
    } else {
        NSLog(@"[KVO] unknown property changed value!");
    }
}

@end
