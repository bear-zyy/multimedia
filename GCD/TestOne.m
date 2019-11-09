//
//  TestOne.m
//  GCD
//
//  Created by zyy on 2019/9/25.
//  Copyright © 2019年 张源远. All rights reserved.
//

#import "TestOne.h"
#import "TestOne+three.h"
#import <objc/runtime.h>

@interface TestOne()
{
    NSString * _propertyTwo;
}
@property (copy , nonatomic) NSString * propertyOne;

@end

@implementation TestOne

+(BOOL)resolveInstanceMethod:(SEL)sel{
    NSLog(@"sel ====  %@" , NSStringFromSelector(sel));
    
    if(sel == @selector(testResolve)){
        class_addMethod(self, sel, (IMP)hhahhah, "@@:");
        return YES;
    }
    
    return [super resolveInstanceMethod:sel];
}

id hhahhah(id self , SEL cmd){
    return @"hhahhah";
}

//第二步  返回一个指定了的对象来执行这个方法

//第三步。 转变对象来执行这个方法


+(TestOne*)shard{
    static TestOne * one = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        one = [[TestOne alloc] init];
        one.propertyOne = @"propertyOne";
        one->_propertyTwo = @"_propertyTwo";
    });
    return one;
}

+(void)load{
    NSLog(@"TestOne load");
}

+(void)initialize{
    NSLog(@"TestOne initialize");
}

-(void)extension{
    NSLog(@"extension");
}

-(void)oneMethod{
    
//    NSString * string = @"aaa";
//
//    self.wocao = string;
//
//    NSLog(@"self.wocao输出:%p,%@\\n", self.wocao,self.wocao);
//
//    self.wocao2 = string;
//    NSLog(@"self.wocao2输出:%p,%@\\n", self.wocao2,self.wocao2);
//
//
//    string = @"bbb";
//
//    self.wocao2 = @"ccc";
//
//    NSLog(@"self.wocao输出:%p,%@\\n", self.wocao,self.wocao);
//
//    NSLog(@"self.wocao2输出:%p,%@\\n", self.wocao2,self.wocao2);
    
//    self.strongMStr= [[NSMutableString alloc]initWithString:@"mstrOriginValue"];
//    self.aCopyMStr= self.strongMStr;
//    NSLog(@"strongMStr输出:%p,%@\\n",_strongMStr,_strongMStr);
//    NSLog(@"aCopyMStr输出:%p,%@\\n",_aCopyMStr,_aCopyMStr);
//    [self.strongMStr appendString:@"2"];
//    NSLog(@"strongMStr输出:%p,%@\\n",_strongMStr,_strongMStr);
//    NSLog(@"aCopyMStr输出:%p,%@\\n",_aCopyMStr,_aCopyMStr);
    
//    _strongMStr = [[NSMutableString alloc] initWithString:@"ddddd"];
//    self.wocao= self.strongMStr;
//    NSLog(@"strongMStr输出:%p,%@\\n",self.strongMStr,self.strongMStr);
//    NSLog(@"aCopyMStr输出:%p,%@\\n",_wocao,_wocao);
//    [self.strongMStr appendString:@"sssss"];
//    NSLog(@"strongMStr输出:%p,%@\\n",self.strongMStr,self.strongMStr);
//    NSLog(@"aCopyMStr输出:%p,%@\\n",_wocao,_wocao);
    
//    self.strongMStr = [[NSMutableString alloc]initWithString:@"mstrOriginValue"];
//    NSString * string = @"aadsdd";
//    self.wocao = string;
//    self.wocao2 = string;
//    self.aCopyMStr = string;
//    NSLog(@"aCopyMStr输出:%p,%@\\n",_wocao,_wocao);
//    NSLog(@"astrongMStr输出:%p,%@\\n",_wocao2,_wocao2);
//    NSLog(@"aCopyMStr输出:%p,%@\\n",_aCopyMStr,_aCopyMStr);
//    [self.strongMStr appendString:@"dddd"];
//    NSLog(@"aCopyMStr输出:%p,%@\\n",_wocao,_wocao);
//    NSLog(@"astrongMStr输出:%p,%@\\n",_wocao2,_wocao2);
//    NSLog(@"aCopyMStr输出:%p,%@\\n",_aCopyMStr,_aCopyMStr);
    
    NSMutableArray * array = [NSMutableArray arrayWithArray:@[@"1"]];
    
    self.copArray = array;
    self.strArray = array;
    NSLog(@"aCopyMStr输出:%p,%@\\n",_copArray,_copArray);
    NSLog(@"aCopyMStr输出:%p,%@\\n",_strArray,_strArray);
    [array addObject:@"2"];
    NSLog(@"aCopyMStr输出:%p,%@\\n",_copArray,_copArray);
    NSLog(@"aCopyMStr输出:%p,%@\\n",_strArray,_strArray);
    
    //如果是有引用的话， 最好是用copy这样，数据不会乱，但是存储空间会变大,copy是把数据从新g拷贝一份，放到另外的存储地址上，strong是对存储地址引用加1  weak是指向存储地址，但引用计数不加1 assgin 也一样
//    NSMutableString*mstrOrigin = [[NSMutableString alloc]initWithString:@"mstrOriginValue"];
//
//    self.aCopyMStr= mstrOrigin;
//    self.strongMStr= mstrOrigin;
//    self.assignMStr = mstrOrigin;
//    self.weakMStr= mstrOrigin;
//
//    NSLog(@"mstrOrigin输出:%p,%@\\n", mstrOrigin,mstrOrigin);
//    NSLog(@"aCopyMStr输出:%p,%@\\n",_aCopyMStr,_aCopyMStr);
//    NSLog(@"strongMStr输出:%p,%@\\n",_strongMStr,_strongMStr);
//    NSLog(@"weakMStr输出:%p,%@\\n",_weakMStr,_weakMStr);
//    NSLog(@"引用计数%@",[mstrOrigin valueForKey:@"retainCount"]);
////
//    [mstrOrigin appendString:@"1"];
//    NSLog(@"mstrOrigin输出:%p,%@\\n", mstrOrigin,mstrOrigin);
//    NSLog(@"aCopyMStr输出:%p,%@\\n",_aCopyMStr,_aCopyMStr);
//    NSLog(@"strongMStr输出:%p,%@\\n",_strongMStr,_strongMStr);
//    NSLog(@"weakMStr输出:%p,%@\\n",_weakMStr,_weakMStr);
    
}

-(void)twoMethod{
    
}

@end
