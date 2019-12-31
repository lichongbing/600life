//
//  WebViewViewController.m
//  600生活
//
//  Created by iOS on 2019/11/21.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "WebViewViewController.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>//如果是阿里百川需要

//WKScriptMessageHandler 和js交互
@interface WebViewViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property(nonatomic,strong)NSString* urlStr;
@property(nonatomic,strong)NSString* titleStr;

@end

@implementation WebViewViewController

-(void)dealloc
{
    _webView = nil;
    NSLog(@"浏览器已释放");
}

-(id)initWithUrl:(NSString*)url title:(NSString*)title
{
    if(self = [super init]){
        self.urlStr = url;
        self.titleStr = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = self.titleStr;
    
     //和js交互
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    if(_isNeedJS){
        
        //监听js中的authReturn方法
        [userContentController addScriptMessageHandler:self name:@"authReturn"];
        
        //缓存处理
        NSString *cookieValue = @"document.cookie = 'fromapp=ios';document.cookie = 'channel=appstore';";
        WKUserScript * cookieScript = [[WKUserScript alloc]
                                       initWithSource: cookieValue
                                       injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        [userContentController addUserScript:cookieScript];
    }
    
    WKWebViewConfiguration* config = [[WKWebViewConfiguration alloc]init];
    config.userContentController = userContentController;
    config.preferences = [[WKPreferences alloc] init];
    config.preferences.javaScriptEnabled = YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    config.preferences.minimumFontSize = 10;
    
    //web内容池处理
    config.processPool = [[WKProcessPool alloc] init];
 
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kIPhoneXHomeIndicatorHeight) configuration:config];
    [self.view addSubview:self.webView];
    self.webView.navigationDelegate = (id)self;
    self.webView.UIDelegate = (id)self;
    
    if(self.urlStr.length>0){
        [self handleNormalWeb];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

//处理普通网页url
-(void)handleNormalWeb
{
    if(self.isNeedJS){
        // 在此处获取返回的cookie
        NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
        NSMutableString *cookieValue = [NSMutableString stringWithFormat:@""];
        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in [cookieJar cookies]) {
            [cookieDic setObject:cookie.value forKey:cookie.name];
        }
        // cookie重复，先放到字典进行去重，再进行拼接
        for (NSString *key in cookieDic) {
            NSString *appendString = [NSString stringWithFormat:@"%@=%@;", key, [cookieDic valueForKey:key]];
            [cookieValue appendString:appendString];
        }
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
        [request addValue:cookieValue forHTTPHeaderField:@"Cookie"];
        [self.webView loadRequest:request];
    }else{
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    }
    
}


#pragma mark - WKWebView WKNavigation delegate
/* 在发送请求之前，决定是否跳转 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
}

/* 在收到响应后，决定是否跳转 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSLog(@"url地址:%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    NSLog(@"允许跳转页面");
    decisionHandler(WKNavigationResponsePolicyAllow);
}

/* 开始返回内容 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"开始返回内容");
}

/* 页面开始加载 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    if(!self.isNeedJS){
        [self loading];
    }
    NSLog(@"页面开始加载");
}

/* 页面加载完成 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    if(!self.isNeedJS){
        [self stopLoading];
    }
    NSLog(@"页面加载完成");
}

/* 页面加载失败 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    if(!self.isNeedJS){
        [self stopLoading];
    }
    NSLog(@"页面加载失败");
}

#pragma mark WKUIDelegate

// alert
//此方法作为js的alert方法接口的实现，默认弹出窗口应该只有提示信息及一个确认按钮，当然可以添加更多按钮以及其他内容，但是并不会起到什么作用
//点击确认按钮的相应事件需要执行completionHandler，这样js才能继续执行
////参数 message为  js 方法 alert(<message>) 中的<message>
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
   
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler
{
    
}

#pragma mark =========================================
#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"方法名:%@", message.name);
    NSLog(@"参数:%@", message.body);

    /**
     {
         msg = "\U6388\U6743\U6210\U529f\Uff01";
         "relation_id" = 2319153490;
     }
     */
    if([message.name isEqualToString:@"authReturn"]){
        NSDictionary* dic = message.body;
       
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(dic[@"relation_id"]){
                [[LLHudHelper sharedInstance]tipMessage:@"绑定成功" delay:1.5] ;
            }else{
                [[LLHudHelper sharedInstance]tipMessage:dic[@"msg"] delay:1.5];
            }
        });
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}



@end
