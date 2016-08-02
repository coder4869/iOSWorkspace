1	基础数据结构

1.1	objc_class类(定义文件<objc/runtime.h>)
    typedef struct objc_class *Class;
    struct objc_class {
        Class isa  OBJC_ISA_AVAILABILITY;  //指向metaclass (元类)
    #if !__OBJC2__4
        Class super_class						OBJC2_UNAVAILABLE;	//指向其父类
        const char *name 						OBJC2_UNAVAILABLE;	//类名
        long version 							OBJC2_UNAVAILABLE;
        long info        						OBJC2_UNAVAILABLE;
        long instance_size              		OBJC2_UNAVAILABLE;
        struct objc_ivar_list *ivars       		OBJC2_UNAVAILABLE;
        struct objc_method_list **methodLists  	OBJC2_UNAVAILABLE;
        struct objc_cache *cache              	OBJC2_UNAVAILABLE;
        struct objc_protocol_list *protocols   	OBJC2_UNAVAILABLE;
    #endif
    } OBJC2_UNAVAILABLE;
➢	isa：指向metaclass，即静态的Class。一般一个Obj对象中的isa指向普通Class，该Class中存储普通成员变量和对象方法（“-”开头），普通Class中的isa指针指向静态Class，静态Class中存储static类型成员变量和类方法（“+”开头）。
➢	super_class:指向父类，如果这个类是根类，则为NULL。
➢	所有metaclass中isa指针都指向根metaclass。而根metaclass则指向自身。Root metaclass是通过继承Root class产生的。与root class结构体成员一致，也就是前面提到的结构。不同的是Root metaclass的isa指针指向自身。
➢	version：类的版本信息，初始化默认为0，可以通过runtime函数class_setVersion和class_getVersion进行修改、读取，有助于了解不同版本的实例变量布局的改变。
➢	info：一些标识信息,如CLS_CLASS (0x1L) 表示该类为普通 class ，其中包含对象方法和成员变量; CLS_META (0x2L) 表示该类为 metaclass，其中包含类方法;
➢	instance_size：该类的实例变量大小(包括从父类继承下来的实例变量);
➢	ivars：用于存储每个成员变量的地址。在objc_class中，成员变量、属性的信息放在链表ivars中，ivars是数组，各元素是指向Ivar(变量信息)的指针。
➢	methodLists ：与 info 的一些标志位有关,如CLS_CLASS (0x1L),则存储对象方法，如CLS_META (0x2L)，则存储类方法;
➢	cache：指向最近使用的方法的指针，用于提升效率；
➢	protocols：存储该类遵守的协议

1.2	objc_cache
    struct objc_cache {
        unsigned int mask /* total = mask + 1 */    OBJC2_UNAVAILABLE;
        unsigned int occupied                       OBJC2_UNAVAILABLE;
        Method buckets[1]                           OBJC2_UNAVAILABLE;
    };
    mask：一个整数，指定分配的缓存bucket的总数。在方法查找过程中，Objective-C runtime使用这个字段来确定开始线性查找数组的索引位置。指向方法selector的指针与该字段做一个AND位操作(index = (mask & selector))。这可以作为一个简单的hash散列算法。
    occupied：一个整数，指定实际占用的缓存bucket的总数。
    buckets：指向Method数据结构指针的数组。这个数组可能包含不超过mask+1个元素。需要注意的是，指针可能是NULL，表示这个缓存bucket没有被占用，另外被占用的bucket可能是不连续的。这个数组可能会随着时间而增长。
1.2.1	cache用例分析
    NSArray *array = [[NSArray alloc] init];
流程解析：
    [1].[NSArray alloc]先被执行。因为NSArray没有+alloc方法，于是去父类NSObject去查找。
    [2].检测NSObject是否响应+alloc方法，发现响应，于是检测NSArray类，并根据其所需的内存空间大小开始分配内存空间，然后把isa指针指向NSArray类。同时，+alloc也被加进cache列表里面。
    [3].接着，执行-init方法，如果NSArray响应该方法，则直接将其加入cache；如果不响应，则去父类查找。
    [4].在后期的操作中，如果再以[[NSArray alloc] init]这种方式来创建数组，则会直接从cache中取出相应的方法，直接调用。
