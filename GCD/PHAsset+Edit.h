//
//  PHAsset+Edit.h
//  ZhiKeTong
//
//  Created by 张源远 on 2018/7/19.
//  Copyright © 2018年 zonekey. All rights reserved.
//

#import <Photos/Photos.h>

@interface PHAsset (Edit)

@property (assign , nonatomic) NSInteger PhotoSeleted;

@property (strong , nonatomic) NSData * imageData;

@end
