//
//  ViewController.m
//  GCD
//
//  Created by 张源远 on 2018/5/16.
//  Copyright © 2018年 张源远. All rights reserved.
//

#import "ViewController.h"
#import "SemaphoreViewController.h"
#import "PureCamera.h"
#import "UIImage+FixOrientation.h"
#import "MediaCameraVC.h"
#import <Photos/Photos.h>
#import<MobileCoreServices/MobileCoreServices.h>
#import "PhotosViewController.h"
#import "mediaModel.h"
#import "FMDBManager.h"
#import "StoreViewController.h"

#include <sys/param.h>
#include <sys/mount.h>

#import "AuthorizingAccessTool.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource , UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (strong , nonatomic) NSArray * array;


@property (strong , nonatomic) NSMutableArray * photosArr;

@property(nonatomic,strong) UIImagePickerController *imagePicker;

@property (strong , nonatomic) UIImageView * imageView;

@property(nonatomic,strong) AVPlayer * player;

@property (nonatomic, retain) AVPlayerItem   *currentItem;

@property (nonatomic,retain ) AVPlayerLayer  *playerLayer;


@property (strong , nonatomic) UIView * playBGView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0) {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_bavail);
    }
    NSString *str = [NSString stringWithFormat:@"手机剩余存储空间为：%0.2lld MB",freeSpace/1024/1024];
    
    NSLog(@"%@" , str);//手机剩余存储空间为：5101 MB
    
    self.array = @[@"串行对列",@"查看拍摄的照片和视频",@"第三方拍照",@"拍照" , @"系统相机", @"查看系统相册",@"存取速度"];
    [self.tableview reloadData];
    
    self.imageView = [[UIImageView alloc] init];
    [self.view addSubview:self.imageView];
    self.imageView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 200) / 2.0, 400, 200, 200);
    
    self.playBGView = [[UIView alloc] init];
    [self.view addSubview:self.playBGView];
    self.playBGView.frame = CGRectMake(20, 500, 200, 200);
    
    //如果说  我是进行网络请求，比如组的数据
    // Do any additional setup after loading the view, typically from a nib.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"aaa"];
    cell.detailTextLabel.text = self.array[indexPath.row];
    cell.textLabel.text =self.array[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak typeof (self) weakSelf = self;
    
    if (indexPath.row == 0) {
        SemaphoreViewController * vc = [SemaphoreViewController new];
        [self presentViewController:vc animated:YES completion:nil];
    }
    else if (indexPath.row == 1){
        PhotosViewController * vc = [PhotosViewController new];
        vc.opreationType = localVCType;
        [self presentViewController:vc animated:YES completion:nil];
        
    }
    if (indexPath.row == 2) {
        
        if ([[AuthorizingAccessTool shareAuthor] checkDeviceModelIsSimulator]) {
            NSLog(@"模拟器不支持当前功能");
            return;
        }
        
        PureCamera *homec = [[PureCamera alloc] init];
        __weak typeof(self) myself = self;
        homec.fininshcapture = ^(UIImage *ss) {
            if (ss) {
                NSLog(@"照片存在");
                
                ss= ss.fixOrientation;
                [self.photosArr addObject:[self createDicImage:ss]];
            }
        };
        [myself presentViewController:homec
                             animated:NO
                           completion:^{
                           }];
    }
    else if(indexPath.row == 3){//拍照  获取照片
        
        if ([[AuthorizingAccessTool shareAuthor] checkDeviceModelIsSimulator]) {
            NSLog(@"模拟器不支持当前功能");
            return;
        }
        
        [[AuthorizingAccessTool shareAuthor] authorAccessCheck:AuthorVideoType andAuthor:^(BOOL granted) {
            
            if (granted) {
                MediaCameraVC * vc = [MediaCameraVC new];
                [weakSelf presentViewController:vc animated:YES completion:nil];
            }
        }];

    }else if(indexPath.row == 4){
        
        if ([[AuthorizingAccessTool shareAuthor] checkDeviceModelIsSimulator]) {
            NSLog(@"模拟器不支持当前功能");
            return;
        }
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        __block BOOL isAuthor = NO;
        [[AuthorizingAccessTool shareAuthor] authorAccessCheck:AuthorVideoType andAuthor:^(BOOL granted) {
            isAuthor = granted;
            dispatch_semaphore_signal(semaphore);
            
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        if (!isAuthor) {
            return;
        }
        
        dispatch_semaphore_t semaphoreTwo = dispatch_semaphore_create(0);
        [[AuthorizingAccessTool shareAuthor] authorAccessCheck:AuthorAudioType andAuthor:^(BOOL granted) {
            isAuthor = granted;
            dispatch_semaphore_signal(semaphoreTwo);
            
        }];
        dispatch_semaphore_wait(semaphoreTwo, DISPATCH_TIME_FOREVER);
        if (!isAuthor) {
            return;
        }
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self; //设置代理
        imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerController animated:YES completion:nil];
        
    }
    else if (indexPath.row == 5){
        PhotosViewController * vc = [PhotosViewController new];
        vc.opreationType = systemVCType;
        [self presentViewController:[PhotosViewController new] animated:YES completion:nil];
    }
    else if (indexPath.row == 6){
        [self presentViewController:[StoreViewController new] animated:YES completion:nil];
    }
}

#pragma mark -实现图片选择器代理-（上传图片的网络请求也是在这个方法里面进行，这里我不再介绍具体怎么上传图片）
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    NSString * type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage]; //通过key值获取到图片
        self.imageView.image = image;
        
