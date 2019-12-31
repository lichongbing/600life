//
//  LLTableViewController.m
//  tomlu
//
//  Created by Tom lu on 2019/4/30.
//  Copyright © 2019 com.luohaifang. All rights reserved.
//

#import "LLTableViewController.h"
#import "MJRefresh.h"       //停止mj 刷新动画
#import "MBProgressHUD.h"
#import "AppDelegate.h"     //重新登录需要跳转到LoginVC

#import "LoginAndRigistMainVc.h" //注册登录
#import "UIViewController+ext.h"  //判断当前vc是否正在被展示
#import "MBProgressHUD+ext.h"  //hud添加动画

//MJ刷新
typedef NS_ENUM(NSInteger, TableviewRefreshType) {
    TableviewRefreshTypeHeader = 0,
    TableviewRefreshTypeFooter
};

@interface LLTableViewController ()

@property(nonatomic,strong)NSMutableArray* currentVCNetTasksArray;//vc管理属于它自身的且未结束的网络请求任务集合
@property(nonatomic,strong)MBProgressHUD* hud;  //每一个Controller管理着1个hud，vc中d所有网络请求共用这一个hud

@end

@implementation LLTableViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNetStatuChangedNotification object:nil];
}


//添加网络条件切换通知
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(netStatuChangedNotificationAction:) name:kNetStatuChangedNotification object:nil];
}

//移除网络条件切换通知
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNetStatuChangedNotification object:nil];
}

#pragma mark - 父类函数重写
-(void)navBackItemAction
{
    [super navBackItemAction];
    [self forceStopVCNetWorkings];
}

#pragma mark - notification
///网络状态改变
-(void)netStatuChangedNotificationAction:(NSNotification*)noti
{
    //如果该vc不是当前正在被展示的vc 不执行
    UIViewController* currentVc = [Utility getCurrentUserVC];
    if(![currentVc isEqual:self]){
        return;
    }
    
    NSNumber* netStatuNum = noti.object;
    if ([netStatuNum integerValue] <= 0) { //-1 网络未知 0 无网络
        [self performSelectorOnMainThread:@selector(netErrorAction) withObject:nil waitUntilDone:NO];
    } else {  //1 蜂窝网络   2 wifi
        [self performSelectorOnMainThread:@selector(newSuccessAction) withObject:nil waitUntilDone:NO];
    }
}

//无网络
-(void)netErrorAction
{
    [[LLHudHelper sharedInstance]tipMessage:@"网络已断开连接" delay:5.0];
}

//有网络
-(void)newSuccessAction
{
    
}


#pragma mark - getter

-(UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth , kScreenHeight) style:UITableViewStylePlain];
        _tableview.tableFooterView = [UIView new];
        _tableview.backgroundColor = kAppBackGroundColor;
        _tableview.separatorStyle = 0;//取消分割线
        [self.view addSubview:_tableview];
    }
    return _tableview;
}

-(NSMutableArray*)datasource
{
    if(!_datasource){
        _datasource = [NSMutableArray new];
    }
    return _datasource;
}

-(NSMutableArray*)currentVCNetTasksArray{
    if(!_currentVCNetTasksArray){
        _currentVCNetTasksArray = [NSMutableArray new];
    }
    return _currentVCNetTasksArray;
}

-(MBProgressHUD *)hud{
    if (!_hud) {
        _hud = [[MBProgressHUD alloc]initWithView:self.view];
//        _hud.mode = MBProgressHUDModeIndeterminate;
    }
    return _hud;
}



#pragma mark - loading
-(void)loading
{
    [self loadingMessage:nil];
}

-(void)loadingMessage:(NSString*)msg
{    
    [self.view addSubview:self.hud];
    [self.view bringSubviewToFront:self.hud];
    self.hud.label.text = msg;
    self.hud.hidden = NO;
    [self.hud showAnimated:YES];
    
    [self.hud addAnimation];//拓展方法 动画
    [self.hud hiddenMBBackgroundEffectView];//拓展方法 去掉毛玻璃背景色
}

-(void)stopLoading
{
    __weak LLTableViewController* wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        wself.hud.hidden = YES;
        [wself.hud removeFromSuperViewOnHide];
    });
}

