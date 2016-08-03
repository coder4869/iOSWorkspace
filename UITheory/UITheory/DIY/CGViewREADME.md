6.	Core Graphics
6.1	Core Graphics上下文属性设置
    图形上下文的相关属性设置会决定绘图的行为与外观。绘图的一般过程为：先设定好图形上下文参数，然后绘图。例如：先画一根红线，接着画一根蓝线。绘制流程为：将上下文的线条颜色属性设定为为红色，然后画红线；接着设置上下文的线条颜色属性为蓝色，再画蓝线。画线时，线条颜色是整个上下文的属性。用UIKit方法或Core Graphics函数都一样。
    图形上下文在不同时刻的状态不一样，这些状态有专门的状态栈存储。状态入栈由函数CGContextSaveGState控制，查找栈订状态用CGContextRestoreGState函数。
一般绘图模式是：
    [1].在绘图之前调用CGContextSaveGState函数保存当前状态，
    [2].根据需要设置某些上下文状态，然后绘图。
    [3].最后调用CGContextRestoreGState函数将当前状态恢复到绘图之前的状态。
    CGContextSaveGState函数和CGContextRestoreGState函数必须成对出现，否则会出现奇怪的异常。示例代码如下：
    - (void)drawRect:(CGRect)rect {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSaveGState(ctx);
        {
            // 绘图代码
        }
        CGContextRestoreGState(ctx);
    }
    并非每次修改上下文状态之前都这样做，因为上下文属性的设置未必会跟之前有冲突。可以在不调用保存和恢复函数的情况下先设置线条颜色为红色，然后再设置为蓝色。若要使状态的设置可撤销，参见后续示例。
常用属性和对应修改函数如下（与Core Graphics一样， UIKit也通过这些函数操纵上下文状态）：
    [1].线条的宽度和线条的虚线样式：CGContextSetLineWidth、CGContextSetLineDash
    [2].线帽和线条联接点样式：CGContextSetLineCap、CGContextSetLineJoin、CGContextSetMiterLimit
    [3].线条颜色和线条模式CGContextSetRGBStrokeColor、CGContextSetGrayStrokeColor、CGContextSetStrokeColorWithColor、CGContextSetStrokePattern
    [4].填充颜色和模式：CGContextSetFillColorWithColor，CGContextSetRGBFillColor，CGContextSetGrayFillColor，CGContextSetFillPattern
    [5].阴影：CGContextSetShadow、CGContextSetShadowWithColor
    [6].混合模式：CGContextSetBlendMode（决定当前绘制的图形与已经存在的图形如何被合成）
    [7].整体透明度：CGContextSetAlpha（个别颜色也具有alpha成分）
    [8].文本属性：CGContextSetTextDrawingMode、CGContextSetCharacterSpacing 、CGContextSelectFont、CGContextSetFont、CGContextSetFontSize
    [9].反锯齿和字体平滑设置：CGContextSetShouldAntialias、CGContextSetShouldSmoothFonts
    [10].裁剪区域：在裁剪区域外绘图不会被实际的画出来。
    [11].变换（或称为“CTM“，意为当前变换矩阵）：改变随后指定的绘图命令中的点如何被映射到画布的物理空间。
6.2	路径与绘图
    通过编写移动虚拟画笔的代码描画一段路径，这样的路径并不构成一个图形。绘制路径意味着对路径描边或填充该路径，也或者两者都做。常用路径描画命令：
    [1].定位当前点：CGContextMoveToPoint
    [2].描画一条线：CGContextAddLineToPoint、CGContextAddLines
    [3].描画一个矩形：CGContextAddRect、CGContextAddRects
    [4].描画一个椭圆或圆形：CGContextAddEllipseInRect
    [5].描画一段圆弧：CGContextAddArcToPoint、CGContextAddArc
    [6].通过一到两个控制点描画一段贝赛尔曲线：CGContextAddQuadCurveToPoint、CGContextAddCurveToPoint
    [7].关闭当前路径：CGContextClosePath 这将从路径的终点到起点追加一条线。若要填充一段路径，就不需要使用该命令，因为该命令会被自动调用。
    [8].描边或填充当前路径CGContextStrokePath、CGContextFillPath、CGContextEOFillPath、CGContextDrawPath。对当前路径描边或填充会清除掉路径。要用一条命令完成描边和填充任务，可以使用CGContextDrawPath命令。如果只用CGContextStrokePath对路径描边，路径就会被清除掉，就不能再对它进行填充了。
    [9].用一条命令可以创建路径并描边路径或填充路径的函数：CGContextStrokeLineSegments、CGContextStrokeRect、CGContextStrokeRectWithWidth、CGContextFillRect、CGContextFillRects、CGContextStrokeEllipseInRect、CGContextFillEllipseInRect。
    [10].并非每条独立路径都要用CGContextBeginPath函数指定
    [11].CGContextClearRect函数的功能是擦除一个区域（矩形内的所有已存在的绘图；并对该区域执行裁剪）。结果像是打了一个贯穿所有已存在绘图的孔。其行为依赖于上下文是透明与否。如果图片上下文是透明的（UIGraphicsBeginImageContextWithOptions第二个参数为NO），那么CGContextClearRect函数执行擦除后的颜色为透明，反之则为黑色。
    [12].当在一个视图中直接绘图（使用drawRect：或drawLayer：inContext：方法），如果视图的背景颜色为nil或颜色哪怕有一点点透明度，那么CGContextClearRect的矩形区域将会显示为透明的，打出的孔将穿过视图包括它的背景颜色。如果背景颜色完全不透明，那么CGContextClearRect函数的结果将会是黑色。这是因为视图的背景颜色决定了是否视图的图形上下文是透明的还是不透明的。
