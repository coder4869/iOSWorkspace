/*
  Test4UI.m

  Created by coder4869 on 8/3/16.
  Copyright © 2016 coder4869. All rights reserved.
*/

#import "Test4UI.h"

#import "CGViewDIY.h"
#import "ViewProperty.h"

@implementation Test4UI

-(void)test4CGViewDIY:(UIView*)parent {
    CGViewDIY * diy = [[CGViewDIY alloc] initWithFrame:CGRectMake(0, 70, 120, 200)];
    [diy setBackgroundColor:[UIColor whiteColor]];
    [parent addSubview:diy];
}

-(void)test4ViewProperty:(UIView*)parent {
    ViewProperty *vp = [[ViewProperty alloc] initWithFrame:CGRectMake(120, 70, 200, 200)];
    [vp demo4FrameBoundsCenter:NO]; //参数为是否隐藏超出边界的子视图
    [parent addSubview:vp];
}

@end
