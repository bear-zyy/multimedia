//
//  MediaCameraVC.m
//  systemZyy
//
//  Created by 张源远 on 2018/7/10.
//  Copyright © 2018年 张源远. All rights reserved.
//

#import "MediaCameraVC.h"
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/CGImageProperties.h>

#import "FMDBManager.h"
#import "mediaModel.h"

@interface MediaCameraVC ()

@property (strong , nonatomic) AVCaptureStillImageOutput * stillImageOutput;

@property (strong , nonatomic) AVCaptureSession * session;

@property (strong, nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

@property (strong, nonatomic) AVCaptureDevice *videoCaptureDevice;
@property (strong, nonatomic) AVCaptureDeviceInput *videoDeviceInput;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIView *baseView;


@property(nonatomic,strong) AVPlayer * player;
@property (nonatomic, retain) AVPlayerItem   *currentItem;
@property (nonatomic,retain ) AVPlayerLayer  *playerLayer;


@end

@implementation MediaCameraVC

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton * but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(100, 320, 100, 50);
    [but setTitle:@"旋转摄像头" forState:UIControlStateNormal];
    [but setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
    
    UIButton * but2 = [UIButton buttonWithType:UIButtonTypeCustom];
    but2.frame = CGRectMake(220, 320, 100, 50);
    [but2 setTitle:@"拍照" forState:UIControlStateNormal];
    [but2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [but2 addTarget:self action:@selector(kakaka) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but2];
    
    [self.session startRunning];
}
//存
-(void)hahahah{
    
    mediaModel * model = [[mediaModel alloc] init];
//    model.ID = @"";
    [[FMDBManager shareManager] insertMediaData:model];
    
}
//旋转
-(void)heheheh{
    
    NSArray * arr = [[FMDBManager shareManager] selectAllMediaTableData];
    
    for (int i=0; i< arr.count; i++) {
        mediaModel * model = arr[i];
        
        if (model.type == 1) {
            UIImageView * imageV = [[UIImageView alloc] init];
            imageV.image = [UIImage imageWithData:model.data];
            [self.view addSubview:imageV];
            imageV.frame = CGRectMake(i * 120, 500, 100, 100);
        }
        else if (model.type == 2){
            
            self.player = [AVPlayer playerWithURL:[NSURL URLWithString:model.playUrl]];
            self.player.usesExternalPlaybackWhileExternalScreenIsActive=YES;
            self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
            self.playerLayer.frame = self.baseView.layer.bounds;
            [self.baseView.layer insertSublayer:_playerLayer atIndex:0];
            [self.player play];
            
        }
    }
}

-(void)kakaka{
    
    AVCaptureConnection *videoConnection = [self captureConnection];
    videoConnection.videoOrientation = [self orientationForConnection];
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef  _Nullable imageDataSampleBuffer, NSError * _Nullable error) {
        
        UIImage *image = nil;
        NSDictionary *metadata = nil;
        
        // check if we got the image buffer
        if (imageDataSampleBuffer != NULL) {
            CFDictionaryRef exifAttachments = CMGetAttachment(imageDataSampleBuffer, kCGImagePropertyExifDictionary, NULL);
            if(exifAttachments) {
                metadata = (__bridge NSDictionary*)exifAttachments;
            }
            
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            image = [[UIImage alloc] initWithData:imageData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = image;
            });
        }
    }];
    
}

- (AVCaptureConnection *)captureConnection
{
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    
    return videoConnection;
}


-(void)click{
    
    [self.session beginConfiguration];
    
    [self.session removeInput:self.videoDeviceInput];
    
    AVCaptureDevice *device = nil;
    if(self.videoDeviceInput.device.position == AVCaptureDevicePositionBack) {
        device = [self cameraWithPosition:AVCaptureDevicePositionFront];
    } else {
        device = [self cameraWithPosition:AVCaptureDevicePositionBack];
    }
    
    if(!device) {
        return;
    }
    
    // add input to session
    NSError *error = nil;
    AVCaptureDeviceInput *videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if(error) {
        [self.session commitConfiguration];
        return;
    }
    
    [self.session addInput:videoInput];
    [self.session commitConfiguration];
    
    self.videoCaptureDevice = device;
    self.videoDeviceInput = videoInput;
    
}

-(AVCaptureSession *)session{
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
        _session.sessionPreset = AVCaptureSessionPresetHigh;
        
        CGRect bounds = self.baseView.layer.bounds;
        //AVLayerVideoGravityResizeAspect  UI画面适配摄像头 , UI画面显示的是等比例的图片，
        //AVLayerVideoGravityResizeAspectFill  UI画面 显示占满，等比例，显示不一定全
        //AVLayerVideoGravityResize   压缩图片，全都显示在UI画面中
        _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _captureVideoPreviewLayer.bounds = bounds;
        _captureVideoPreviewLayer.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
        [self.baseView.layer addSublayer:_captureVideoPreviewLayer];
        
        self.videoCaptureDevice = [self cameraWithPosition:AVCaptureDevicePositionBack];
        
        NSError *error = nil;
        _videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_videoCaptureDevice error:&error];
        
        if([_session canAddInput:_videoDeviceInput]) {
            [_session  addInput:_videoDeviceInput];
            self.captureVideoPreviewLayer.connection.videoOrientation = [self orientationForConnection];
        }
        
        self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey,[NSNumber numberWithInt:230] , AVVideoHeightKey , [NSNumber numberWithInt:230], AVVideoWidthKey , nil];
        [self.stillImageOutput setOutputSettings:outputSettings];
        [self.session addOutput:self.stillImageOutput];
        
    }
    return _session;
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) return device;
    }
    return nil;
}

+ (BOOL)isFrontCameraAvailable
{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

+ (BOOL)isRearCameraAvailable
{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (AVCaptureVideoOrientation)orientationForConnection
{
    AVCaptureVideoOrientation videoOrientation = AVCaptureVideoOrientationPortrait;
    
//    if(self.useDeviceOrientation) {
//        switch ([UIDevice currentDevice].orientation) {
//            case UIDeviceOrientationLandscapeLeft:
//                // yes to the right, this is not bug!
//                videoOrientation = AVCaptureVideoOrientationLandscapeRight;
//                break;
//            case UIDeviceOrientationLandscapeRight:
//                videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
//                break;
//            case UIDeviceOrientationPortraitUpsideDown:
//                videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
//                break;
//            default:
//                videoOrientation = AVCaptureVideoOrientationPortrait;
//                break;
//        }
//    }
//    else {
//        switch ([[UIApplication sharedApplication] statusBarOrientation]) {
//            case UIInterfaceOrientationLandscapeLeft:
//                videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
//                break;
//            case UIInterfaceOrientationLandscapeRight:
//                videoOrientation = AVCaptureVideoOrientationLandscapeRight;
//                break;
//            case UIInterfaceOrientationPortraitUpsideDown:
//                videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
//                break;
//            default:
//                videoOrientation = AVCaptureVideoOrientationPortrait;
//                break;
//        }
//    }
    
    return videoOrientation;
}

- (IBAction)backClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)dealloc{
    [self.session stopRunning];
}

@end
