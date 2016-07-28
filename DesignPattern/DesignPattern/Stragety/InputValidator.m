/*
  InputValidator.m
  
  Created by coder4869 on 7/27/16.
  Copyright © 2016 coder4869. All rights reserved.
*/

#import "InputValidator.h"

@implementation InputValidator

-(void)setValidator:(id<ValidatorInterface >)myValidator {
    validator = myValidator;
}
-(BOOL) validateInput:(id)input error:(NSError**)error {
    NSLog(@"Input Validator callled");
    [validator validateInput:input error:nil];
    return true;
}

@end
