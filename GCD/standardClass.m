//
//  standardClass.m
//  GCD
//
//  Created by 张源远 on 2018/10/31.
//  Copyright © 2018年 张源远. All rights reserved.
//

#import "standardClass.h"

@implementation standardClass

+(standardClass *)standard{
    
    static standardClass * stand = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stand = [[standardClass alloc] init];
    });
    return stand;
    
}

@end