#pragma mark - net http

-(void)GetWithUrlStr:(NSString*_Nullable)urlStr
               param:(NSDictionary*_Nullable)para
             showHud:(BOOL)showHud
            resCache:(void (^)( id cacheData))resCache
             success:(void(^_Nonnull)(id _Nullable res))successBlock
              falsed:(void(^_Nonnull)(NSError *_Nullable error))falsedBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES]; // 开启状态栏动画
        if(showHud){
            [self loading];
        }
    });
    
    
    __weak LLTableViewController* wself = (id)self;
    
    __block NSURLSessionTask* task = [[LLNetWorking sharedWorking]GET:urlStr param:para  resCache:^(id  _Nullable cacheData) {
        if(resCache != nil) {
            resCache (cacheData);
        }
    } success:^(id  _Nullable res) {
        dispatch_async(dispatch_get_main_queue(), ^{
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO]; // 关闭状态栏动画
            if(showHud){
                [wself stopLoading];//菊花停转
            }
        });
        
        if(wself.isMJHeaderRefresh){
            [wself.tableview.mj_header endRefreshing];
            [wself.tableview.mj_footer endRefreshing];
        }
        
        successBlock(res);
        //返回异常状态码
        if (!kSuccessRes ){
            NSLog(@"异常返回的接口:-->%@",urlStr);
           
            [[LLHudHelper sharedInstance]tipMessage:res[@"message"]];
            if([res[@"code"]intValue] == 10001) { //后台token 过期
                LLUser* currentUser = [LLUserManager shareManager].currentUser;
                currentUser.isLogin = 0;
                [[LLUserManager shareManager]insertOrUpdateCurrentUser:currentUser];

                [wself forceStopVCNetWorkings];
                [wself goToLoginVC];

            } else if ([res[@"code"]intValue] == 0) { //后台返空
                [wself forceStopVCNetWorkings];
                NSString* msg = res[@"msg"];
                if(msg){
                    [[LLHudHelper sharedInstance]tipMessage:msg];
                }else{
                    [[LLHudHelper sharedInstance]tipMessage:@"服务异常!"];
                }
            } else {
               [[LLHudHelper sharedInstance]tipMessage:res[@"msg"]];
            }
        }
        [wself.currentVCNetTasksArray removeObject:task]; //清除已完成任务
    } failure:^(NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO]; // 关闭状态栏动画
        });
        [wself stopLoading]; //菊花停转
        if(wself.isMJHeaderRefresh){
                   [wself.tableview.mj_header endRefreshing];
                   [wself.tableview.mj_footer endRefreshing];
               }
        
        falsedBlock(error);
        NSString* errStr = [NSString stringWithFormat:@"服务异常:%@",[urlStr substringFromIndex:kBaseUrl.length]];
        [[LLHudHelper sharedInstance]tipMessage:errStr];
        
        [wself.currentVCNetTasksArray removeObject:task]; //清除已完成任务
    }];
    
    //如果空任务（任务取消）
    if(task == nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            if(showHud){
                [wself stopLoading]; //菊花停转
            }
        });
       
        if(wself.isMJHeaderRefresh){
            [wself.tableview.mj_header endRefreshing];
            [wself.tableview.mj_footer endRefreshing];
        }
    }
    
    //如果任务创建成功，并且没有被数组管理起来，那么放入数组中
    if(task && ![wself.currentVCNetTasksArray containsObject:task]){
        NSLock* lock = [[NSLock alloc]init];
        [lock lock];
        [wself.currentVCNetTasksArray addObject:task];
        [lock unlock];
    }
}

