//
//  AppDelegate.m
//  600生活
//
//  Created by iOS on 2019/11/28.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "AppDelegate.h"

#import <AlibcTradeSDK/AlibcTradeSDK.h>//阿里百川
#import "WXApi.h"//微信分享
#import "JPUSHService.h" //激光推送

//初始化数据
#import "DelegateConfig.h"
//初始化UI
#import "LLTabBarController.h"
//引导页
#import "GuidenceViewController.h"
//京东联盟
#import <JDSDK/JDKeplerSDK.h>
#define Value_AppKey @"715f298a4e3c45851fce272ac0456542"
#define Value_AppSecret @"fb75c0384dc44c03b00b65bf253d4c00"

@interface AppDelegate ()<WXApiDelegate,JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
       
    //先执行UI 后处理数据
    kisMainThread;
       if(kIsIOS13beBelow){  //ios 13以下的版本
           self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
           self.window.backgroundColor = kAppBackGroundColor;
           if ([[NSUserDefaults standardUserDefaults] boolForKey:kFirstLaunch]){
                //不第一次启动
               LLTabBarController* rootTabbarVC = [LLTabBarController sharedController];
               self.window.rootViewController = rootTabbarVC;
           }else{ //第一次
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kFirstLaunch];
                 GuidenceViewController *guidanceVC = [[GuidenceViewController alloc] init];
                 guidanceVC.modalPresentationStyle = UIModalTransitionStyleCrossDissolve;
                 self.window.rootViewController = guidanceVC;
           }
            [self.window makeKeyAndVisible];
       }
    
    //初始化数据
    [[DelegateConfig sharedConfig]configAppDatasWithLaunchOptions:launchOptions];
    //京东联盟
    [[KeplerApiManager sharedKPService]asyncInitSdk:Value_AppKey secretKey:Value_AppSecret sucessCallback:^(){}failedCallback:^(NSError *error){}];

    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"应用程序已经变为活跃");
    
    if(kIsIOS13beBelow){
        //把角标数值清空
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        
        //APP变为活跃状态时查看剪切板内容 弹出搜索框
        [[NSNotificationCenter defaultCenter]postNotificationName:kCheckUserPasteboardNofification object:nil userInfo:nil];
        
        //APP变为活跃状态时 告诉SettingViewController 让它刷新数据
        [[NSNotificationCenter defaultCenter]postNotificationName:kAppDidBecomeActiveNofification object:nil userInfo:nil];
    }
   
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

#pragma mark - open url

//被弃用的 openURL
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //微信支付
    return [WXApi handleOpenURL:url delegate:self];
}

//新的 open URL
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    // 新接口写法
    if (![[AlibcTradeSDK sharedInstance] application:app
                                             openURL:url
                                             options:options]) {
        return [WXApi handleOpenURL:url delegate:(id)self];
    }
    return  YES;
}

#pragma mark - handle OpenURL
////被弃用的 handleOpenURL
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL*)url
{
    //微信支付
    return [WXApi handleOpenURL:url delegate:(id)self];
}

//使用下面的方法
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler 
{
    return [WXApi handleOpenUniversalLink:userActivity delegate:self];
}


/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
- (void)onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
       {
           // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
           NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
           NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
       }
       else if([req isKindOfClass:[ShowMessageFromWXReq class]])
       {
           ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
           WXMediaMessage *msg = temp.message;
           
           //显示微信传过来的内容
           WXAppExtendObject *obj = msg.mediaObject;
           
           NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
           NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%u bytes\n\n", msg.title, msg.description, obj.extInfo, msg.thumbData.length];
       }
       else if([req isKindOfClass:[LaunchFromWXReq class]])
       {
           //从微信启动App
           NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
           NSString *strMsg = @"这是从微信启动的消息";
       }
}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
- (void)onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
      {
          NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
          NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
          
          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
          [alert show];
      }
}

#pragma mark - 推送相关--------------------

//注册推送token
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

  /// Required - 注册 DeviceToken
  [JPUSHService registerDeviceToken:deviceToken];
}

//注册推送失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  //Optional
  NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
  if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    //从通知界面直接进入应用
  }else{
    //从通知设置界面进入应用
  }
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
  // Required
  NSDictionary * userInfo = notification.request.content.userInfo;
  if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    [JPUSHService handleRemoteNotification:userInfo];
  }
  completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}


// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
  // Required
  NSDictionary * userInfo = response.notification.request.content.userInfo;
  if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    [JPUSHService handleRemoteNotification:userInfo];
  }
  completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

  // Required, iOS 7 Support
  [JPUSHService handleRemoteNotification:userInfo];
  completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

  // Required, For systems with less than or equal to iOS 6
  [JPUSHService handleRemoteNotification:userInfo];
}

@end
