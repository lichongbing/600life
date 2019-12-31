//
//  LLTabBarController.h
//  tomlu
//
//  Created by Tom lu on 2019/4/30.
//  Copyright © 2019 com.luohaifang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ViewController1.h"              //首页
#import "ViewController2.h"              //分类
#import "ViewController3.h"            //品牌好店
#import "ViewController4.h"
NS_ASSUME_NONNULL_BEGIN

@interface LLTabBarController : UITabBarController

+(LLTabBarController*_Nonnull)sharedController;

@property(nonatomic,strong)UINavigationController* nc1;
@property(nonatomic,strong)UINavigationController* nc2;
@property(nonatomic,strong)UINavigationController* nc3;
@property(nonatomic,strong)UINavigationController* nc4;

@property(nonatomic,strong)ViewController1* vc1;
@property(nonatomic,strong)ViewController2* vc2;
@property(nonatomic,strong)ViewController3* vc3;
@property(nonatomic,strong)ViewController4* vc4;

@end

NS_ASSUME_NONNULL_END
