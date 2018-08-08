//
//  mediaModel.h
//  GCD
//
//  Created by 张源远 on 2018/7/11.
//  Copyright © 2018年 张源远. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface mediaModel : NSObject
@property (copy , nonatomic) NSData * data;
@property (assign , nonatomic) int type; // 1 为图片  2位视频
@property (copy , nonatomic) NSString * ID;
@property (copy , nonatomic) NSString * playUrl;
@property (assign , nonatomic) int second;
@end
