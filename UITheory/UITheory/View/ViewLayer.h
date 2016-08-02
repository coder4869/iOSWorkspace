/*
  ViewLayer.h
 
  本类用于帮助理解view和layer的一些关系, 调用案例参见ViewProperty的-(void)demo4FrameBoundsCenter:(BOOL) clipsToBounds方法, View的创建流程如下:
    [UIView initWithFrame:]
    [UIView _createLayerWithFrame:]  //私有方法
    Create View Layer
    Layer init
    Set Layer Bounds
    Set View Frame
    Set Layer Frame
    Set Layer Position
    Set Layer Bounds
    View init finish
 
  Created by coder4869 on 8/2/16.
  Copyright © 2016 coder4869. All rights reserved.
*/

#import <UIKit/UIKit.h>

@interface SubView : UIView

@end


@interface SubLayer: CALayer

@end