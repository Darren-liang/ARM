//
//  Person+lwd.m
//  demo1
//
//  Created by liangweidong on 2019/1/28.
//  Copyright © 2019 liangweidong. All rights reserved.
//

#import "Person+lwd.h"

@implementation Person (lwd)

+(void)load
{
    NSLog(@"");
}
+ (void)initialize
{
    if (self == [self class]) {
        NSLog(@"");
    }
}
@end
