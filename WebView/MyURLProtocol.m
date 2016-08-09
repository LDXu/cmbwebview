//
//  MyURLProtocol.m
//  WebViewTest
//
//  Created by sjpsega on 15/6/4.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import "MyURLProtocol.h"
//这个头必须加，防止请求重复，导致死循环
static NSString *WingTextURLHeader = @"Wing-Cache";

@implementation MyURLProtocol{
    NSURLConnection *_connection;
}


// 这个方法是注册后,NSURLProtocol就会通过这个方法确定参数request是否需要被处理
// return : YES 需要经过这个NSURLProtocol"协议" 的处理, NO 这个 协议request不需要遵守这个NSURLProtocol"协议"
// 这个方法的左右 : 1, 筛选Request是否需要遵守这个NSURLRequest , 2, 处理http: , https等URL
+(BOOL)canInitWithRequest:(NSURLRequest *)request{
//    NSLog(@"canInitWithRequest... : %@",request.URL.absoluteString);
    //看看是否已经处理过了，防止无限循环
    if([request valueForHTTPHeaderField:WingTextURLHeader]){
        return NO;
    }
    //只处理http和https请求
    NSString *scheme = [[request URL] scheme];
    NSLog(@"scheme%@",scheme);
    if ( ([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame || [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame||[scheme caseInsensitiveCompare:@"file"] == NSOrderedSame ))
    {
        //看看是否已经处理过了，防止无限循环
        if ([NSURLProtocol propertyForKey:WingTextURLHeader inRequest:request]) {
            return NO;
        }
        
        return YES;
    }
    //拦截js请求
    if([[request.URL.absoluteString pathExtension] rangeOfString:@"js"].location != NSNotFound){
        return YES;
    }
    return NO;
}

// 这个方法主要用来判断两个请求是否是同一个请求，
// 如果是，则可以使用缓存数据，通常只需要调用父类的实现即可,默认为YES,而且一般不在这里做事情
+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b{
    NSLog(@"requestIsCacheEquivalent a:%@\nb:%@",a,b);
    return [super requestIsCacheEquivalent:a toRequest:b];
}

// 这个方法就是返回request,当然这里可以处理的需求有 :
// 1,规范化请求头的信息 2, 处理DNS劫持,重定向App中所有的请求指向等
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request{
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    mutableReqeust = [self redirectHostInRequset:mutableReqeust];
    return mutableReqeust;
}

+(NSMutableURLRequest*)redirectHostInRequset:(NSMutableURLRequest*)request
{
    NSLog(@"request.URL host%@",[request.URL host]);
    if ([request.URL host].length == 0) {
        return request;
    }
    
    NSString *originUrlString = [request.URL absoluteString];
    NSString *originSchemeString = [request.URL scheme];
    NSString *originHostString = [request.URL host];
    NSRange hostRange = [originUrlString rangeOfString:originHostString];
    NSRange schemeRange = [originUrlString rangeOfString:originSchemeString];
    if (hostRange.location == NSNotFound||schemeRange.location == NSNotFound) {
        return request;
    }
    NSString *mainBundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *basePath = [NSString stringWithFormat:@"%@",mainBundlePath];
    NSString *scheme = @"file";
    //定向到bing搜索主页
    NSString *ip = @"cn.bing.com";
//    NSString *http_ip = @"http://wap.baidu.com";
    
    // 替换域名
    NSString *urlString = [originUrlString stringByReplacingCharactersInRange:hostRange withString:basePath];
    // 替换host
    NSString *hostUrlString = [urlString stringByReplacingCharactersInRange:schemeRange withString:scheme];
    NSURL *url = [NSURL URLWithString:hostUrlString];
    request.URL = url;
    
    return request;
}
//file:///var/containers/Bundle/Application/76C458D6-C0F3-44F2-9093-64C71E0866B2/WebView.app/html/index.html
//file:///var/containers/Bundle/Application/D1F8C960-668C-4E5E-BB57-AC4482EDCC86/WebView.app/html/index.html
// 需要在该方法中发起一个请求，对于NSURLConnection来说，就是创建一个NSURLConnection，对于NSURLSession，就是发起一个NSURLSessionTask
// 另外一点就是这个方法之后,会回调<NSURLProtocolClient>协议中的方法,
-(void)startLoading {
    NSLog(@"startLoading : %@",[self request].URL.absoluteString);
    
    if([[self request].URL.absoluteString hasPrefix:@"abc://xxx.com/index.js"]){
        NSLog(@"请求js...");
        
        //加载本地js数据
        NSString *indexJSPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"js"];
        NSData *indexJSData = [[NSData alloc] initWithContentsOfFile:indexJSPath];
        
        NSString *absoluteURLString = [self request].URL.absoluteString;
        //方式二：协议改成 http 或 https，测试有效，不缓存
        absoluteURLString = @"http://g.alicdn.com/sd/data_sufei/1.4.3/aplus/index.js";
        
        //测试一：后加随机字符串，测试无效，缓存依然存在
//        absoluteURLString = [NSString stringWithFormat:@"%@?%@", absoluteURLString, [NSString stringWithFormat:@"t=%i",arc4random()]];
        
        NSURL *url = [NSURL URLWithString:absoluteURLString];
        
        NSURLResponse* response =
        [[NSURLResponse alloc] initWithURL:url
                                  MIMEType:@"application/x-javascript"
                     expectedContentLength:indexJSData.length
                          textEncodingName:@"UTF-8"];
        [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        [[self client] URLProtocol:self didLoadData:indexJSData];
        [[self client] URLProtocolDidFinishLoading:self];
        return;
    }
    NSMutableURLRequest *connectionRequest = [[self request] mutableCopy];
    // we need to mark this request with our header so we know not to handle it in +[NSURLProtocol canInitWithRequest:].
    [connectionRequest setValue:@"" forHTTPHeaderField:WingTextURLHeader];
    
    _connection = nil;
    _connection = [[NSURLConnection alloc] initWithRequest:connectionRequest delegate:self startImmediately:NO];
    [_connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [_connection start];
}

// 这个方法是和start是对应的 一般在这个方法中,断开Connection
// 另外一点就是当NSURLProtocolClient的协议方法都回调完毕后,就会开始执行这个方法了
-(void)stopLoading {
    [_connection cancel];
    _connection = nil;
}

#pragma mark implement NSURLConnectionDelegate

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
//    NSLog(@"%@   ----    %@",response.URL.absoluteString,request.URL.absoluteString);
    
    if (response) {
        NSMutableURLRequest *redirectableRequest = [request mutableCopy];
        // We need to remove our header so we know to handle this request and cache it.
        // There are 3 requests in flight: the outside request, which we handled, the internal request,
        // which we marked with our header, and the redirectableRequest, which we're modifying here.
        // The redirectable request will cause a new outside request from the NSURLProtocolClient, which
        // must not be marked with our header.
        [redirectableRequest setValue:nil forHTTPHeaderField:WingTextURLHeader];
        
        [[self client] URLProtocol:self wasRedirectedToRequest:redirectableRequest redirectResponse:response];
        return redirectableRequest;
        
    }
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [[self client] URLProtocol:self didLoadData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[self client] URLProtocol:self didFailWithError:error];
    _connection = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"%@-%@",connection,response);
//    NSURLResponse *responseB = [[NSURLResponse alloc] initWithURL:[self request].URL MIMEType:response.MIMEType  expectedContentLength:0 textEncodingName:@"utf-8"];
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //    NSLog(@"connection");
    [[self client] URLProtocolDidFinishLoading:self];
    
    _connection = nil;
}

//可在该方法中，修改cache的策略，返回nil表示不缓存
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse{
//    NSLog(@"%@   %i    %i",cachedResponse.response.URL.absoluteString,[connection currentRequest].cachePolicy, cachedResponse.storagePolicy);
    return nil;
}
@end
