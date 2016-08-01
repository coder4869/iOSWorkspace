3.	代理模式
    是一种通用的设计模式，iOS中对代理支持的很好，由代理对象、委托者、协议三部分组成。OC中用@protocol实现协议。
    [1].协议：用来指定代理双方可以做什么，必须做什么。
    [2].委托：根据指定的协议，指定代理去完成什么功能。
    [3].代理：根据指定的协议，完成委托方需要实现的功能。
经常遇到两种类型的代理：在cocoa框架中的Delegate模式与自定义的委托模式。
3.1	协议-Protocol
    协议规定代理双方的行为，协议中的内容一般都是方法列表，当然也可以定义属性。协议是公共的定义，如果只是某个类使用，一般将其写在某个类中。如果是多个类公用同一协议，一般创建专门的Protocol定义文件。遵循的协议可以被继承，例如UITableView继承自UIScrollView，便也继承了UIScrollViewDelegate，可以通过代理方法获取UITableView偏移量等状态参数。
    协议与java中的interface类似。它只提供一套公用接口定义，接口的实现由代理对象完成。在iOS中，对象不支持多继承，而协议可以多继承。一个代理可以有多个委托方，而一个委托方也可以有多个代理。
    协议有两个修饰符@optional和@required，默认为@required状态。这两个修饰符只是约定代理是否强制需要遵守协议，如果@required状态的方法代理没有遵守，会报一个黄色的警告，只是起一个约束的作用，没有其他功能。无论是@optional还是@required，在委托方调用代理方法时都需要做一个判断，判断代理是否实现当前方法，否则会导致崩溃。示例如下：
    if ([self.delegate respondsToSelector:@selector(delegateMethod:param2:)]) {
        [self.delegate delegateMethod:value1 param2:value2];
    }
3.2	原理讲解
3.3.1代理实现流程
    在iOS中代理的本质就是代理对象内存的传递和操作，在委托类设置代理对象后，实际上只是用一个id类型的指针将代理对象进行了一个弱引用。委托方让代理方执行操作，实际上是在委托类中向这个id类型指针指向的对象发送消息，而这个id类型指针指向的对象，就是代理对象。
    委托方的代理属性本质上就是代理对象自身，设置委托代理就是代理属性指针指向代理对象，相当于代理对象只是在委托方中调用自己的方法，如果方法没有实现就会导致崩溃。从崩溃的信息上来看，就可以看出来是代理方没有实现协议中的方法导致的崩溃。
    而协议只是一种语法，是声明委托方中的代理属性可以调用协议中声明的方法，而协议中方法的实现还是有代理方完成，而协议方和委托方都不知道代理方有没有完成，也不需要知道怎么完成。
3.2.2代理内存管理
    [1].为何设置代理属性使用weak？
        如果用strong类型，有可能会造成循环引用。
    [2].两种弱引用方式
    下面两种方式都是弱引用代理对象，但是第一种在代理对象被释放后不会导致崩溃，而第二种会导致崩溃。
        @property (nonatomic, weak) id delegate;
        @property (nonatomic, assign) id delegate;
    weak和assign是一种“非拥有关系”的指针，通过这两种修饰符修饰的指针变量，都不会改变被引用对象的引用计数。但是在一个对象被释放后，weak会自动将指针指向nil，而assign则不会。在iOS中，向nil发送消息时不会导致崩溃的，所以assign就会导致野指针的错误unrecognized selector sent to instance。在修饰代理属性时，建议用weak修饰，比较安全。
3.3	代理对象作用-控制器瘦身
3.3.1控制器瘦身
    项目的复杂化增加了业务增加，导致控制器的臃肿。MVVM模式不适合架构已确定的大中型项目。UITableView等控件的处理逻辑增加，也会增加控制器臃肿。可以使用代理对象方式对控制器瘦身。方案如下：
    将UITableView的delegate和DataSource单独拿出来，由一个代理对象类进行控制，只将必须控制器处理的逻辑传递给控制器处理。
    UITableView的数据处理、展示逻辑和简单的逻辑交互都由代理对象去处理，和控制器相关的逻辑处理传递出来，交由控制器来处理，这样控制器的工作少了很多，而且耦合度也大大降低了。这样一来，只需要将需要处理的工作交由代理对象处理，并传入一些参数即可。
    使用代理对象类还有一个好处，就是如果多个UITableView逻辑一样或类似，代理对象是可以复用的。
