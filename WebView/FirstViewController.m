//
//  FirstViewController.m
//  WebView
//
//  Created by 周赞 on 16/8/10.
//  Copyright © 2016年 xubin. All rights reserved.
//

#import "FirstViewController.h"
#import "CMBWebViewVC.h"
@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)TEST:(id)sender {
    CMBWebViewVC *VC = [[CMBWebViewVC alloc] initWithURLString:@"http://192.168.60.104:8020/iOSCookieTest/test.html"];
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)INDEX:(id)sender {
    CMBWebViewVC *VC = [[CMBWebViewVC alloc] initWithURLString:@"http://192.168.60.104:8020/iOSCookieTest/index.html"];
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)LOCAL:(id)sender {
    CMBWebViewVC *VC = [[CMBWebViewVC alloc] initWithURLString:@"http://192.168.60.104:8020/test"];
    VC.Local = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
