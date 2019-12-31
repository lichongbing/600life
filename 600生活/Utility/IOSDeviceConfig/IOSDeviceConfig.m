//
//  IOSDeviceConfig.m
//  tomlu
//
//  Created by Tom lu on 2019/4/30.
//  Copyright © 2019 com.luohaifang. All rights reserved.
//

#import "IOSDeviceConfig.h"
#import "IOSDeviceMacro.h"
#import <UIKit/UIKit.h>
#import "sys/utsname.h"
#import "ARCCompile.h"

@interface IOSDeviceConfig()

@property(nonatomic,strong) NSString* deviceString; //设备信息字符串

@end

@implementation IOSDeviceConfig

static IOSDeviceConfig *_sharedConfig = nil;

@synthesize isIPad = _isIPad;
@synthesize isIPhone = _isIPhone;
@synthesize isIPhone4 = _isIPhone4;
@synthesize isIPhone5 = _isIPhone5;

@synthesize isIPhone5_c = _isIPhone5_c;
@synthesize isIPhone5_s = _isIPhone5_s;
@synthesize isIPhone5_se = _isIPhone5_se;

@synthesize isIphone6 = _isIphone6;
@synthesize isIphone6_s = _isIphone6_s;
@synthesize isIphone6_plus = _isIphone6_plus;
@synthesize isIphone6_s_plus = _isIphone6_s_plus;

@synthesize isIphone7 = _isIphone7;
@synthesize isIphone7_plus = _isIphone7_plus;

@synthesize isIphone8 = _isIphone8;
@synthesize isIphone8_plus = _isIphone8_plus;

@synthesize isIphoneX = _isIphoneX;
@synthesize isIphoneX_R = _isIphoneX_R;
@synthesize isIphoneX_S = _isIphoneX_S;
@synthesize isIphoneX_MAX = _isIphoneX_MAX;

@synthesize isIOS6 = _isIOS6;
@synthesize isIOS7 = _isIOS7;
@synthesize isIOS8 = _isIOS8;
@synthesize isIOS9 = _isIOS9;
@synthesize isIOS10 = _isIOS10;
@synthesize isIOS11 = _isIOS11;
@synthesize isIOS12 = _isIOS12;
@synthesize isIOS13 = _isIOS13;


+ (IOSDeviceConfig *)sharedConfig
{
    @synchronized(_sharedConfig)
    {
        if (_sharedConfig == nil) {
            _sharedConfig = [[IOSDeviceConfig alloc] init];
            [_sharedConfig printDeviceInfo];
        }
        
        //获取设备信息
        if (!_sharedConfig.deviceString) {
            struct utsname systemInfo;
            uname(&systemInfo);
            _sharedConfig.deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
        }
        
        
        return _sharedConfig;
    }
}

- (void)dealloc
{
    CommonRelease(_deviceUUID);
    CommonSuperDealloc();
}

- (id)init
{
    if (self = [super init])
    {
        
        _isIPad = kIsIPad();
        _isIPhone = kIsIPhone();
        _isIPhone4 = kIsIPhone4(); //利用屏幕尺寸判断 当年苹果机型少
        
        /*从苹果5开始 后面的机型判断用系统信息 不用屏幕尺寸判断*/
        /*e.g.  self.isIPhone5*/
        /*在模拟器上无效 因为deviceString是x86_64  无法获取到手机设备信息*/
        
        //保存操作系统版本号
        _isIOS6 = kIsIOS6();
        _isIOS7 = kIsIOS7();
        _isIOS8 = kIsIOS8();
        _isIOS9 = kIsIOS9();
        _isIOS10 = kIsIOS10();
        _isIOS11 = kIsIOS11();
        _isIOS12 = kIsIOS12();
        _isIOS13 = kIsIOS13();
    }
    return self;
}

-(BOOL)isIPhone5
{
    return ([_deviceString isEqualToString:@"iPhone5,1"] || [_deviceString isEqualToString:@"iPhone5,2"]);
}

-(BOOL)isIPhone5_c
{
    return ([_deviceString isEqualToString:@"iPhone5,3"] || [_deviceString isEqualToString:@"iPhone5,4"]);
}

