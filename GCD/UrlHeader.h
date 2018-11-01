//
//  UrlHeader.h
//  GCD
//
//  Created by 张源远 on 2018/11/1.
//  Copyright © 2018年 张源远. All rights reserved.
//

#ifndef UrlHeader_h
#define UrlHeader_h

#define appUrl @"aaaaaaaaaaaa"

#define appUrlDev  @"bbbbbbbbbbbb"

#ifdef DEBUG
NSString * url = appUrlDev;
#else
NSString * url = appUrl;
#endif

#endif /* UrlHeader_h */

//这样其实也没有好到那里去
//这样每次打包的时候还是要选择debug还是release  还是没有好到那里去
