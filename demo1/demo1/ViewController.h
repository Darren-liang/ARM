//
//  ViewController.h
//  demo1
//
//  Created by liangweidong on 2019/1/25.
//  Copyright © 2019 liangweidong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSString *(^Callback)(NSString *tt);

@interface ViewController : UIViewController

-(void)findFile:(Callback)block;

@end

