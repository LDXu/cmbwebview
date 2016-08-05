//
//  ViewController.m
//  WebView
//
//  Created by 周赞 on 16/8/4.
//  Copyright © 2016年 xubin. All rights reserved.
//
#import "ZTQuickControl.h"
#import "CMBWebViewVC.h"
#import "TestViewController.h"
@interface CMBWebViewVC ()<UIWebViewDelegate>
{
    BOOL hasError;
    BOOL isFile;
}
//原项目不改动，隐藏导航栏。放置一个view
@property (nonatomic,strong) UIView* NavView;
//标题栏
@property (nonatomic,strong) UILabel* TitleLabel;
//四个按钮
@property (nonatomic,strong) UIButton* left_First;
@property (nonatomic,strong) UIButton* left_Second;
@property (nonatomic,strong) UIButton* right_First;
@property (nonatomic,strong) UIButton* right_Second;
//页码，考虑了暂不使用，监控比较坑
@property (nonatomic,assign) NSInteger page_Index;
//本地网页，托入不编译。文件名路径注意
@property (nonatomic,strong) NSURL *baseURL;
@property (nonatomic,strong) NSString *htmlPath;
@property (nonatomic,strong) NSString *basePath;
@end

@implementation CMBWebViewVC

- (instancetype)initWithURL:(NSURL *)url;{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _webUrl = url;
    }
    return self;
}

- (instancetype)initWithURLString:(NSString *)urlString{
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (instancetype)initWithFileName:(NSString *)htmlName{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        if (htmlName.length) {
            isFile = YES;
            _htmlPath = [NSString stringWithFormat:@"%@/%@.html",self.basePath,htmlName];
            NSString *htmlString = [NSString stringWithContentsOfFile:_htmlPath
                                                            encoding:NSUTF8StringEncoding error:nil];
            [self.CMBWebView loadHTMLString:htmlString baseURL:self.baseURL];
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)loadView {
    [super loadView];
    [self.view addSubview:self.NavView];
    [self.view addSubview:self.CMBWebView];
    [self.NavView addSubview:self.TitleLabel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createNavRight_First];
    [self createNavLeft_First];
    if (!isFile) {
        [self.CMBWebView loadRequest:[NSURLRequest requestWithURL:self.webUrl]];
    }else{
        [self.CMBWebView loadRequest:[NSURLRequest requestWithURL:self.webUrl]];
    }
    

    // Do any additional setup after loading the view, typically from a nib.
}


- (void)createNavRight_First{

    [self.NavView addSubview:self.right_First];
    
}

- (void)createNavRight_Second{
    
    [self.NavView addSubview:self.right_Second];
   
}

- (void)createNavLeft_First{
    
    [self.NavView addSubview:self.left_First];

}

- (void)createNavLeft_Second{

    [self.NavView addSubview:self.left_Second];
    
}

- (void)reload{
    
    if (hasError) {
        if (isFile) {
            NSString *htmlString = [NSString stringWithContentsOfFile:_htmlPath
                                                             encoding:NSUTF8StringEncoding error:nil];
            [self.CMBWebView loadHTMLString:htmlString baseURL:_baseURL];
        }else{
            [self.CMBWebView loadRequest:[NSURLRequest requestWithURL:self.webUrl]];
        }
    }else{
        [self.CMBWebView reload];
    }

}

- (void)goBack{

    if ([self.CMBWebView canGoBack]) {
        [self.CMBWebView goBack];
    }

}

- (void)goForward{

    if ([self.CMBWebView canGoForward]) {
        [self.CMBWebView goForward];
    }

}

- (void)close{

    if (self.navigationController && self.navigationController.viewControllers.count != 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)stoploading{

    if ([self.CMBWebView isLoading]) {
        [self.CMBWebView stopLoading];
    }

}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    // 得到网址
    NSString * url = request.URL.absoluteString;

    // 定义的协议(登录协议)
    NSString *scheme = @"cmb://";
    // url的前缀是不是 xdios://
    if ([url hasPrefix:scheme]) {
        NSLog(@"%@",url);
        // 得到要跳的方法名  这边需要结合urlmanager分支／
        //        NSString *path = [url substringFromIndex:scheme.length];
        //跳转方法
        //        [self performSelector:NSSelectorFromString(path)];
        return NO;
    }
    
    if ([url  containsString:@"baidu"] || [url  containsString:@"exchange_list.html"]  || [url  containsString:@"detail.html"] || [url  containsString:@"list.html"]) {
        TestViewController * vc = [[TestViewController  alloc] init];
        vc.webUrl = [NSURL URLWithString:@"http://m.taobao.com"];
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }
    
    
    NSLog(@"init url: %@\n current url: %@", self.webUrl.absoluteString, request.URL.absoluteString);
    if ([webView canGoBack]) {
        [self createNavLeft_Second];
    }else{
        [self.left_Second removeFromSuperview];
        self.left_Second = nil;
    }
    if ([webView canGoForward]) {
        [self createNavRight_Second];
    }else{
        [self.right_Second removeFromSuperview];
        self.right_Second = nil;
    }
    hasError = NO;
    return YES;
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self getWebViewTitle];
    

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"加载失败%@",error);
    hasError = YES;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)getWebViewTitle {
    NSString *title = [self.CMBWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.TitleLabel.text = title;
}

#pragma mark - Getters 懒加载
- (UIView *)NavView{
    if (!_NavView) {
        _NavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
        _NavView.backgroundColor = kbluemainColor;
    }
    return _NavView;
}

- (UILabel *)TitleLabel{
    if (!_TitleLabel) {
        _TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-180, 44)];
        CGPoint label_center = _NavView.center;
        _TitleLabel.center = CGPointMake(label_center.x, label_center.y+10);
        _TitleLabel.backgroundColor = [UIColor clearColor];
        _TitleLabel.textColor = [UIColor whiteColor];
        _TitleLabel.textAlignment = NSTextAlignmentCenter;
        _TitleLabel.font = [UIFont systemFontOfSize:14];
        _TitleLabel.numberOfLines = 0;
    }
    return _TitleLabel;
}

