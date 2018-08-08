//
//  AuthorizingAccessTool.m
//  systemZyy
//
//  Created by 张源远 on 2018/7/2.
//  Copyright © 2018年 张源远. All rights reserved.
//

#import "AuthorizingAccessTool.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <Contacts/Contacts.h>
#import <CoreLocation/CoreLocation.h>

#import "AppDelegate.h"

@interface AuthorizingAccessTool ()<CLLocationManagerDelegate>

@property (strong , nonatomic) CLLocationManager * manager;

@end

@implementation AuthorizingAccessTool

+(instancetype)shareAuthor{
    
    static AuthorizingAccessTool * authorTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        authorTool = [[AuthorizingAccessTool alloc] init];
    });
    return authorTool;
}

-(void)authorAccessCheck:(AuthorizingAccessType)authorType andAuthor:(AuthorizationStatus)authorStatus{
    
    switch (authorType) {
        case AuthorVideoType:
            [self authorVideoOrAudioCheckMethod:authorType authorBlock:authorStatus];
            break;
        case AuthorAudioType:
            [self authorVideoOrAudioCheckMethod:authorType authorBlock:authorStatus];
            break;
        case AuthorPhotosType:
            [self authorPhotosCheckMethod:authorStatus];
            break;
        case AuthorContactsType:
            [self authorContactsCheckMethod:authorStatus];
            break;
        case AuthorLocationType:
            [self authorLocationCheckMethod:authorStatus];
            break;
        case AuthorNotiType:
            
            break;
            
        default:
            break;
    }
    
}

//检测相机权限 和检查麦克风权限
-(void)authorVideoOrAudioCheckMethod:(AuthorizingAccessType)authorType authorBlock:(AuthorizationStatus)authorStatus{
    
    NSString * messageStr = authorType == AuthorVideoType ? @"前往设置-隐私-相机中开启权限!" :@"前往设置-隐私-麦克风中开启权限!";
    AVMediaType type = authorType == AuthorVideoType ? AVMediaTypeVideo : AVMediaTypeAudio;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block NSInteger isAuthor = 0;// 1 允许  0是不允许  2是第一次选择但是选择不允许
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:type];
    if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:type completionHandler:^(BOOL granted) {
            
            if (granted) {
                isAuthor = 1;
            }
            else{
                isAuthor = 2;
            }
            dispatch_semaphore_signal(semaphore);
        }];
    }
    else if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied){
        isAuthor = 0;
        dispatch_semaphore_signal(semaphore);
        
    }
    else{
        isAuthor = 1;
        dispatch_semaphore_signal(semaphore);
        
    }
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    if (isAuthor == 0) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:messageStr preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
                    if (@available(iOS 10.0, *)) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
                            
                        }];
                    } else {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    }
                }
                
            }];
            UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alert addAction:action];
            [alert addAction:action2];
            [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
        });
        authorStatus(NO);
    }
    else if(isAuthor == 1){
        authorStatus(YES);
    }
    else{
        authorStatus(NO);
    }
    
    
}

//检测相册权限
-(void)authorPhotosCheckMethod:(AuthorizationStatus)authorStatus{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block NSInteger isAuthor = 0;
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
            if (status == PHAuthorizationStatusAuthorized) {
                isAuthor = 1;
            }
            else{
                isAuthor = 2;
            }
            dispatch_semaphore_signal(semaphore);
        }];
    }
    else if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied){
        dispatch_semaphore_signal(semaphore);
        isAuthor = 0;
    }
    else{
        dispatch_semaphore_signal(semaphore);
        isAuthor = 1;
    }
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    if (isAuthor == 1) {//去打开相册
        authorStatus(YES);
    }
    else if(isAuthor == 0){//提示弹框
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"前往设置-隐私-相册中开启权限!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
                    if (@available(iOS 10.0, *)) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
                            
                        }];
                    } else {// iOS8-iOS9的跳转方法
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    }
                }
                
            }];
            UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alert addAction:action];
            [alert addAction:action2];
            [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
        });
        authorStatus(NO);
    }
    else{//2
        authorStatus(NO);
    }
}

//检查通讯录权限
-(void)authorContactsCheckMethod:(AuthorizationStatus)authorStatus{
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block BOOL isAuthor = NO;
    
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusNotDetermined) {
        CNContactStore * store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            isAuthor = granted;
            dispatch_semaphore_signal(semaphore);
        }];
    }
    else if (status == CNAuthorizationStatusRestricted || status == CNAuthorizationStatusDenied){
        isAuthor = NO;
        dispatch_semaphore_signal(semaphore);
    }
    else{
        isAuthor = YES;
        dispatch_semaphore_signal(semaphore);
    }
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    if (isAuthor) {
        authorStatus(YES);
    }
    else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"前往设置-隐私-通讯录中开启权限!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
                    if (@available(iOS 10.0, *)) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
                            
                        }];
                    } else {// iOS8-iOS9的跳转方法
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    }
                }
                
            }];
            UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alert addAction:action];
            [alert addAction:action2];
            [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
        });
        authorStatus(NO);
    }
}

-(void)authorLocationCheckMethod:(AuthorizationStatus)authorStatus{
    
    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block BOOL isAuthor = NO;
    
    if ([CLLocationManager locationServicesEnabled]) {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
            isAuthor = NO;
            dispatch_semaphore_signal(semaphore);
        }
        else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
            [_manager requestAlwaysAuthorization];
            [_manager requestWhenInUseAuthorization];
            
            dispatch_semaphore_signal(semaphore);
        }
        else{
            isAuthor = YES;
            dispatch_semaphore_signal(semaphore);
        }
    }
    else{
        isAuthor = NO;
        dispatch_semaphore_signal(semaphore);
    }
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    NSLog(@"授权状态改变");
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    NSLog(@"定位失败原因");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    NSLog(@"定位中....");
}



-(BOOL)checkDeviceModelIsSimulator{
    
    if (TARGET_IPHONE_SIMULATOR) {
        return YES;
    }
    else{
        return NO;
    }
    
    return YES;
}












@end
