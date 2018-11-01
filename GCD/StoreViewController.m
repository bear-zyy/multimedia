//
//  StoreViewController.m
//  GCD
//
//  Created by 张源远 on 2018/10/31.
//  Copyright © 2018年 张源远. All rights reserved.
//

#import "StoreViewController.h"
#import "standardClass.h"

@interface StoreViewController ()

@end

#define QSPDownloadTool_Document_Path                   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

#define QSPDownloadTool_DownloadSources_Path            [QSPDownloadTool_Document_Path stringByAppendingPathComponent:@"store.data"]

static NSString * stringa = @"aaaa"; //这个就是一个常量了  而且只能当前类中使用

NSString * const stringb = @"bbbb";

NSString * const stringC = @"cccc";

//const  常量 只读，  但是作用域只限于当前类，在其他类使用extrn引用后 可以改变了
@implementation StoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary * dict = @{@"key":@"value"};

    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:dict];

    [data writeToFile:QSPDownloadTool_DownloadSources_Path atomically:YES];

    [[NSUserDefaults standardUserDefaults] setObject:@"aaa" forKey:@"key"];

    [standardClass standard].array = @[@"1",@"2"];

    [self staticMethod];

    [[standardClass standard]hahah];

    NSLog(@"%@" , stringb);

    static int a = 10;
    NSLog(@"%d" , a);

    for (int i= 0 ; i<3; i++) {
        [self test];
    }

    [self constMethod];
}

-(void)constMethod{
    
    NSLog(@"asdfggh");
    
}

//static 静态变量  在局部变量时，只会初始化一次 只有一个内存地址  在创建单例时有应用
-(void)test{
    
    static int a = 0;
    a++ ;
    NSLog(@"%d" , a);
}

-(void)staticMethod{
    
    static int num = 4;
    num = 5;
    NSLog(@"%d" , num);
    
    
}

- (IBAction)getClick:(id)sender {
    
    NSDate * date1 = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time1 = [date1 timeIntervalSince1970]*1000;
    NSLog(@"%f" , time1);
    
    NSDate * date2 = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time2 = [date2 timeIntervalSince1970]*1000;
    NSLog(@"%f" , time2);
    
    NSData * data = [NSData dataWithContentsOfFile:QSPDownloadTool_DownloadSources_Path];
    NSDictionary * dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSLog(@"%@" , dict);
//    NSDictionary * dict = [NSDictionary dictionaryWithContentsOfFile:QSPDownloadTool_DownloadSources_Path];
    
    NSDate * date3 = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time3 = [date3 timeIntervalSince1970]*1000;
    NSLog(@"%f" , time3);
    
    NSString * string = [[NSUserDefaults standardUserDefaults] objectForKey:@"key"];
    
    NSDate * date4 = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time4 = [date4 timeIntervalSince1970]*1000;
    NSLog(@"%f" , time4);
    
    NSLog(@"%@" , [standardClass standard].array);
    
    NSDate * date5 = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time5 = [date5 timeIntervalSince1970]*1000;
    NSLog(@"%f" , time5);
    
    NSLog(@"%@" , string);
    
    /*
     1540952172229.290039       1540952769286.458008
     1540952172229.511963       1540952769286.614990
     1540952172229.985840       1540952769286.960205
     
     0.15秒
     0.4秒
     不会因为数据量的大小在存储时间是有明显变化
     
     1540952688100.227783       1540952840376.915039
     1540952688100.386230       1540952840377.080811
     1540952688100.746094       1540952840377.400879
     
     1540952507846.716797
     1540952507846.875000
     1540952507847.152832
     
     1540952562232.572998
     1540952562232.727051
     1540952562233.058838
     */
    
}

- (IBAction)backClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
