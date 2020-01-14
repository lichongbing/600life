//
//  DelegateConfig.m
//  600生活
//
//  Created by iOS on 2019/11/28.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "DelegateConfig.h"
#import <IQKeyboardManager/IQKeyboardManager.h>  //设置IQKeybord键盘
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import <AlibabaAuthSDK/ALBBSDK.h>
#import "WXApi.h"


@interface DelegateConfig()<JPUSHRegisterDelegate>

@end

@implementation DelegateConfig

+(DelegateConfig*_Nonnull)sharedConfig
{
    static DelegateConfig* config = nil;

    static dispatch_once_t once;
    dispatch_once(&once, ^{
        config = [[DelegateConfig alloc]init];
    });
    return config;
}

-(void)configAppDatasWithLaunchOptions:(NSDictionary *)launchOptions
{
    //监控网络
    [self monitoringNetwork];
    //启动本地数据库
    [self configLativeDB];
    //设置IQKeybord
    [self configIQKeyBoard];
    //设置阿里百川
    [self configAliBaiChuan];
    //配置微信sdk
    [self configWeChatSDK];
    //激光推送
    [self configJPushWithLaunchOptions:launchOptions];
}

//监控网络
/**
 AFNetworkReachabilityStatusUnknown  -1
 AFNetworkReachabilityStatusNotReachable  0
 AFNetworkReachabilityStatusReachableViaWWAN  1
 AFNetworkReachabilityStatusReachableViaWWAN  2
 */
-(void)monitoringNetwork
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {

        //这个通知会导致更新到UI操作
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]postNotificationName:kNetStatuChangedNotification object:[NSNumber numberWithInteger:status]];
        });
    }];
}

//本地数据库
- (void)configLativeDB
{
    LLUser* lastLoginUsr = [[LLUserManager shareManager] getLastLoginUser];
    if(lastLoginUsr.id != nil) {
        [LLUserManager shareManager].currentUser = lastLoginUsr;
    }
    
    NSLog(@"当前用户id:%@\n",[LLUserManager shareManager].currentUser.id);
    NSLog(@"当前用户token:%@\n",[LLUserManager shareManager].currentUser.token);
    NSLog(@"用户数据初始化结束");
    
    //订单用到代码  15262011558
}

//IQKeyBoard配置
-(void)configIQKeyBoard
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;//这个是点击空白区域键盘收缩的开关
    manager.enableAutoToolbar = YES;//这个是它自带键盘工具条开关
    manager.enableDebugging = YES;
    manager.enableAutoToolbar = YES; //自动展示工具栏或者自动隐藏
}

//配置阿里百川
-(void)configAliBaiChuan
{
    [[AlibcTradeSDK sharedInstance] setDebugLogOpen:NO];
    [[AlibcTradeSDK sharedInstance] setIsvAppName:@"600生活"];
    [[AlibcTradeSDK sharedInstance] setIsvVersion:@"1.0.0"];
    [[ALBBSDK sharedInstance] setAppkey:kAliBaiChuanAppKey];
    [[ALBBSDK sharedInstance] setAuthOption:NormalAuth];
    [[AlibcTradeSDK sharedInstance]asyncInitWithSuccess:^{
        TLOG_INFO(@"百川SDK初始化成功");
    } failure:^(NSError *error) {
        TLOG_INFO(@"百川SDK初始化失败");
    }];
}

//配置微信sdk
-(void)configWeChatSDK
{
    //必须以 /结尾
    //  @"https://www.lbshapp.com/app/"    以前可用的
     BOOL flag = [WXApi registerApp:@"wxb2efb7a9872c79fd" universalLink:@"https://www.lbshapp.com/"];
    NSLog(@"微信sdk注册%@",flag ? @"成功" : @"失败");
}

//配置激光推送
-(void)configJPushWithLaunchOptions:(NSDictionary *)launchOptions
{
   JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if(!kIsIOS12beBelow){//高于ios12
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    }else{
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    }
    
    id pDelegate = kAppDelegate;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:pDelegate];
    
    NSString* appKey = @"f7f8e5d63d78ea332d88f83e";
    NSString* channel = @"Publish channel";
    BOOL isProduction = NO;
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
//    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
//        if(resCode == 0){
//            NSLog(@"激光推送registrationID获取成功：%@",registrationID);
//        }
//        else{
//            NSLog(@"激光推送registrationID获取失败，code：%d",resCode);
//        }
//    }];

    LLUser* user = [LLUserManager shareManager].currentUser;
    if(user.id.toString.length > 0){
        NSString* uidStr = user.id.toString;
        NSSet* set = [NSSet setWithObject:uidStr];
        [JPUSHService setTags:set completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
            NSLog(@"%@",iTags);
            NSLog(@"%lu",seq);
        } seq:uidStr.integerValue];
    }
}

#pragma mark - 通知权限引导



@end
