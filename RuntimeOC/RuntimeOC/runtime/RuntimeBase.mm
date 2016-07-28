/**
  RuntimeBase.m

  Created by coder4869 on 7/7/16.
  Copyright © 2016年 coder4869. All rights reserved.
**/

#import "RuntimeBase.h"

#import <objc/runtime.h>
#import <Foundation/Foundation.h>

void printIvarList(Class cls) {
    
    printf("Current class is %s:\n", [NSStringFromClass(cls) UTF8String]);

    unsigned int varCount;
    Ivar *vars = class_copyIvarList(cls, &varCount);
   
    for(int ind=0; ind<varCount; ind++) {
        const char * name = ivar_getName(vars[ind]);
        const char * type = ivar_getTypeEncoding(vars[ind]);
        printf("var[%d]=%s\t\tType=%s\n", ind, name, type);
    }
    free(vars);
}


void printPropertyList(Class cls) {
    
    printf("Current class is %s:\n", [NSStringFromClass(cls) UTF8String]);
    
    unsigned int proCount;
    objc_property_t * properties = class_copyPropertyList(cls, &proCount);
    
    for(int ind=0; ind<proCount; ind++) {
        const char * proName = property_getName(properties[ind]);
        const char * proAttr = property_getAttributes(properties[ind]);
        printf("property[%d]=%s\t\tAttribute=%s\n", ind, proName, proAttr);
    }
    free(properties);
}


void printMethodList(Class cls) {
    
    printf("Current class is %s:\n", [NSStringFromClass(cls) UTF8String]);
    
    unsigned int methodCount;
    Method * methods = class_copyMethodList(cls, &methodCount);
    
    for (int ind=0; ind<methodCount; ind++) {
        SEL sel = method_getName(methods[ind]);
        const char *sel_name = sel_getName(sel);
        printf("method[%d]=%s\n", ind, sel_name);
    }
    free(methods);
}


