//
//  PhotosCollectionCell.m
//  ZhiKeTong
//
//  Created by 张源远 on 2018/7/13.
//  Copyright © 2018年 zonekey. All rights reserved.
//

#import "PhotosCollectionCell.h"
#import "mediaModel.h"
#import "PHAsset+Edit.h"

@interface PhotosCollectionCell ()

@property (weak, nonatomic) IBOutlet UIButton *selectBut;
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) PHCachingImageManager *imageManager;

@property (assign , nonatomic) BOOL isAllowEdit;
@property (assign , nonatomic) BOOL isVideo;

@end

@implementation PhotosCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageManager = [[PHCachingImageManager alloc]init];
    
    self.isAllowEdit = YES;
    self.isVideo = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photoAllowEditMethod:) name:@"photoAllowEditNoti" object:nil];
}

-(void)setModel:(mediaModel *)model{
    
    _model = model;
    
    self.ImageView.image = [UIImage imageWithData:model.data];
    
    if(model.type == 1){
        self.timeLabel.hidden = YES;
    }
    else{
        self.timeLabel.hidden = NO;
        self.timeLabel.text = [NSString stringWithFormat:@"%@" , [self changeIntToString:model.second]];
    }
    
}

-(void)setAsset:(PHAsset *)asset{
    _asset = asset;
    
    if (asset.mediaType ==PHAssetMediaTypeImage) {
        CGSize AssetGridThumbnailSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width -30) / 4, ([UIScreen mainScreen].bounds.size.width -30) / 4);
        [self.imageManager requestImageForAsset:asset targetSize:AssetGridThumbnailSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            self.ImageView.image = result;
        }];
        self.selectBut.hidden = NO;
        self.timeLabel.hidden = YES;
        
    }
    else if (asset.mediaType == PHAssetMediaTypeVideo){
        self.selectBut.hidden = YES;
        self.timeLabel.hidden = NO;
        PHVideoRequestOptions * options = [[PHVideoRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        [self.imageManager requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            
            AVURLAsset *urlAsset = (AVURLAsset *)asset;
//            NSURL *url = urlAsset.URL;
//            NSData *data = [NSData dataWithContentsOfURL:url];
            AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:urlAsset];
            assetGen.appliesPreferredTrackTransform = YES;
            CMTime time = CMTimeMakeWithSeconds(0.0, 600);
            NSError *error = nil;
            CMTime actualTime;
            CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
            UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
            CGImageRelease(image);
            
            int second = 0;
            second = (int)urlAsset.duration.value / urlAsset.duration.timescale;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.ImageView.image = videoImage;
                self.timeLabel.text = [NSString stringWithFormat:@"%@" , [self changeIntToString:second]];
            });
        }];
    }
    if (asset.PhotoSeleted) {
        self.selectBut.selected = YES;
    }
    else{
        self.selectBut.selected = NO;
    }
}

-(void)setEditType:(photosEditType)editType{
    _editType = editType;
    
    if (editType == noneEditType) {
        self.selectBut.hidden = YES;
    }
    else if (editType == defalutEditType){
        self.selectBut.hidden = NO;
        self.selectBut.selected = NO;
    }
    else if (editType == allSelectEditType){
        self.selectBut.hidden = NO;
        self.selectBut.selected = YES;
    }
    
}

- (IBAction)selectImageVClick:(UIButton *)sender {
    
    if (self.model) {
        sender.selected = !sender.selected;
        self.photoSelectBlock(self.model, sender.selected);
    }
    else{
        
        if (sender.selected) {
            sender.selected = !sender.selected;
            self.photoSelectAssetBlock(self.asset, sender.selected);
            return;
        }
        
        sender.selected = !sender.selected;
        self.photoSelectAssetBlock(self.asset, sender.selected);
    }
}


-(NSString *)changeIntToString:(int)secend{
    
    NSString * mString = @"";
    NSString * sString = @"";
    NSInteger m = secend / 60;
    if(m==0){
        mString = @"00";
    }
    else{
        mString = [NSString stringWithFormat:@"%ld" ,(long)m];
    }
    NSInteger s = secend % 60;
    if (s == 0) {
        sString = @"01";
    }
    else if(s < 10){
        sString = [NSString stringWithFormat:@"0%ld" ,(long)s];
    }
    else{
        sString = [NSString stringWithFormat:@"%ld" ,(long)s];
    }
    return [NSString stringWithFormat:@"%@:%@",mString , sString];
}

-(void)photoAllowEditMethod:(NSNotification *)noti{
    
    NSDictionary * dict = noti.object;
    self.isAllowEdit = [dict[@"edit"] boolValue];
    
}

@end
