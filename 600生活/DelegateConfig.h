//
//  DelegateConfig.h
//  600生活
//
//  Created by iOS on 2019/11/28.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import <Foundation/Foundation.h>

///////////////////////////////////////////////////////////////////////

// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#import <UserNotifications/UserNotifications.h>
// 如果需要使用 idfa 功能所需要引入的头文件（可选）
//#import <AdSupport/AdSupport.h>

///////////////////////////////////////////////////////////////////////

NS_ASSUME_NONNULL_BEGIN

@interface DelegateConfig : NSObject<JPUSHRegisterDelegate>

+(DelegateConfig*_Nonnull)sharedConfig;

-(void)configAppDatas;

@end

NS_ASSUME_NONNULL_END
