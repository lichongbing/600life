//
//  AppDelegate.h
//  600生活
//
//  Created by iOS on 2019/11/28.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"//微信分享

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>

@property(nonatomic,strong)UIWindow* window;


@end

