//
//  PhotosViewController.m
//  ZhiKeTong
//
//  Created by 张源远 on 2018/7/12.
//  Copyright © 2018年 zonekey. All rights reserved.
//

#import "PhotosViewController.h"
#import "FMDBManager.h"
#import "PhotosCollectionCell.h"
#import <Photos/Photos.h>
#import "PHAsset+Edit.h"

@interface PhotosViewController ()<UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong , nonatomic) NSMutableArray * dataArray;

@property (strong , nonatomic) NSMutableArray * selectArray;

@property (weak, nonatomic) IBOutlet UIButton *deleteBut;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteButHight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionBottomHight;

@property (strong , nonatomic) UIButton * leftBut;
@property (strong , nonatomic) UIButton * rightBut;

@property (assign , nonatomic) photosEditType editType;

@property (nonatomic, strong) PHCachingImageManager *imageManager;

@end

static NSString * photosCellID = @"PhotosCollectionCell";

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.collectionView registerNib:[UINib nibWithNibName:photosCellID bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:photosCellID];

    [self setNav];
    self.editType = noneEditType;
    if (self.opreationType == localVCType) {
        self.dataArray = [NSMutableArray arrayWithArray: [[FMDBManager shareManager] selectAllMediaTableData]];
        [self.collectionView reloadData];
    }
    else{
        self.dataArray = [NSMutableArray array];
        [self requestSystemPhotos];
    }
    
    self.collectionBottomHight.constant = 0;
    
}

-(void)setSystemNav{
    
    
}
-(void)rightSystemBarItemClick{
    
}

-(void)setNav{
    
    
}

-(void)leftBarItemClick{
}

-(void)rightBarItemClick:(UIButton *)but{
    
}

-(void)requestSystemPhotos{
    
    __weak typeof(self) weakSelf = self;
    self.imageManager = [[PHCachingImageManager alloc]init];
    dispatch_async(dispatch_get_main_queue(), ^{
        // 列出所有相册智能相册
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        
        if (smartAlbums.count != 0) {
            
            //获取资源时的参数
            PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
            //按时间排序
            allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
            //所有照片
            PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
            
            for (int i=0; i < allPhotos.count; i++) {
                PHAsset * asset = allPhotos[i];
//                if (asset.mediaType == PHAssetMediaTypeImage) {
                    [weakSelf.dataArray addObject:asset];
                    
//                }
            }
            [weakSelf.collectionView reloadData];
        }
    });
    
}

- (IBAction)deleteClick:(UIButton *)sender {
    
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定要删除本地图片吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[FMDBManager shareManager] deletaMediaTableData:self.selectArray];
        
        [self.dataArray removeObjectsInArray:self.selectArray];
        
        [self.collectionView reloadData];
    }];
    [controller addAction:action];
    [controller addAction:action2];
    
    [self presentViewController:controller animated:YES completion:nil];
    
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotosCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:photosCellID forIndexPath:indexPath];
    
    if(!cell){
        cell = [[NSBundle mainBundle] loadNibNamed:photosCellID owner:self options:nil].firstObject;
    }
    
    __weak typeof(self) weakSelf = self;
    
    if (self.opreationType == localVCType) {
        cell.model = self.dataArray[indexPath.row];
        //     cell.editType = self.editType;
        
        cell.photoSelectBlock = ^(mediaModel *model, BOOL isSelected) {
            [weakSelf photoSelectMethod:model isSelect:isSelected];
        };
    }
    else{
        cell.asset = self.dataArray[indexPath.row];
    }
    
    
    return cell;
}

-(void)photoSelectAssetMethod:(PHAsset *)asset isSelect:(BOOL)isSelect{
    
    
}

-(void)photoSelectMethod:(mediaModel *)model isSelect:(BOOL)isSelect{
    
    if (isSelect) {//选择
        [self.selectArray addObject:model];
    }
    else{
        [self.selectArray removeObject:model];
        self.editType = defalutEditType;
    }
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width -30) / 4, ([UIScreen mainScreen].bounds.size.width -30) / 4);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}


-(NSMutableArray *)selectArray{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

- (IBAction)backClick:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)dealloc{
    
}

@end
