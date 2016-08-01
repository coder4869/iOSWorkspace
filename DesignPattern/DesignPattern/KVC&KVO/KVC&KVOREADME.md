4.	观察者模式
    观察者模式简称为KVO，即Key-Value-Observer，基于KVC（Key-Value-Coding）机制实现的。键值对改变通知的观察者。只有当调用KVC去访问key值的时候KVO才会起作用。
4.1	KVC(Key-Value-Coding)机制
    KVC，即是指NSKeyValueCoding，一个非正式的Protocol，提供一种机制来间接访问对象的属性。
    KVC主要通过isa-swizzling(类型混合指针机制)技术，来实现其内部查找定位的。isa指针（就是is a kind of的意思）指向维护分发表的对象的类。该分发表实际上包含了指向实现类中的方法的指针，和其它数据。
    示例代码：[site setValue:@"sitename" forKey:@"name"];
    编译器处理结果：
    SEL sel = sel_get_uid("setValue:forKey:");  //根据方法名字获取SEL
    IMP method = objc_msg_lookup(site->isa, sel);  //GNU运行时获取IMP
    method(site, sel, @"sitename", @"name");
    一个对象在调用setValue的时候，KVC内部的实现：
    [1].首先根据方法名找到运行方法的时候所需要的环境参数。
    [2].他会从自己isa指针结合环境参数，找到具体的方法实现的接口。
    [3].再直接查找得来的具体的方法实现。
    补充说明：
    （1）SEL数据类型：它是编译器运行Objective-C里的方法的环境参数。
    （2）IMP数据类型：他其实就是一个编译器内部实现时候的函数指针。当Objective-C编译器去处理实现一个方法的时候，就会指向一个IMP对象，这个对象是C语言表述的类型（事实上，在Objective-C的编译器处理的时候，基本上都是C语言的）。
4.2	KVO(Key-Value-Observing)机制
    KVC机制上加上KVO的自动观察消息通知机制就是KVO的实现机制。
    当观察者为一个对象的属性进行了注册，被观察对象的isa指针被修改的时候，isa指针就会指向一个中间类，而不是真实的类。所以isa指针其实不需要指向实例对象真实的类。所以我们的程序最好不要依赖于isa指针。在调用类的方法的时候，最好要明确对象实例的类名。
    因为KVC的实现机制，可以很容易看到某个KVC操作的Key，而后也很容易的跟观察者注册表中的Key进行匹对。假如访问的Key是被观察的Key，则在内部就可以很容易的到观察者注册表中去找到观察者对象，而后给他发送消息。KVO的三种用法：
    [1].使用KVC
        如果有访问器方法，则运行时会在访问器方法中调用will/didChangeValueForKey:方法；
        没用访问器方法，运行时会在setValue:forKey方法中调用will/didChangeValueForKey:方法。
    [2].有访问器方法
        运行时会重写访问器方法调用will/didChangeValueForKey:方法。因此，直接调用访问器方法改变属性值时，KVO也能监听到。
    [3].显示调用will/didChangeValueForKey:方法。
4.3	Reference
    KVC, KVO实现原理剖析：http://www.jianshu.com/p/37a92141077e
    KVC 与 KVO 理解：http://magicalboy.com/kvc_and_kvo/
