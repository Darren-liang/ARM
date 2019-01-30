//
//  ViewController.m
//  demo1
//
//  Created by liangweidong on 2019/1/25.
//  Copyright © 2019 liangweidong. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController
+(void)load
{
    NSLog(@"");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (int i = 0; i < 10; i++)
    {
        if ( i < 5)
        {
            continue;
        }
        NSLog(@"dasdddaads===%i", i);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
