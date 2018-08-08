//
//  PhotosViewController.h
//  ZhiKeTong
//
//  Created by 张源远 on 2018/7/12.
//  Copyright © 2018年 zonekey. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger{
    systemVCType = 1,
    localVCType = 2,
}PhotosVCType;

typedef enum :NSInteger{
    shareType = 1,
    choicePhotoType = 2,
}opreationType;

@interface PhotosViewController :UIViewController

@property (copy , nonatomic) void(^choicePhotoBlock)(UIImage * image);

@property (assign , nonatomic) PhotosVCType vcType;

@property (assign , nonatomic) opreationType opreationType;

@end
