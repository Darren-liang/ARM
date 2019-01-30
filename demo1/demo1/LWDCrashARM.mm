//
//  LWDCrashARM.m
//  demo1
//
//  Created by liangweidong on 2019/1/30.
//  Copyright © 2019 liangweidong. All rights reserved.
//

#import "LWDCrashARM.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import <UIKit/UIKit.h>

/**
 对于崩溃的情况，一般是由
 1,Mach异常或
 2,Objective-C 异常（NSException）引起的。
 我们可以针对这两种情况抓取对应的 Crash 事件。
 */

@implementation LWDCrashARM
-(instancetype)init
{
    if ([super init])
    {
        [self machCatchInit];
        [self exceptionCatchInit];
    }
    return self;
}
//Mach 异常捕获
/**
 如果想要做mach 异常捕获，
 1，需要注册一个异常端口，这个异常端口会对当前任务的所有线程有效，
 2，如果想要针对单个线程，可以通过 thread_set_exception_ports注册自己的异常端口，
 3，发生异常时，首先会将异常抛给线程的异常端口，然后尝试抛给任务的异常端口，
 4，当我们捕获异常时，就可以做一些自己的工作，比如，当前堆栈收集等。
 */
void SignalExceptionHandler(int signal)
{
    //收集堆栈信息
    NSArray *array = [LWDCrashARM logStack];
    NSLog(@"%@", array);
}

-(void)machCatchInit
{
    signal(SIGHUP, SignalExceptionHandler);
    signal(SIGINT, SignalExceptionHandler);
    signal(SIGQUIT, SignalExceptionHandler);
    
    signal(SIGABRT, SignalExceptionHandler);
    signal(SIGILL, SignalExceptionHandler);
    signal(SIGSEGV, SignalExceptionHandler);
    signal(SIGFPE, SignalExceptionHandler);
    signal(SIGBUS, SignalExceptionHandler);
    signal(SIGPIPE, SignalExceptionHandler);
}

//NSException 捕获
void HandleException(NSException *exception)
{//获取到异常的堆栈信息
    // 异常的堆栈信息
    NSArray *stackArray = [exception callStackSymbols];
    
    // 出现异常的原因
    NSString *reason = [exception reason];
    
    // 异常名称
    NSString *name = [exception name];
    
    NSString *exceptionInfo = [NSString stringWithFormat:@"Exception reason：%@\nException name：%@\nException stack：%@",name, reason, stackArray];
    
    NSLog(@"%@", exceptionInfo);
}

-(void)exceptionCatchInit
{
    NSSetUncaughtExceptionHandler(&HandleException);
}

+(NSMutableArray *)logStack
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
