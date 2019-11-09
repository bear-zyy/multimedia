//
//  TestTwo.m
//  GCD
//
//  Created by zyy on 2019/9/25.
//  Copyright © 2019年 张源远. All rights reserved.
//

#import "TestTwo.h"

@implementation TestTwo
+(TestTwo*)shard{
    static TestTwo * two = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        two = [[TestTwo alloc] init];
        for (int i = 0; i<5; i++) {
        }
    });
    
    return two;
}
@end
