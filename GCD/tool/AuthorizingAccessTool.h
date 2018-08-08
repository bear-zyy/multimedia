//
//  AuthorizingAccessTool.h
//  systemZyy
//
//  Created by 张源远 on 2018/7/2.
//  Copyright © 2018年 张源远. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^AuthorizationStatus)(BOOL granted);

typedef enum : NSInteger{
    AuthorVideoType = 1,//相机
    AuthorAudioType = 2,//麦克风
    AuthorPhotosType = 3,//相册
    AuthorContactsType =4,//通讯录
    AuthorLocationType = 5,//位置
    AuthorNotiType = 6,//通知
    
}AuthorizingAccessType;

/*
 相机
 */

@interface AuthorizingAccessTool : NSObject

+(instancetype)shareAuthor;

-(void)authorAccessCheck:(AuthorizingAccessType)authorType andAuthor:(AuthorizationStatus)authorStatus;

-(BOOL)checkDeviceModelIsSimulator;

@end
