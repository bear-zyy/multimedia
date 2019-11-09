//
//  AnimtionViewController.m
//  GCD
//
//  Created by zyy on 2019/10/21.
//  Copyright © 2019年 张源远. All rights reserved.
//

#import "AnimtionViewController.h"

@interface AnimtionViewController ()<CAAnimationDelegate>

@property (strong , nonatomic) UIImageView * imageV;

@end

@implementation AnimtionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton * but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(0, 0, 100, 40);
    [but setTitle:@"动画开始" forState:UIControlStateNormal];
    [but setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
    
    UIButton * butt = [UIButton buttonWithType:UIButtonTypeCustom];
    butt.frame = CGRectMake(200, 0, 100, 40);
    [butt setTitle:@"退出" forState:UIControlStateNormal];
    [butt setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [butt addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:butt];
    
    self.imageV = [[UIImageView alloc] init];
    self.imageV.frame = CGRectMake(100, 100, 100, 100);
    self.imageV.image = [UIImage imageNamed:@"icon_baojing"];
    [self.view addSubview:self.imageV];
    
}

-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)click{
    
//    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
//
//    animation.repeatCount = 10;
//
//    [animation setToValue:@"M_PI"];
//    //   ③.将动画添加到图层
//
//    [self.imageV.layer addAnimation:animation forKey:nil];
//
    
    CABasicAnimation * animate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];// 缩放
    
    //   ②.设置动画属性
    //   ②.1设置动画时长
    animate.duration = 0.6f;
    //   ②.2开始数值fromeValue  当前大小
    [animate setFromValue:@0.0];
    //   ②.3结束数值toValue     缩放大小
    [animate setToValue:@M_PI];
    //   ②.5设置填充模式
    animate.fillMode = kCAFillModeForwards;
    animate.removedOnCompletion = YES;
    //   ②.6速度效果控制函数
    [animate setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    
    animate.delegate = self;
    [animate setValue:@M_PI forKey:@"rotation"];
    [animate setValue:@"rotationchange" forKey:@"animationType"];
    
    [self.imageV.layer addAnimation:animate forKey:nil];
    
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];// 缩放
    
    //   ②.设置动画属性
    //   ②.1设置动画时长
    animation.duration = 0.6f;
    //   ②.2开始数值fromeValue  当前大小
    [animation setFromValue:[NSValue valueWithCGRect:CGRectMake(100, 100, 100, 100)]];
    //   ②.3结束数值toValue     缩放大小
    [animation setToValue:[NSValue valueWithCGRect:CGRectMake(250, 300, 100, 100)]];
    //   ②.5设置填充模式
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = YES;
    //   ②.6速度效果控制函数
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    
    animation.delegate = self;
    [animation setValue:[NSValue valueWithCGRect:CGRectMake(250, 300, 100, 100)] forKey:@"position"];
    [animation setValue:@"positionchange" forKey:@"animationType"];
    
    [self.imageV.layer addAnimation:animation forKey:nil];
    
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSLog(@"%@" , [anim valueForKey:@"animationType"]);
    NSString * type = [anim valueForKey:@"animationType"];
    if ([type isEqualToString:@"rotationchange"]) {
        NSLog(@"%@" , [anim valueForKey:@"rotation"]);
        CGFloat a = [[anim valueForKey:@"rotation"] floatValue];
        [self.imageV setTransform:CGAffineTransformMakeRotation(a)];
    }
    else if ([type isEqualToString:@"positionchange"]){
        CGRect rect= [[anim valueForKey:@"position"]CGRectValue];
        self.imageV.frame =rect;
    }
}

@end
