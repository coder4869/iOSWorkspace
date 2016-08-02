/*
  Singleton.h

  Created by coder4869 on 7/30/16.
  Copyright © 2016 coder4869. All rights reserved.
*/

#import <Foundation/Foundation.h>

@interface Singleton : NSObject

@property(nonatomic, strong) NSString * demoVar;

+(Singleton*)sharedInstance;

@end
