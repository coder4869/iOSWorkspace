/*
  CGViewDIY.m

  Created by coder4869 on 8/3/16.
  Copyright © 2016 coder4869. All rights reserved.
*/

#import "CGViewDIY.h"

@implementation CGViewDIY

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextSaveGState(con);

    // 从箭头杆子上裁掉一个三角形，使用清除混合模式
    CGContextMoveToPoint(con, 45, 100);
    CGContextAddLineToPoint(con, 50, 90);
    CGContextAddLineToPoint(con, 55, 100);
    CGContextClosePath(con);
    CGContextAddRect(con, CGContextGetClipBoundingBox(con));
    // 使用奇偶规则，裁剪区域为矩形减去三角形区域
    CGContextEOClip(con);
    
    // 绘制一个黑色的垂直黑色线，作为箭头的杆子
    CGContextMoveToPoint(con, 50, 100);
    CGContextAddLineToPoint(con, 50, 20);
    CGContextSetLineWidth(con, 10);
    CGContextStrokePath(con);
    
    // 使用路径的描边版本替换图形上下文的路径
    CGContextReplacePathWithStrokedPath(con);
    
    // 对路径的描边版本实施裁剪
    CGContextClip(con);
    // 绘制渐变
    CGFloat locs[3] = { 0.0, 0.5, 1.0 };
    CGFloat colors[12] = {
        0.3,0.3,0.3,0.8, // 开始颜色，透明灰
        0.0,0.0,0.0,1.0, // 中间颜色，黑色
        0.3,0.3,0.3,0.8 // 末尾颜色，透明灰
    };
    CGColorSpaceRef sp = CGColorSpaceCreateDeviceGray();
    CGGradientRef grad = CGGradientCreateWithColorComponents (sp, colors, locs, 3);
    CGContextDrawLinearGradient(con, grad, CGPointMake(89,0), CGPointMake(111,0), 0);
    CGColorSpaceRelease(sp);
    CGGradientRelease(grad);
    CGContextRestoreGState(con); // 完成裁剪
    
    // 绘制一个红色三角形箭头
    CGContextSetFillColorWithColor(con, [[UIColor redColor] CGColor]);
    CGContextMoveToPoint(con, 30, 20);
    CGContextAddLineToPoint(con, 50, 0);
    CGContextAddLineToPoint(con, 70, 20);
    CGContextFillPath(con);
    
    //绘制左上和右下为圆角的矩形
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(ctx, 3);
    UIBezierPath *path;
    path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(20, 110, 80, 70) byRoundingCorners:(UIRectCornerTopLeft |UIRectCornerTopRight)cornerRadii:CGSizeMake(10, 10)];
    [path stroke];
}

@end