-(void)PostWithUrlStr:(NSString*_Nullable)urlStr
                param:(NSDictionary*_Nullable)para
              showHud:(BOOL)showHud
             resCache:(void (^_Nullable)( id _Nullable cacheData))resCache
              success:(void(^_Nonnull)(id _Nullable res))successBlock
               falsed:(void(^_Nonnull)(NSError *_Nullable error))falsedBlock
{
    __weak LLTableViewController* wself = self;

    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES]; // 开启状态栏动画
        if(showHud){
            [wself loading];//菊花转
        }
    });

    __block NSURLSessionTask* task = [[LLNetWorking sharedWorking] Post:urlStr param:para  resCache:^(id  _Nullable cacheData){
        if (resCache != nil) {
            resCache(cacheData);
        }
    } success:^(id  _Nullable res) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO]; // 关闭状态栏动画
            if(showHud){
                [wself stopLoading];//菊花停转
            }
        });
        
        if(wself.isMJHeaderRefresh){
            [wself.tableview.mj_header endRefreshing];
            [wself.tableview.mj_footer endRefreshing];
        }
        successBlock(res);
        if ( !kSuccessRes ){ //后台异常
            [[LLHudHelper sharedInstance]tipMessage:res[@"message"]];

            if([res[@"code"]intValue] == 10001) { //后台token 过期
                LLUser* currentUser = [LLUserManager shareManager].currentUser;
                currentUser.isLogin = 0;
                [[LLUserManager shareManager]insertOrUpdateCurrentUser:currentUser];
                [wself forceStopVCNetWorkings];
//                [[LLHudHelper sharedInstance]tipMessage:@"登录过期,请重新登录"];
                 [wself goToLoginVC];
            } else if([res[@"code"]intValue] < 0) { //后台返空
                [wself forceStopVCNetWorkings];
                [[LLHudHelper sharedInstance]tipMessage:@"服务异常!"];
            } else {
                [[LLHudHelper sharedInstance]tipMessage:res[@"msg"]];
            }
        }
        [wself.currentVCNetTasksArray removeObject:task]; //清除已完成任务
    } failure:^(NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            if(showHud){
                [wself stopLoading]; //菊花停转
            }
        });
        
         if(wself.isMJHeaderRefresh){
             [wself.tableview.mj_header endRefreshing];
             [wself.tableview.mj_footer endRefreshing];
         }
        
        falsedBlock(error);

        NSString* errStr = [NSString stringWithFormat:@"服务异常:%@",[urlStr substringFromIndex:kBaseUrl.length]];
        [[LLHudHelper sharedInstance]tipMessage:errStr];
        [wself.currentVCNetTasksArray removeObject:task]; //清除已完成任务
    }];

    //如果空任务（任务取消或者）
    if(task == nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            if(showHud){
                [wself stopLoading]; //菊花停转
            }
        });
        if(wself.isMJHeaderRefresh){
            [wself.tableview.mj_header endRefreshing];
            [wself.tableview.mj_footer endRefreshing];
        }
    }

    //如果任务创建成功，并且没有被数组管理起来，那么放入数组中
    if(task && ![self.currentVCNetTasksArray containsObject:task]){
        [wself.currentVCNetTasksArray addObject:task];
    }
}

///上传一组图片 (一组是 用户一次选取若干张图片的动作)
-(void)uploadOneGrounpImgWithURL:(NSString *_Nonnull)URL
                      parameters:(NSDictionary *_Nullable)parameters
                            name:(NSString *_Nullable)name
                          images:(NSArray *_Nonnull)images
                        progress:(HttpProgress _Nullable )progres
                         success:(HttpRequestSuccess _Nullable )success
                         failure:(HttpRequestFailed _Nullable )failure
{
    __weak LLTableViewController* wself = self;

    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES]; // 开启状态栏动画
        [wself loading];//菊花转
    });

   __block NSURLSessionDataTask* task = [[LLNetWorking sharedWorking]uploadOneGrounpImgWithURL:URL parameters:parameters name:name images:images progress:^(NSProgress *progress) {
        progres ? progres(progress) : nil;
    } success:^(id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO]; // 关闭状态栏动画
        });
        [wself stopLoading];//菊花停转
        success(responseObject);
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO]; // 关闭状态栏动画
        });
        [wself stopLoading];//菊花停转
        [[LLHudHelper sharedInstance]tipMessage:@"网络异常，请稍后重试"];
        [wself.currentVCNetTasksArray removeObject:task]; //清除已完成任务
        failure(error);
    }];
}

