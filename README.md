# cmbwebview
8/4

不用wkwebview的理由：
项目使用本身需要传cookie。wkwebview相比webview性能强了很多，却多了很多坑。难填，so先不用了。

#1 
WKWebView Cookie

NSURLCache和NSHTTPCookieStroage无法操作(WKWebView)WebCore进程的缓存和Cookie

WKWebView实例将会忽略任何的默认网络存储器(NSURLCache, NSHTTPCookieStorage, NSCredentialStorage) 和一些标准的自定义网络请求类(NSURLProtocol,等等.).

WKWebView实例不会把Cookie存入到App标准的的Cookie容器(NSHTTPCookieStorage)中,因为 NSURLSession/NSURLConnection等网络请求使用NSHTTPCookieStorage进行访问Cookie,所以不能访问WKWebView的Cookie,现象就是WKWebView存了Cookie,其他的网络类如NSURLSession/NSURLConnection却看不到

与Cookie相同的情况就是WKWebView的缓存,凭据等。WKWebView都拥有自己的私有存储,因此和标准cocoa网络类兼容的不是那么好

你也不能自定义requests(增加自己的http header,更改已经存在的header)使用自定义的 URL schemes等等,因为NSURLProtocol也是不支持WKWebView的

http://stackoverflow.com/questions/24464397/how-can-i-retrieve-a-file-using-WKWebView.

一定要使用可以参考：http://www.skyfox.org/ios-wkwebview-cookie-opration.html 

#2
cookie介绍：
http://www.codeweblog.com/ios%E4%B8%ADcookie%E4%BB%8B%E7%BB%8D/
http://blog.it985.com/11248.html
http://tec.5lulu.com/detail/108k0n1e626py8s96.html
http://tec.5lulu.com/detail/108arn4wm11y78sf4.html
http://www.jianshu.com/p/0943c32e563b

#3
https://github.com/HAPENLY/UIWebviewWithCookie
1. iOS在`UIWebView`中获取的cookie的方法：`NSHTTPCookieStorage * nCookies = [NSHTTPCookieStorage sharedHTTPCookieStorage]`
2. 再具体获取某个域的饼干：`NSArray* cookiesURL = [nCookies cookiesForURL：[NSURL URLWithString：@“你的URL”]];（本地是不是不行？）`
3. 通过`[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie]`方法将 `cookies`来保存起来，但是这样虽然可以保存`cookies`但是你应用退出之后还是会丢失(其实是cookies过期的问题)，做好的方法是把`cookies`放到`NSUserDefaults`保存起来:
