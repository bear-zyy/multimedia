//
//  PHAsset+Edit.m
//  ZhiKeTong
//
//  Created by 张源远 on 2018/7/19.
//  Copyright © 2018年 zonekey. All rights reserved.
//

#import "PHAsset+Edit.h"
#import <objc/runtime.h>

static char ZYYAddProperty;

@implementation PHAsset (Edit)

-(NSInteger)PhotoSeleted{
    return [objc_getAssociatedObject(self, &ZYYAddProperty) integerValue];
}

-(void)setPhotoSeleted:(NSInteger)PhotoSeleted{
    objc_setAssociatedObject(self, &ZYYAddProperty, @(PhotoSeleted), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSData *)imageData{
    return objc_getAssociatedObject(self, &ZYYAddProperty);
}

-(void)setImageData:(NSData *)imageData{
    objc_setAssociatedObject(self, &ZYYAddProperty, imageData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
