2.1	UIView属性
    [1].clipsTobounds
        为YES时隐藏子View超出View自身Frame的界面部分。(default为NO)
    [2].Frame
        该view在父view坐标系统中的位置和大小。
    [3].Bounds
        该view在本地坐标系统中的位置和大小。（相对于自身的坐标系统，以(0,0)点为起点）可以修改原点坐标和view的frame大小。View的创建流程可以解析这一现象。
    [4].center
        该view的中心点在父view坐标系统(即父view的bounds坐标系)中的位置和大小。
    [5].autoresizingMask
        重置视图尺寸大小。场景：手机方向改变、用setNeedsDisplay重布局等。
    注：view的Frame、Bounds、Center属性是简单的返回Layer的对应属性，center返回的是position的位置。
2.2	UIView作用
    [1].Drawing and animation
        使用UIKit、Core Graphics、and OpenGL ES等技术在矩形框内绘制文本内容 
        Some view properties can be animated to new values.
    [2].Layout和subview管理
        每个View根据父View定义自身的默认resizing行为。View可以根据需要定义子视图的size和position。
    [3].事件处理
        View是个响应器，可以处理触摸事件和UIResponder 定义的其他事件。可以用addGestureRecognizer:方法添加手势处理。
2.3	UIView与CALayer
2.3.1事件响应
    首先UIView可以响应事件，Layer不可以。
    UIKit使用UIResponder作为响应对象，来响应系统传递过来的事件并进行处理。UIApplication、UIViewController、UIView、和所有从UIView派生出来的UIKit类（包括UIWindow）都直接或间接地继承自UIResponder类。
    在 UIResponder中定义了处理各种事件和事件传递的接口, 而 CALayer直接继承 NSObject，并没有相应的处理事件的接口。
    UIView可以响应的事件种类很多，比如触摸事件、运动和远程控制事件等等。其中，处理触摸事件的部分接口如下：
        – touchesBegan:withEvent:
        – touchesMoved:withEvent:
        – touchesEnded:withEvent:
        – touchesCancelled:withEvent:
    关于 iOS 事件的处理和传递，可以参考下面链接：
    http://blog.csdn.net/chun799/article/details/8223612
    http://yishuiliunian.gitbooks.io/implementate-tableview-to-understand-ios/content/uikit/1-1-2.html
2.3.2UIView创建流程(基于Layer)
    UIView的创建流程如下(验证参见demo的ViewLayer类)：
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
    创建view的过程中并未设置view的bounds和Center。修改view的bounds，会调用Layer的bounds设置方法，本质上修改的是Layer层属性。
    CALayer除bounds和frame外，还有position和anchorPoint两个属性。position是layer中的anchorPoint点在superLayer中的位置坐标。anchorPoint决定CALayer上的哪个点对应position属性所指的位置。anchorPoint的左上角为 (0, 0)，右下角为(1, 1)，即0～1坐标系。
2.3.3UIView侧重内容管理，CALayer侧重绘制
    重写UIView的drawRect:(CGRect)方法和CALayer的display方法，为这2个方法加断点(ViewLayer文件)
    可以发现如下几个内容：
    [1].首先绘制Layer层，调用Layer层的展示方法，
    [2].之后Layer的展示方法调用UIView的drawLayer:inContext:
    [3].有drawLayer:inContext:方法为UIView的CALayerDelegate分类中的方法，此方法调用了UIView的drawRect方法，从而绘制出了UIView的内容。
    当 layer 在背后支持一个 view 的时候，view 就是它的 delegate。因此，UIView（的分类CALayerDelegate）可以看作是CALayer的delegate。
2.3.4修改非 RootLayer属性会默认产生隐式动画，修改UIView不会
    UIView自带的默认layer称为RootLayer，其他的Layer称为非RootLayer。对UIView的属性修改时时不会产生默认动画，而对非RootLayer的属性（譬如位置、背景色等）直接修改会，此默认动画的时间缺省值是0.25s。
    在Core Animation编程指南的“How to Animate Layer-Backed Views”中，对此有如下解释：
    UIView默认禁止了layer动画，但在animation block中重新启用了动画。是因为任何可动画的 layer 属性改变时，layer都会寻找并运行合适的 'action' 来实行这个改变。在Core Animation 的专业术语中就把这样的动画统称为动作(action，或者 CAAction)。
    layer 通过向它的 delegate 发送 actionForLayer:forKey: 消息来询问提供一个对应属性变化的action。delegate可以通过返回以下三者之一来进行响应：
    [1].返回一个动作对象，layer将使用这个动作。
    [2].返回一个 nil，layer就会到其他地方继续寻找。
    [3].返回一个NSNull对象，告诉layer这里不需要执行一个动作，搜索也会就此停止。
2.3.5总结
    每个 UIView 内部都有一个 CALayer 在背后提供内容的绘制和显示，并且 UIView 的尺寸样式都由内部的 Layer 所提供。两者都有树状层级结构，layer 内部有 SubLayers，View 内部有 SubViews。
    在View显示的时候，UIView 做为 Layer 的 CALayerDelegate，View 的显示内容依赖于内部的 CALayer 的 display。
    CALayer 是默认修改属性支持隐式动画的，在给 UIView 的 Layer 做动画的时候，View 作为 Layer 的代理，Layer 通过 actionForLayer:forKey:向 View请求相应的 action(动画行为)
    layer 内部维护着三份 layer tree，分别是 presentLayer Tree(动画树)，modeLayer Tree(模型树)，Render Tree (渲染树)，在做iOS动画的时候，修改动画的属性，在动画的其实是 Layer 的 presentLayer的属性值，而最终展示在界面上的其实是提供 View的modelLayer
    两者最明显的区别是 View可以接受并处理事件，而 Layer 不可以。
