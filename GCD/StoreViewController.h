//
//  StoreViewController.h
//  GCD
//
//  Created by 张源远 on 2018/10/31.
//  Copyright © 2018年 张源远. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) 
#endif

@interface StoreViewController : UIViewController

extern NSString * const stringC;

@end

NS_ASSUME_NONNULL_END
