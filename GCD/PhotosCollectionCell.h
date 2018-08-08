//
//  PhotosCollectionCell.h
//  ZhiKeTong
//
//  Created by 张源远 on 2018/7/13.
//  Copyright © 2018年 zonekey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
@class mediaModel;

typedef enum : NSInteger{
    noneEditType = 1,
    defalutEditType = 2,
    allSelectEditType = 3,
}photosEditType;

@interface PhotosCollectionCell : UICollectionViewCell

@property (copy , nonatomic) void(^photoSelectBlock)(mediaModel * model , BOOL isSelected);
@property (copy , nonatomic) void(^photoSelectAssetBlock)(PHAsset *asset , BOOL isSelected);

@property (strong , nonatomic) mediaModel * model;
@property (strong , nonatomic) PHAsset *asset;
@property (strong , nonatomic) NSIndexPath * indexP;

@property (assign , nonatomic) photosEditType editType;

@end