2.4	View绘制流程
2.4.1setNeedsDisplay与drawRect:(CGRect)
    可手动调用setNeedsDisplay方法，他会自动调用drawRect:(CGRect)方法，实现UIView界面绘制。不能手动调用drawRect:(CGRect)方法。
    一般情况下，drawRect:方法只会被调用一次，若要手动重绘某个UIView，可掉用[self setNeedsDisplay]方法。
drawRect说明事项：
    [1].调用位于Controller->loadView和Controller->viewDidLoad方法之后。无须担心这些View的drawRect会在控制器执行。
    [2].可以在控制器中设置一些绘制View时用到的值给View。
    [3].在UIView初始化时没有设置rect大小，将直接导致drawRect不被自动调用。
    [4].该方法在调用sizeThatFits后被调用，可以先调用sizeToFit计算出size。然后系统自动调用drawRect:方法。
    [5].通过设置contentMode属性值为UIViewContentModeRedraw。那么将在每次设置或更改frame的时候自动调用drawRect:。(不提倡)
    [6].若使用UIView绘图，只能在drawRect：方法中获取相应的contextRef并绘图。如果在其他方法中获取将获取到一个invalidate的ref并且不能用于画图。
    [7].该方法不能手动显示调用(强制手动调用不会报错，但无效果)，必须通过调用setNeedsDisplay或setNeedsDisplayInRect，让系统自动调该方法。（以view的rect不是0为前提，不提倡）
    [8].若使用CALayer绘图，只能在drawInContext:中（类似于drawRect）绘制，或者在delegate中的相应方法绘制。同样也是调用setNeedDisplay等间接调用以上方法。
    [9].若要实时画图，不能使用gestureRecognizer，只能使用touchbegan等方法来掉用setNeedsDisplay实时刷新屏幕。
注：
    不能在UITableViewCell中直接使用drawRect方法，应该在ContentView中增加一个子View，然后在这个子View中使用drawRect方法。
2.5	hitTest:withEvent:
2.5.1 hitTest:withEvent:调用过程
    iOS系统检测到手指触摸(Touch)操作时会将其放入当前活动Application的事件队列，UIApplication会从事件队列中取出触摸事件并传递给key window(当前接收用户事件的窗口)处理，window对象首先会使用hitTest:withEvent:方法寻找此次Touch操作初始点所在的视图(View)。即需要将触摸事件传递给其处理的视图，称之为hit-test view。
    window对象会在首先在view hierarchy的顶级view上调用hitTest:withEvent:，此方法会在视图层级结构中的每个视图上调用pointInside:withEvent:,如果pointInside:withEvent:返回YES,则继续逐级调用，直到找到touch操作发生的位置，这个视图也就是hit-test view。

hitTest:withEvent:方法的处理流程如下:
    [1].首先调用当前视图的pointInside:withEvent:方法判断触摸点是否在当前视图内；
    [2].若返回NO,则hitTest:withEvent:返回nil;
    [3].若返回YES,则向当前视图的所有子视图(subviews)发送hitTest:withEvent:消息，所有子视图的遍历顺序是从top到bottom，即从subviews数组的末尾向前遍历,直到有子视图返回非空对象或者全部子视图遍历完毕；
    [4].若第一次有子视图返回非空对象,则hitTest:withEvent:方法返回此对象，处理结束；
    [5].如所有子视图都返回非，则hitTest:withEvent:方法返回自身(self)。
    hitTest:withEvent:方法忽略hidden=YES、userInteractionEnabled=NO、alpha<0.01的视图。若子视图的区域超过父视图的bound区域(父视图的clipsToBounds=NO，显示超过父视图bound区域的子视图)，则正常情况下对子视图在父视图之外区域的触摸操作不会被识别，因为父视图的pointInside:withEvent:方法会返回NO，这样就不会继续向下遍历子视图了。当然，也可以重写pointInside:withEvent:方法来处理这种情况。

    对于每个触摸操作都会有一个UITouch对象，UITouch对象用来表示一个触摸操作，即一个手指在屏幕上按下、移动、离开的整个过程。UITouch对象在触摸操作的过程中在不断变化，所以在使用UITouch对象时，不能直接retain，而需要使用其他手段存储UITouch的内部信息。UITouch对象有一个view属性，表示此触摸操作初始发生所在的视图，即上面检测到的hit-test view，此属性在UITouch的生命周期不再改变，即使触摸操作后续移动到其他视图之上。
2.5.2 重写方法示例代码
    在drawRect之后注意用hitTest:withEvent:方法处理事件接收。
    //用户触摸时第一时间加载内容
    - (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event{
        UIView*result = [super hitTest:point withEvent:event];
        CGPoint buttonPoint = [_subjectButton convertPoint:point fromView:self];
        if([_subjectButton pointInside:buttonPoint withEvent:event]){
            return _subjectButton;
        }
        return result;
    }

2.6	Reference
    http://www.jianshu.com/p/709705d875b5
    http://www.cocoachina.com/ios/20150828/13244.html
    http://blog.csdn.net/jiajiayouba/article/details/23447145
