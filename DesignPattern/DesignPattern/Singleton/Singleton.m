/*
  Singleton.m

  Created by coder4869 on 7/30/16.
  Copyright © 2016 coder4869. All rights reserved.
*/

#import "Singleton.h"

@implementation Singleton

+(Singleton*)sharedInstance {
    
    static Singleton *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Singleton alloc] init];
        NSLog(@"[Singleton] initialize succeed!");
    });
    return instance;
}


#pragma mark - setter and getter
-(void)setDemoVar:(NSString *)demoVar {
    
    NSLog(@"[Singleton] Setting property's value!");

    _demoVar = demoVar;
}


@end
