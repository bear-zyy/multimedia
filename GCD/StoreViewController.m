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

@implementation StoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary * dict = @{@"key":@"value"};
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:dict];
    
    [data writeToFile:QSPDownloadTool_DownloadSources_Path atomically:YES];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"aaa" forKey:@"key"];

    [standardClass standard].array = @[@"1",@"2"];
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
     
     1540953460125.702881
     1540953460125.849854
     1540953460126.205078
     1540953460126.343994
     */
    
}

- (IBAction)backClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