3.4	非正式协议
3.4.1 简介
    在iOS2.0之前尚未引入@Protocol正式协议，实现协议的功能主要是通过给NSObject添加Category的方式。这种通过Category的方式，相对于iOS2.0之后引入的@Protocol，就叫做非正式协议。
    非正式协议一般都是以NSObject的Category的方式存在的。由于是对NSObject进行的Category，所以所有基于NSObject的子类，都接受了所定义的非正式协议。对于@Protocol来说编译器会在编译期检查语法错误，而非正式协议则不会检查是否实现。
    非正式协议中没有@Protocol的@optional和@required之分，和@Protocol一样在调用的时候，需要进行判断方法是否实现。
    //由于是使用的Category，所以需要用self来判断方法是否实现
        if ([self respondsToSelector:@selector(delegateMethod:param2:)]) {
            [self delegateMethod:value1 param2:value2];
        }
3.4.2 非正式协议示例
    在iOS早期也使用了大量非正式协议，例如CALayerDelegate就是非正式协议的一种实现，非正式协议本质上就是Category。
    @interface NSObject (CALayerDelegate)
    - (void)displayLayer:(CALayer *)layer;
    - (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx;
    - (void)layoutSublayersOfLayer:(CALayer *)layer;
    - (nullable id)actionForLayer:(CALayer *)layer forKey:(NSString *)event;
    @ends
3.5	代理和block的选择
    多个消息传递，应该使用delegate。在有多个消息传递时，用delegate实现更合适，看起来也更清晰。block就不太好了，这个时候block反而不便于维护，而且看起来非常臃肿，很别扭。例如：UIKit的UITableView中有很多代理，如果都换成block实现，那简直看起来不能忍受。
    一个委托对象的代理属性只能有一个代理对象（delegate只是一个保存某个代理对象的地址，如果设置多个代理相当于重新赋值，只有最后一个设置的代理才会被真正赋值。），如果想要委托对象调用多个代理对象的回调，应该用block。
    单例对象最好不要用delegate。单例对象由于始终都只是同一个对象，如果使用delegate，就会造成delegate属性被重新赋值的问题，最终只能有一个对象可以正常响应代理方法。
    这种情况可以使用block的方式，在主线程的多个对象中使用block都是没问题的。在多线程情况下因为是单例对象，我们对block中必要的地方加锁，防止资源抢夺的问题发生。
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 10;  //设置最大并发数
    for (int i = 0; i < 100; i++) {
        [queue addOperationWithBlock:^{
            [[LoginViewController shareInstance] userLoginWithSuccess:^(NSString *username) {
                NSLog(@"TestTableViewController : %d", i);
            }];
        }];
    }
    [1].代理是可选的，而block在方法调用的时候只能通过将某个参数传递一个nil进去，只不过这并不是什么大问题，没有代码洁癖的可以忽略。
    [self downloadTaskWithResumeData:resumeData
                      sessionManager:manager
                            savePath:savePath
                        progressBlock:nil
                        successBlock:successBlock
                        failureBlock:failureBlock];
    [2].从设计模式的角度来说，代理更加面向过程，block则更面向结果。例如用于XML解析的NSXMLParserDelegate代理，它有很多代理方法，NSXMLParser会不间断调用这些方法将一些转换的参数传递出来，这就是NSXMLParser解析流程，这些通过代理来展现比较合适。而例如一个网络请求回来，就通过success、failure代码块来展示就比较好。
    [3].从性能上来说，block的性能消耗要略大于delegate，因为block会涉及到栈区向堆区拷贝等操作，时间和空间上的消耗都大于代理。而代理只是定义了一个方法列表，在遵守协议对象的objc_protocol_list中添加一个节点，在运行时向遵守协议的对象发送消息即可。
3.6	Reference
Cocachina刘小壮：http://www.cocoachina.com/ios/20160317/15696.html
唐巧block：http://blog.devtang.com/2013/07/28/a-look-inside-blocks/