- (UIWebView *)CMBWebView{
    if(!_CMBWebView) {
        _CMBWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
        _CMBWebView.delegate = self;
        _CMBWebView.scalesPageToFit = YES;
        _CMBWebView.autoresizesSubviews = YES;
        _CMBWebView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
        _CMBWebView.scrollView.alwaysBounceVertical = YES;
    }
    return _CMBWebView;
}

- (NSString*)basePath{
    if (!_basePath) {
        NSString *mainBundlePath = [[NSBundle mainBundle] bundlePath];
        _basePath = [NSString stringWithFormat:@"%@/cloudstore__spa/html/jhb",mainBundlePath];
    }
    return _basePath;
}

- (NSURL*)baseURL{
    if (!_baseURL) {
        _baseURL = [NSURL fileURLWithPath:self.basePath isDirectory:YES];
    }
    return _baseURL;
}

- (UIButton*)left_First{
    if(!_left_First) {
        __weak typeof(self) myself_ = self;
        _left_First =
        [UIButton imageButtonWithFrame:CGRectMake(10, 20, 40, 40) title:nil image:@"关闭" action:^(ZTButton *button) {
            [myself_ close];
        }];
    }
    return _left_First;
}

- (UIButton*)left_Second{
    if(!_left_Second) {
        __weak typeof(self) myself_ = self;
        _left_Second =
        [UIButton imageButtonWithFrame:CGRectMake(50, 20, 40, 40) title:nil image:@"返回" action:^(ZTButton *button) {
            [myself_ goBack];
        }];
    }
    return _left_Second;
}

- (UIButton*)right_First{
    if(!_right_First) {
        __weak typeof(self) myself_ = self;
        _right_First =
        [UIButton imageButtonWithFrame:CGRectMake(kScreenWidth - 50, 20, 40, 40) title:nil image:@"刷新" action:^(ZTButton *button) {
            [myself_ reload];
        }];
    }
    return _right_First;
}

- (UIButton*)right_Second{
    if(!_right_Second) {
        __weak typeof(self) myself_ = self;
        _right_Second =
        [UIButton imageButtonWithFrame:CGRectMake(kScreenWidth - 90, 20, 40, 40) title:nil image:@"前进" action:^(ZTButton *button) {
            [myself_ goForward];
        }];
    }
    return _right_Second;
}

#pragma mark - cookie设置（也可以提前设定好，http请求就可以。仅限webview。wkwebview比较坑）
- (void)setCookie{

    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:@"CMBNSHTTPCookieName" forKey:NSHTTPCookieName];
    [cookieProperties setObject:@"CMBNSHTTPCookieValue" forKey:NSHTTPCookieValue];
    [cookieProperties setObject:@"CMBNSHTTPCookieDomain" forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:@"CMBNSHTTPCookieOriginURL" forKey:NSHTTPCookieOriginURL];
    [cookieProperties setObject:@"CMBNSHTTPCookiePath" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:@"CMBNSHTTPCookieVersion" forKey:NSHTTPCookieVersion];
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];

}

- (void)testCookie{
    
    [self setCookie];
    NSString *urlAddress = @"http://blog.toright.com/cookie.php";
    NSURL *myurl = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:myurl];
    [self.CMBWebView loadRequest:requestObj];

}

- (void)showCookie{

    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        NSLog(@"%@", cookie);
    }

}

- (void)delCookie{

    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *_tmpArray = [NSArray arrayWithArray:[cookieJar cookies]];
    for (id obj in _tmpArray) {
        [cookieJar deleteCookie:obj];
    }

}

- (void)dealloc {
    self.CMBWebView.delegate = nil;
    [self.CMBWebView stopLoading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
