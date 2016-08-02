/*
  ViewProperty.m

  Created by coder4869 on 8/1/16.
  Copyright © 2016 coder4869. All rights reserved.
*/

#import "ViewProperty.h"
#import "ViewLayer.h"

@implementation ViewProperty

/*
 clipsTobounds：为YES时隐藏子View超出View自身Frame的界面部分。(default为NO)
 Frame：该view在父view坐标系统中的位置和大小。
 Bounds：该view在本地坐标系统中的位置和大小。（相对于自身的坐标系统，以(0,0)点为起点）
 center：该view的中心点在父view坐标系统中的位置和大小。
 view的Frame、Bounds、Center属性是简单的返回Layer的对应属性。
 */
-(void)demo4FrameBoundsCenter:(BOOL) clipsToBounds {
    
    self.backgroundColor = [UIColor redColor];
    self.clipsToBounds = clipsToBounds;
    
    NSLog(@"创建View流程");
    SubView *boundsV = [[SubView alloc] initWithFrame:CGRectMake(30, 30, 100, 100)];
    NSLog(@"修改View的Bounds");
    /*
     强制将自身坐标系原点坐标改为(-10,-10), 同时修改view的宽度和高度, view的创建流程可以解释此问题。
     修改view的bounds，会调用Layer的bounds设置方法，本质上修改的是Layer层属性。
     */
    [boundsV setBounds:CGRectMake(-10, -10, 150, 150)];
    [boundsV setBackgroundColor:[UIColor lightGrayColor]];
    [boundsV setClipsToBounds:clipsToBounds];
    [self addSubview:boundsV];
    NSLog(@"\n====view1 frame:%@\n====view1 bounds:%@\n====view1 center=%@", NSStringFromCGRect(boundsV.frame), NSStringFromCGRect(boundsV.bounds), NSStringFromCGPoint(boundsV.center));
    
    UIView *frameV = [[UIView alloc] initWithFrame:CGRectMake(-20, 0, 80, 80)];
    [frameV setBackgroundColor:[UIColor grayColor]];
    [boundsV addSubview:frameV];
    NSLog(@"\n====view2 frame:%@\n====view2 bounds:%@\n====view2 center=%@", NSStringFromCGRect(frameV.frame), NSStringFromCGRect(frameV.bounds), NSStringFromCGPoint(frameV.center));

}

@end
