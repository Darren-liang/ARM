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
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 100);
    btn.backgroundColor = [UIColor orangeColor];
    [btn addTarget:self action:@selector(btnaction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)btnaction
{
    //通过exception可以捕获到
    NSMutableArray *arr = [NSMutableArray array];
    NSLog(@"%@", arr[2]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