-(void)forceStopVCNetWorkings
{
    //停止当前vc中的网络请求
    __weak LLTableViewController* wself = self;
    if(self.currentVCNetTasksArray.count > 0){
        for(NSURLSessionTask* task in wself.currentVCNetTasksArray){
            [task cancel];//延时0.1s取消网络请求
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //停止编辑
        [wself.view endEditing:YES];
        //关闭状态栏动画
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    });
    
    //关闭hud
    [self stopLoading];
}





//streamDic 必须是   string:data 这种数据
-(void)uploadStreamFilePostWithUrl:(NSString*)subUrlStr streamFiles:(NSDictionary*)streamFilesDic otherParams:(NSDictionary*)params
{
    
//    NSString* fullUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,subUrlStr];
//
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:fullUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
//    request.HTTPMethod = @"POST";
//    NSString *boundary = @"AaB03x";
//
//    request.allHTTPHeaderFields = @{
//                                    @"Content-Type":[NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary]
//                                    };
//
//
//    NSMutableData *postData = [[NSMutableData alloc]init];//请求体数据
//
//    //非流参数添加
//    for (NSString *key in params) {
//        //循环参数按照部分1、2、3那样循环构建每部分数据
//        NSString *pair = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n",boundary,key];
//        [postData appendData:[pair dataUsingEncoding:NSUTF8StringEncoding]];
//
//        id value = [params objectForKey:key];
//        if ([value isKindOfClass:[NSString class]]) {
//            [postData appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
//        }else if ([value isKindOfClass:[NSData class]]){
//            [postData appendData:value];
//        } else if ([value isKindOfClass:[NSArray class]]) { //如果是数组(里面有多张图片)
//            NSArray* array = (NSArray*)value;
//            for(int i = 0; i < array.count; i++) {
//                NSString* jsonStr = [Utility stringWithJsonArray:array];
//                NSData* data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
//                [postData appendData:data];
//            }
//        } else if([value isKindOfClass:[NSDictionary class]]) {
//            NSString* jsonStr = [Utility stringWithJsonDictionary:(NSDictionary*)value];
//            NSData* data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
//            [postData appendData:data];
//        }
//
//        [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    }
//
//
//    //流参数添加  string：data
//    for(int i = 0; i <streamFilesDic.allKeys.count; i++ ) {
//        NSArray* keys = [streamFilesDic allKeys];
//        NSString* streamFileKey = [keys objectAtIndex:i];
//        NSData* fileData = [streamFilesDic valueForKey:streamFileKey];
//        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
//        formatter.dateFormat=@"yyyyMMddHHmmss";
//        NSString *str=[formatter stringFromDate:[NSDate date]];
//        NSString *fileName=[NSString stringWithFormat:@"%@.jpg",str];
//
//        NSString* filePairStr = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type: image/jpg\r\n\r\n",streamFileKey,fileName];
//
//        [postData appendData:[filePairStr dataUsingEncoding:NSUTF8StringEncoding]];//文件参数
//        [postData appendData:fileData]; //文件流
//    }
//
//    //设置结尾
//    [postData appendData:[[NSString stringWithFormat:@"--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    request.HTTPBody = postData;
//    //设置请求头总数据长度
//    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)postData.length] forHTTPHeaderField:@"Content-Length"];
//
//
//     [request setHTTPBody:postData];
//
//    //NSURLSession *session = [NSURLSession sharedSession];
//    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:(id)self delegateQueue:nil];
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (error == nil) {
//            //成功进行解析
//            NSMutableDictionary * res = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//            if (kSuccessRes) {
//                DebugLog(@"解析成功");
//            } else {
//                [[LLHudHelper sharedInstance]tipMessage:res[@"message"]];
//            }
//        } else {
//            [[LLHudHelper sharedInstance]tipMessage:@"网络异常，请稍后重试"];
//        }
//    }];
//
//    [task resume];
}


-(void)goToLoginVC
{
    __weak LLTableViewController* wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[LLHudHelper sharedInstance]tipMessage:@"登录已过期"];
        __strong LLTableViewController* sself = wself;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            LoginAndRigistMainVc* vc = [[LoginAndRigistMainVc alloc]initWithNoBackItem];
            vc.hidesBottomBarWhenPushed = YES;
            [sself.navigationController pushViewController:vc animated:YES];
        });
    });
}

@end
