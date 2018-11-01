//
//  standardClass.m
//  GCD
//
//  Created by 张源远 on 2018/10/31.
//  Copyright © 2018年 张源远. All rights reserved.
//

#import "standardClass.h"
#import "StoreViewController.h"
#import "UrlHeader.h"

@implementation standardClass


+(instancetype)standard{
    
    static standardClass * stand;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stand = [[standardClass alloc] init];
    });
    return stand;
    
}

-(void)hahah{
    
    extern NSString * stringb;
    NSLog(@"%@" , stringb);
    
    extern NSString * url;
    
    
    NSLog(@"url  ====  %@" , url);
    
}

@end
