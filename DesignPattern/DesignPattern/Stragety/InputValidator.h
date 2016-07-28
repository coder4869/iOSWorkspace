/*
  InputValidator.h
 
  Created by coder4869 on 7/27/16.
  Copyright © 2016 coder4869. All rights reserved.
*/

#import <Foundation/Foundation.h>
#import "ValidatorInterface.h"

@interface InputValidator : NSObject
{
@public
    id< ValidatorInterface> validator;
}
-(void)setValidator:(id<ValidatorInterface >)myValidator;
-(BOOL) validateInput:(id)input error:(NSError**)error;

@end
