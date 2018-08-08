//
//  SemaphoreViewController.m
//  GCD
//
//  Created by 张源远 on 2018/5/21.
//  Copyright © 2018年 张源远. All rights reserved.
//

#import "SemaphoreViewController.h"

@interface SemaphoreViewController ()

@end

@implementation SemaphoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton * but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(16, 16, 100, 100);
    [but setTitle:@"back" forState:UIControlStateNormal];
    [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];

//    [self syncMethod];
//    [self asyncMethod];
//    [self group];
    
}

-(void)group{
   
    dispatch_group_t group = dispatch_group_create();
   
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    
    ///组的一种方式
    dispatch_group_async(group, queue, ^{
        NSLog(@"1");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"2");
    });
    dispatch_group_async(group, queue, ^{
        
        NSLog(@"3");
    });
   
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"123");
    });
    
//    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    //组的另一种方式
//    dispatch_group_enter(group);
//    dispatch_async(queue, ^{
//        NSLog(@"11");
//        dispatch_group_leave(group);
//    });
//    dispatch_group_enter(group);
//    dispatch_async(queue, ^{
//        NSLog(@"22");
//        dispatch_group_leave(group);
//    });
//    dispatch_group_enter(group);
//    dispatch_async(queue, ^{
//        NSLog(@"33");
//        dispatch_group_leave(group);
//    });
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        NSLog(@"112233");
//    });
}





//同步
-(void)syncMethod{
    //并发队列
    
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); //GDC默认提供全局并发并列
//
//    // 其实不管是串行队列还是并发队列都是要创建的，但是GCD提供了并发队列，就不需要创建了，
//    dispatch_sync(queue, ^{
//        NSLog(@"1");
//    });
//    dispatch_sync(queue, ^{
//        NSLog(@"2");
//    });
//
//    dispatch_sync(queue, ^{
//        NSLog(@"3");
//    });
 
//    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    /*
     其实 并发队列中添加多个同步任务， 其实同步任务也都是并发执行了， 但是由于同步任务不具备开启线程的能力，所以只能等主线程， 所以也导致任务都是串行执行的，即使是在并发队列中
     */
    
        //这个也是串行队列
//        dispatch_queue_t queuew = dispatch_queue_create("22", DISPATCH_QUEUE_CONCURRENT);
////
//        dispatch_async(queuew, ^{
//            NSLog(@"4");
//        });
//        dispatch_async(queuew, ^{
//            NSLog(@"5");
//        });
//        dispatch_async(queuew, ^{
//            NSLog(@"6");
//        });
//    GCD 其实就是创建一个队列 这个队列可以是串行也可以是并行  往队列中加任务， 这个任务是同步的还是异步的，
//     那主线程队列   不能添加同步执行任务  会死锁    那异步执行任务  会怎么样，第一不会死锁
//    同步执行不具有开启线程的能力
    
//        NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
//        NSLog(@"asyncMain---begin");
    

//    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

     dispatch_async(queue, ^{
         // 追加任务1
         for (int i = 0; i < 2; ++i) {
             [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
             NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
         }
     });

    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });

    dispatch_async(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });

    NSLog(@"asyncMain---end");
    
    
}
//异步
-(void)asyncMethod{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i=0; i< 10; i++) {
            NSLog(@"%d" , i);
        }
    });
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_apply(10, queue, ^(size_t index) {
        NSLog(@"10");
    });
}



-(void)click{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
