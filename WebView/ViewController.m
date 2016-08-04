//
//  ViewController.m
//  WebView
//
//  Created by 周赞 on 16/8/4.
//  Copyright © 2016年 xubin. All rights reserved.
//
#import "ZTQuickControl.h"
#import "ViewController.h"

@interface ViewController ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView* CMBWebView;
@property (nonatomic,strong) UIView* NavView;
@property (nonatomic,strong) UILabel* TitleLabel;
@property (nonatomic,strong) UIButton* left_First;
@property (nonatomic,strong) UIButton* left_Second;
@property (nonatomic,strong) UIButton* right_First;
@property (nonatomic,strong) UIButton* right_Second;
@property (nonatomic,assign) NSInteger page_Index;
@end

@implementation ViewController

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
    _page_Index = 0;
    [self createNavRight_First];
    [self createNavLeft_First];
    [self.CMBWebView loadRequest:[NSURLRequest requestWithURL:self.webUrl]];
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
    
    [self.CMBWebView reload];

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

- (void)dealloc {
    self.CMBWebView.delegate = nil;
    [self.CMBWebView stopLoading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