-(BOOL)isIPhone5_s
{
    return ([_deviceString isEqualToString:@"iPhone6,1"] || [_deviceString isEqualToString:@"iPhone6,2"]);
}

-(BOOL)isIPhone5_se
{
    return [_deviceString isEqualToString:@"iPhone8,4"];
}

-(BOOL)isIphone6
{
    return [_deviceString isEqualToString:@"iPhone7,2"];
}

-(BOOL)isIphone6_s
{
    return [_deviceString isEqualToString:@"iPhone8,1"];
}


-(BOOL)isIphone6_plus
{
    return [_deviceString isEqualToString:@"iPhone7,1"];
}

-(BOOL)isIphone6_s_plus
{
    return [_deviceString isEqualToString:@"iPhone8,2"];
}

-(BOOL)isIphone8
{
    return ([_deviceString isEqualToString:@"iPhone10,1"] || [_deviceString isEqualToString:@"iPhone10,4"] );
}

-(BOOL)isIphone8_plus
{
    return  ([_deviceString isEqualToString:@"iPhone10,2"] ||  [_deviceString isEqualToString:@"iPhone10,5"]);
}

-(BOOL)isIphoneX
{
    return ([_deviceString isEqualToString:@"iPhone10,3"] || [_deviceString isEqualToString:@"iPhone10,6"]);
}

-(BOOL)isIphoneX_R
{
    return [_deviceString isEqualToString:@"iPhone11,8"];
}

-(BOOL)isIphoneX_S
{
    return [_deviceString isEqualToString:@"iPhone11,2"];
}

-(BOOL)isIphoneX_MAX
{
    return ([_deviceString isEqualToString:@"iPhone11,4"] || [_deviceString isEqualToString:@"iPhone11,6"]);
}

-(BOOL)isIphoneX_11
{
    return ([_deviceString isEqualToString:@"iPhone12,1"]);
}

-(BOOL)isIphoneX_11_PRO
{
    return ([_deviceString isEqualToString:@"iPhone12,3"]);
}

-(BOOL)isIphoneX_11_PRO_MAX
{
    return ([_deviceString isEqualToString:@"iPhone12,5"]);
}

-(BOOL)isIphoneX_Series
{
    return [self isIphoneX] || [self isIphoneX_R] || [self isIphoneX_S] || [self isIphoneX_MAX] || [self isIphoneX_11]  || [self isIphoneX_11_PRO]  || [self isIphoneX_11_PRO_MAX] ;
}

- (BOOL)isPortrait
{
    return UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
}


//打印设备信息
-(void)printDeviceInfo
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSLog(@"app名称: %@",app_Name);
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSLog(@"app版本号: %@，构建版本号: %@",app_Version,app_build);
    //手机序列号
    //    [[UIDevice currentDevice].identifierForVendor].UUIDString
    NSString* identifierNumber = [UIDevice currentDevice].identifierForVendor.UUIDString;
    NSLog(@"手机序列号: %@",identifierNumber);
    //手机别名： 用户定义的名称
    NSString* userPhoneName = [[UIDevice currentDevice] name];
    NSLog(@"手机别名: %@", userPhoneName);
    //设备名称
    NSString* deviceName = [[UIDevice currentDevice] systemName];
    NSLog(@"设备名称: %@",deviceName );
    //手机系统版本
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"手机系统版本: %@", phoneVersion);
    //手机型号
    NSString* phoneModel = [[UIDevice currentDevice] model];
    NSLog(@"手机型号: %@",phoneModel );
    //地方型号  （国际化区域名称）
    NSString* localPhoneModel = [[UIDevice currentDevice] localizedModel];
    NSLog(@"国际化区域名称: %@",localPhoneModel );
    
    NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSLog(@"当前应用名称：%@",appCurName);
    // 当前应用软件版本  比如：1.0.1
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"当前应用软件版本:%@",appCurVersion);
    // 当前应用版本号码   int类型
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSLog(@"当前应用版本号码：%@",appCurVersionNum);
}


@end
