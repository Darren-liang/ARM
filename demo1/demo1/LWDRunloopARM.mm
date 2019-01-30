//
//  LWDRunloopARM.m
//  demo1
//
//  Created by liangweidong on 2019/1/30.
//  Copyright © 2019 liangweidong. All rights reserved.
//

#import "LWDRunloopARM.h"
#import <CoreFoundation/CoreFoundation.h>
#import <execinfo.h>

@interface LWDRunloopARM()
{
    int timeoutCount;
    CFRunLoopObserverRef observer;
    @public
    dispatch_semaphore_t semaphore;//gcd信号量
    CFRunLoopActivity activity;
}
@end

@implementation LWDRunloopARM

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        //注册runloop的observe通知，来监控主线程的卡断
        [self startRunloopMonitor];
    }
    return self;
}

static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    //类型转换 得到相当于self
    LWDRunloopARM *loopARM = (__bridge LWDRunloopARM*)info;
    //记录状态值
    loopARM->activity = activity;
    //发送gcd信号量的信号
    dispatch_semaphore_t sem = loopARM->semaphore;
    dispatch_semaphore_signal(sem);
}

-(void)startRunloopMonitor
{
    if (observer)
    {
        return;
    }
    //gcd信号量 来控制同步 并发量
    semaphore = dispatch_semaphore_create(0);//初始化心信号量对象
    
    //注册runloop来进行他的状态观察
    CFRunLoopObserverContext context = {0,(__bridge void*)self,NULL,NULL};
    observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                       kCFRunLoopAllActivities,
                                       YES,
                                       0,
                                       &runLoopObserverCallBack,
                                       &context);
    
    //将观察者添加到住线程的runloop的common模式下的观察中
    //因为监控卡断，肯定是主线程处理不过来了，我们感受到的就是住线程的，所以我们这里监控的是主线程
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    
    //开辟异步线程，在子线程监控时长 开启一个持续的loop用来进行监控
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //开启个死循环来检测
        while (YES)
        {
            //上去这里肯定进不去，因为初始化的时候信号量为0，值是0，就给我停50ms
            //加入连续5次超时50ms认为卡断，或者单次超时250ms
            long st = dispatch_semaphore_wait(self->semaphore, dispatch_time(DISPATCH_TIME_NOW, 50*NSEC_PER_MSEC));//50ms
            if (st != 0)
            {
                if (!self->observer)
                {
                    self->timeoutCount = 0;
                    self->semaphore = 0;
                    self->activity = 0;
                    return;
                }
                
                //两个runloop的状态，BeforeSources和AfterWaiting这两个状态区间时间能够检测到是否卡顿
                /**
                    为什么是监控这两个状态之间的时间呢，因为根据runloop的原理我们可以知道，他处理sources的时候就是在这两个状态之间
                    kCFRunLoopBeforeSources 即将进入休眠
                    kCFRunLoopAfterWaiting  刚从休眠中唤醒
                 */
                if (self->activity == kCFRunLoopBeforeSources ||
                    self->activity == kCFRunLoopAfterWaiting)
                {
                    if (++self->timeoutCount < 5)
                    {
                        continue;
                    }
                    
                    //得到堆栈信息
                    NSMutableArray *arr = [self logStack];
                    //这里得到的数组就是卡顿之后的堆栈信息，把这些信息上传服务器即可
                    NSLog(@"%@", arr);
                }
            }
            self->timeoutCount = 0;
        }
    });
    
}

-(void)stopRunloopMonitor
{
    if (!observer)
    {
        return;
    }
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    CFRelease(observer);
    observer = NULL;
}

-(NSMutableArray *)logStack
{
    void *callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (i = 0; i < frames; i++)
    {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    
    return backtrace;
}

@end
