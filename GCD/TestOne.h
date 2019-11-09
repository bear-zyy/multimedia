//
//  TestOne.h
//  GCD
//
//  Created by zyy on 2019/9/25.
//  Copyright © 2019年 张源远. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^aaaaa) (void);

@interface TestOne : NSObject

@property(copy,nonatomic)NSMutableString * aCopyMStr;

@property(strong,nonatomic)NSMutableString * strongMStr;

@property(weak,nonatomic)NSMutableString * weakMStr;

@property(assign,nonatomic)NSMutableString * assignMStr;

@property (copy , nonatomic) NSString * wocao;//

@property (strong , nonatomic) NSString * wocao2;

@property (strong , nonatomic) NSString * wocao3;

@property (copy , nonatomic) NSArray * copArray;

@property (strong , nonatomic) NSArray * strArray;

+(TestOne *)shard;

@property (weak, nonatomic) aaaaa block;

-(void)oneMethod;

-(void)testResolve;

@end

NS_ASSUME_NONNULL_END
