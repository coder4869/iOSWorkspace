/*
  ViewProperty.h

  Created by coder4869 on 8/1/16.
  Copyright © 2016 coder4869. All rights reserved.
*/

#import <UIKit/UIKit.h>

@interface ViewProperty : UIView

/*
 clipsTobounds：为YES时隐藏子View超出View自身Frame的界面部分。(default为NO)
 Frame：该view在父view坐标系统中的位置和大小。
 Bounds：该view在本地坐标系统中的位置和大小。（相对于自身的坐标系统，以(0,0)点为起点）
 center：该view的中心点在父view坐标系统中的位置和大小。
 view的Frame、Bounds、Center属性是简单的返回Layer的对应属性。
 */
-(void)demo4FrameBoundsCenter:(BOOL) clipsToBounds;

@end
