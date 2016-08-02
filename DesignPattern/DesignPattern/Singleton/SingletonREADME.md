2.1	修改allocWithZone方法示例
MRC实现：
static ClassName * instance = nil;
+ (ClassName *) sharedInstance
{
    @synchronized(self) {
        if (instance == nil) {
            [[self alloc] init]; // assignment not done here
        }
    }
    return instance;
}
+ (instancetype)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (instance == nil) {
            instance = [super allocWithZone:zone];
            return instance; // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}
ARC实现：
+ (ClassName *) shareInstance
{
    static ClassName * share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[super allocWithZone:NULL] init];
    });
    return share;
}
+ (instancetype) allocWithZone:( NSZone *)zone
{
    return [self shareInstance];
}
    注：用[[self alloc] init];初始化时，alloc方法会调用allocWithZone方法来完成初始化操作。
    可以把**zone**看成一个内存池，alloc，allocWithZone或是dealloc这些操作，都是在这个内存池中操作的。cocoa总是会配置一个默认的NSZone，任何默认的内存操作都基于此。其缺陷是：它是全局范围的，时间一长，必然会导致内存的碎片化，在大量alloc对象时，影响性能。所有cocoa提供方法，可以重写allocWithZone自己生成一个NSZone，并将alloc，copy全部限制在此“zone”之内。
2.2	特点解析
2.2.1	三个要点
    一是某个类只能有一个实例；
    二是它必须自行创建这个实例；
    三是它必须自行向整个系统提供这个实例。
2.2.2	优缺点
    [1].实例控制
        Singleton 会阻止其他对象实例化其自己的 Singleton 对象的副本，从而确保所有对象都访问唯一实例。
    [2].灵活性
        因为类控制了实例化过程，所以类可以更加灵活修改实例化过程
    [3].使用dispatch_once的好处（ARC）
    使用dispatch_once体带原来的加锁操作，可以减少每次加锁的时间，优化了程序性能。dispatch_once函数接收一个dispatch_once_t用于检查该代码块是否已经被调度的谓词（是一个长整型，实际上作为BOOL使用）。它还接收一个希望在应用的生命周期内仅被调度一次的代码块，对于本例就用于share实例的实例化。dispatch_once不仅意味着代码仅会被运行一次，而且还是线程安全的。完全可以替代相对低效的加锁操作。
    [4].使用synchronized的缺点（MRC）
    只能保证线程内的安全，不能保证线程间的安全。多线程访问时，可能会造成多个实例的创建，比如线程A和线程B同时访问，在A进入创建流程，但是尚未创建完成时(instance == nil)，B访问单例，可能会创建两个单例。
