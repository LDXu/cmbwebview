//
//  Header.h
//  WebView
//
//  Created by 周赞 on 16/8/4.
//  Copyright © 2016年 xubin. All rights reserved.
//
#define kFrame [UIScreen mainScreen].bounds
#define kUIColorFromHex(s) [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1.0]
#define RGBACOLOR(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define mainColor [UIColor colorWithRed:88/255.0 green:193/255.0 blue:246/255.0 alpha:1.0]
#define kbluemainColor [UIColor colorWithRed:45/255.0 green:195/255.0 blue:255/255.0 alpha:1.0]
#define kbackmainColor [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0]
#define kyellowColor [UIColor colorWithRed:240/255.0 green:187/255.0 blue:14/255.0 alpha:1.0]
#define korangeColor [UIColor colorWithRed:250/255.0 green:102/255.0 blue:84/255.0 alpha:1.0]
#define kGrayColor [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0]
#define kGreenColor [UIColor colorWithRed:0/255.0 green:183/255.0 blue:0/255.0 alpha:1.0]
#define syBlueColor [UIColor colorWithRed:0.35 green:0.76 blue:0.96 alpha:1]
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750,1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,960), [[UIScreen mainScreen] currentMode].size) : NO)
#define APPDEL ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define kScreenWidth [UIScreen mainScreen].bounds.size.width//屏幕的宽度
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height//屏幕的高度
#define kNav_H kScreenHeight > 668 ? 86 : 64//屏幕的高度
#define kTabbar_H kScreenHeight > 668 ? 59 : 49//屏幕的高度
//判断当前系统版本是否ios7
#define IOS7_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#ifndef Header_h
#define Header_h


#endif /* Header_h */
