//
//  AppDelegate.m
//  WebView
//
//  Created by 周赞 on 16/8/4.
//  Copyright © 2016年 xubin. All rights reserved.
//
#import "FirstViewController.h"
#import "MyURLCache.h"
#import "MyURLProtocol.h"
#import "AppDelegate.h"
#import "CMBWebViewVC.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
//     协议管理了所有的http。接口请求如何过滤？
//    [NSURLProtocol registerClass:[MyURLProtocol class]];
    MyURLCache *URLCache = [[MyURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                         diskCapacity:20 * 1024 * 1024
                                                             diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[FirstViewController alloc] init]];
    
//    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[CMBWebViewVC alloc] initWithURLString:@"http://wap.baidu.com"]];
    
//    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[CMBWebViewVC alloc] initWithURLString:@"http://192.168.60.104:8020/iOSCookieTest/index.html"]];

//    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[CMBWebViewVC alloc] initWithURL:[NSURL URLWithString:@"http://wap.baidu.com"]]];
    
//    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[CMBWebViewVC alloc] initWithFileName:@"index"]];
    
//    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[CMBWebViewVC alloc] initWithFileStr:@"html/index"]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
