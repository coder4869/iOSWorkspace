/*
  ValidatorInterface.h
 
  Created by coder4869 on 7/27/16.
  Copyright © 2016 coder4869. All rights reserved.
*/

#import <Foundation/Foundation.h>

@protocol ValidatorInterface <NSObject>
-(BOOL) validateInput:(NSString*)input error:(NSError**)error;
@end
