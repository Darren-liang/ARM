//
//  LWDMemoryARM.m
//  demo1
//
//  Created by liangweidong on 2019/1/30.
//  Copyright © 2019 liangweidong. All rights reserved.
//

#import "LWDMemoryARM.h"

@implementation LWDMemoryARM
/**
 目前对于内存过高被杀死的情况是没有办法直接统计的，一般通过排除法来做百分比的统计，原理如下
 
 1,程序启动，设置标志位
 2,程序正常退出，清楚标志
 3,程序的Crash，清楚标志
 4，程序电量过低导致关机，这个也没办法直接监控，可以加入电量检测来辅助判断
 5，第二次启动，标志位如果存在，则代表Abort一次，上传后台做统计
 */


@end