1.3	objc_object & id & Object & Class & Meta Class
    objc_object是表示一个类的实例的结构体，它的定义如下(objc/objc.h)：
    struct objc_object {
        Class isa  OBJC_ISA_AVAILABILITY;
    };
    typedef struct objc_object *id;
    Class定义(objc.h)：typedef struct objc_class *Class; Class本身指向C的struct objc_class。
    当创建一个特定类的实例对象时，分配的内存包含一个objc_object数据结构，然后是类的实例变量的数据。NSObject类的alloc和allocWithZone:方法使用函数class_createInstance来创建objc_object数据结构。
    id是一个objc_object结构类型的指针，所以在使用其他NSObject类型的实例时需要在前面加上*，而使用 id 时却不用。这有助于实现类似于C++中泛型的一些操作。该类型的对象可以转换为任何一种对象，类似于C语言中void *指针类型的作用。
    可以把Meta Class理解为一个Class对象的Class。向一个Objective-C对象发送消息时，Runtime库根据实例对象的isa指针找到这个实例对象所属的类，在类的方法列表及父类的方法列表中去寻找与消息对应的selector指向的方法。找到后即运行这个方法。向一个类发送消息时，这条消息会在类的Meta Class的方法列表里查找。而 Meta Class本身也是一个Class，它跟其他Class一样也有自己的 isa 和 super_class 指针。如下图：

➢	每个Class都有一个isa指针指向一个唯一的Meta Class
➢	每一个Meta Class的isa指针都指向最上层的Meta Class（NSObject的Meta Class）
➢	最上层的Meta Class的isa指针指向自己，形成一个回路
➢	每一个Meta Class的super class指针指向它原本Class的 Super Class的Meta Class。但是最上层的Meta Class的 Super Class指向NSObject Class本身
➢	最上层的NSObject Class的super class指向 nil
对于NSObject继承体系来说，其实例方法对体系中的所有实例、类和meta-class都是有效的；而类方法对于体系内的所有类和meta-class都是有效的。
注意：在一个类对象调用class方法是无法获取meta-class，它只是返回类而已。
1.3.1	示例代码
@interface Sark : NSObject
@end	@implementation Sark
@end
int main(int argc, const char * argv[]) {
@autoreleasepool {
BOOL res1 = [(id)[NSObject class] isKindOfClass:[NSObject class]];
BOOL res2 = [(id)[NSObject class] isMemberOfClass:[NSObject class]];
BOOL res3 = [(id)[Sark class] isKindOfClass:[Sark class]];
BOOL res4 = [(id)[Sark class] isMemberOfClass:[Sark class]];
NSLog(@"%d %d %d %d", res1, res2, res3, res4);
}
return 0;
}
- (BOOL)isKindOf:aClass {
Class cls;
for (cls = isa; cls; cls = cls->superclass) 
if (cls == (Class)aClass)
return YES;
return NO;
}	- (BOOL)isMemberOf:aClass
{
return isa == (Class)aClass;
}

结论分析（运行结果是：1 0 0 0）：
➢	res1：当NSObject Class对象第一次进行比较时，得到它的isa为NSObject的Meta Class，此时 NSObject Meta Class != NSObject Class。
然后取NSObject 的Meta Class 的Super class（即NSObject Class），返回相等。
➢	res2：当前的 isa 指向 NSObject 的 Meta Class，和NSObject Class不相等。
➢	res3&res4：Sark Class 的isa指向的是 Sark的Meta Class，和Sark Class不相等；
Sark Meta Class的super class 指向的是 NSObject Meta Class，和 Sark Class不相等；
NSObject Meta Class的 super class 指向 NSObject Class，和 Sark Class 不相等；
NSObject Class 的super class 指向 nil，和 Sark Class不相等。
1.4	Self & Super
self是类的隐藏参数，指向当前调用方法的这个类的实例。super是一个Magic Keyword，本质是一个编译器标示符，和self是指向的同一个消息接受者。不同的是，super告诉编译器，调用class这个方法时，要去父类的方法，而不是本类里的。最后在NSObject类中发现这个方法。而 - (Class)class的实现就是返回self的类别，objc Runtime开源代码对- (Class)class方法的实现:
- (Class)class {
return object_getClass(self);
}
下例中调用[self class]或[super class]，接受消息的对象都是Son *xxx这个对象。输出均为Son：
@implementation Son : Father
- (id)init {
self = [super init];
if (self) {
NSLog(@"%@", NSStringFromClass([self class]));
NSLog(@"%@", NSStringFromClass([super class]));
}
return self;
}
@end
1.5	Reference
http://www.cocoachina.com/ios/20141031/10105.html (南峰子的技术博客)
