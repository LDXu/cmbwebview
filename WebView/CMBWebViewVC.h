//
//  ViewController.h
//  WebView
//
//  Created by 周赞 on 16/8/4.
//  Copyright © 2016年 xubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMBWebViewVC : UIViewController
//暴露webview
@property (nonatomic,strong) UIWebView* CMBWebView;
@property (nonatomic, strong) NSURL *webUrl;
@property (nonatomic, assign) BOOL Local;
//nsurl      NSURL格式
- (instancetype)initWithURL:(NSURL *)url;
//url string 网址字符串
- (instancetype)initWithURLString:(NSString *)urlString;
//html文件名,不需要后缀       index
- (instancetype)initWithFileName:(NSString *)htmlName;
//html文件路径,不需要后缀      html/index
- (instancetype)initWithFileStr:(NSString *)FileStr;
@end

