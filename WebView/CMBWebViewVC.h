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
- (instancetype)initWithURL:(NSURL *)url;
- (instancetype)initWithURLString:(NSString *)urlString;
//html文件名
- (instancetype)initWithFileName:(NSString *)htmlName;
@end

