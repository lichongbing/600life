//
//  IOSDeviceMacro.h
//  tomlu
//
//  Created by Tom lu on 2019/4/30.
//  Copyright © 2019 com.luohaifang. All rights reserved.
//

#ifndef IOSDeviceMacro_h
#define IOSDeviceMacro_h

#pragma mark - 苹果5之前用尺寸判断机型 苹果5之后用系统信息判断机型

#define kIsIPad() (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define kIsIPhone() (!kIsIPad())

#define kIsIPhone4() ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define kIsIPhone5() ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define kIsIOS6() ([[UIDevice currentDevice].systemVersion doubleValue]>= 6.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 7.0)

#define kIsIOS7() ([[UIDevice currentDevice].systemVersion doubleValue]>= 7.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 8.0)

#define kIsIOS8() ([[UIDevice currentDevice].systemVersion doubleValue]>= 8.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 9.0)

#define kIsIOS9() ([[UIDevice currentDevice].systemVersion doubleValue]>= 9.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 10.0)

#define kIsIOS10() ([[UIDevice currentDevice].systemVersion doubleValue]>= 10.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 11.0)

#define kIsIOS11() ([[UIDevice currentDevice].systemVersion doubleValue]>= 11.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 12.0)

#define kIsIOS12() ([[UIDevice currentDevice].systemVersion doubleValue]>= 12.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 13.0)

#define kIsIOS13() ([[UIDevice currentDevice].systemVersion doubleValue]>= 13.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 14.0)

//低于ios13的版本
#define kIsIOS13beBelow ([[UIDevice currentDevice].systemVersion doubleValue] < 13.0)

#endif /* IOSDeviceMacro_h */
