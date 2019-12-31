//
//  IOSDeviceConfig.h
//  tomlu
//
//  Created by Tom lu on 2019/4/30.
//  Copyright © 2019 com.luohaifang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IOSDeviceConfig : NSObject

+ (IOSDeviceConfig *)sharedConfig;

@property (nonatomic, readonly) BOOL isIPad;   //是否是pad
@property (nonatomic, readonly) BOOL isIPhone; //是否是iphone
@property (nonatomic, readonly) BOOL isIPhone4; //是否是ip4

@property (nonatomic, readonly) BOOL isIPhone5;    //是否是ip 5
@property (nonatomic, readonly) BOOL isIPhone5_c;  //是否是ip 5c
@property (nonatomic, readonly) BOOL isIPhone5_s;  //是否是ip 5s
@property (nonatomic, readonly) BOOL isIPhone5_se; //是否是ip 5se

@property (nonatomic, readonly) BOOL isIphone6;        //是否是ip 6
@property (nonatomic, readonly) BOOL isIphone6_s;      //是否是ip 6s
@property (nonatomic, readonly) BOOL isIphone6_plus;   //是否是ip 6p
@property (nonatomic, readonly) BOOL isIphone6_s_plus; //是否是ip 6sp

@property (nonatomic, readonly) BOOL isIphone7;        //是否是ip 7
@property (nonatomic, readonly) BOOL isIphone7_plus;   //是否是ip 7p

@property (nonatomic, readonly) BOOL isIphone8;        //是否是ip 8
@property (nonatomic, readonly) BOOL isIphone8_plus;   //是否是ip 8p

@property (nonatomic, readonly) BOOL isIphoneX;        //是否是ip x
@property (nonatomic, readonly) BOOL isIphoneX_R;      //是否是ip xr
@property (nonatomic, readonly) BOOL isIphoneX_S;      //是否是ip xr
@property (nonatomic, readonly) BOOL isIphoneX_MAX;      //是否是ip xr
@property (nonatomic, readonly) BOOL isIphoneX_Series;   //是否是ip 10 系列

@property (nonatomic, readonly) BOOL isIphoneX_11;          //是否是ip 11
@property (nonatomic, readonly) BOOL isIphoneX_11_PRO;      //是否是ip 11 pro
@property (nonatomic, readonly) BOOL isIphoneX_11_PRO_MAX;  //是否是ip 11 pro max

@property (nonatomic, readonly) BOOL isIOS6;
@property (nonatomic, readonly) BOOL isIOS7;
@property (nonatomic, readonly) BOOL isIOS8;
@property (nonatomic, readonly) BOOL isIOS9;
@property (nonatomic, readonly) BOOL isIOS10;
@property (nonatomic, readonly) BOOL isIOS11;
@property (nonatomic, readonly) BOOL isIOS12;
@property (nonatomic, readonly) BOOL isIOS13;

@property (nonatomic, readonly) BOOL isPortrait;
@end

NS_ASSUME_NONNULL_END