//        NSData * data = UIImagePNGRepresentation(image);
        NSData * data = UIImageJPEGRepresentation(image, 1.0);
        mediaModel * model = [[mediaModel alloc] init];
        model.data = data;
        model.type = 1;
        model.ID = [self getCreateTime];
        [[FMDBManager shareManager] insertMediaData:model];
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            NSLog(@"success = %d, error = %@", success, error);
        }];
    }
    else if ([type isEqualToString:@"public.movie"]){
        
        NSURL * url = [info objectForKey:UIImagePickerControllerMediaURL];
        NSString * playerString = [url absoluteString];
        
        
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        
        NSFileManager * fileManger = [NSFileManager defaultManager];
        
        NSString * timestamp = [self getCreateTimestamp];
        [fileManger createFileAtPath:[path stringByAppendingString:[NSString stringWithFormat:@"/%@.MP4",timestamp]] contents:[NSData dataWithContentsOfFile:playerString] attributes:nil];

        
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
        AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        assetGen.appliesPreferredTrackTransform = YES;
        CMTime time = CMTimeMakeWithSeconds(0.0, 600);
        NSError *error = nil;
        CMTime actualTime;
        CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
        UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
        CGImageRelease(image);
        NSData * data = UIImageJPEGRepresentation(videoImage, 1.0);
        
        NSUInteger second = 0;
        second = asset.duration.value / asset.duration.timescale;
        
        mediaModel * model = [[mediaModel alloc] init];
        model.type = 2;
        model.playUrl = [NSString stringWithFormat:@"%@.MP4",timestamp];;
        model.data = data;
        model.ID = [self getCreateTime];
        [[FMDBManager shareManager] insertMediaData:model];
        
        self.imageView.image = videoImage;
    }
    
    
    //上传图片到服务器--在这里进行图片上传的网络请求，这里不再介绍
//    ......
}

-(NSString *)getCreateTime{
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy:MM:dd-HH:mm:ss:SSS";
    NSString * string = [formatter stringFromDate:[NSDate date]];
    return string;
    
}

//当用户取消选择的时候，调用该方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

-(NSMutableArray *)photosArr{
    if (!_photosArr) {
        _photosArr = [NSMutableArray array];
    }
    return _photosArr;
}

-(NSDictionary *)createDicImage:(UIImage *)image
{
    NSString*imgSize = NSStringFromCGSize(image.size);
    NSArray *allArr = [imgSize componentsSeparatedByString:@","];
    NSArray *firstArr = [allArr[0] componentsSeparatedByString:@"{"];
    NSArray *secondArr = [allArr[1] componentsSeparatedByString:@"}"];
    //宽
    CGFloat width = [firstArr[1] floatValue];
    //高
    CGFloat height = [secondArr[0] floatValue];
    if (width>720.0) {
        height = height*720.0/width;
        width = 720.0;
    }
    NSDictionary *dic = @{@"image":image};
    return dic;
}

-(NSString *)getCreateTimestamp{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
}


@end
