//
//  LLTabBarController.m
//  tomlu
//
//  Created by Tom lu on 2019/4/30.
//  Copyright © 2019 com.luohaifang. All rights reserved.
//

#import "LLTabBarController.h"

@interface LLTabBarController ()

@end

@implementation LLTabBarController

-(void)dealloc
{
    self.delegate = nil;
}

-(id)init
{
    if(self = [super init]){
        self.delegate = (id)self;
        [self setupControllers];
    }
    return self;
}


+(LLTabBarController*_Nonnull)sharedController
{
    static LLTabBarController* tabVc = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        tabVc = [[LLTabBarController alloc]init];
    });
    return tabVc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    [[WMThemeManager sharedManager] settingThemeWithThemeStyle:[WMThemeManager sharedManager].curretStyle]; //默认主题
    //这个版本不用主题
}

-(void)setupControllers
{
    _vc1  = [[ViewController1 alloc] init];
    _nc1 = [[UINavigationController alloc] initWithRootViewController:_vc1];
    _nc1.tabBarItem = [[UITabBarItem alloc]init];
    _nc1.tabBarItem.title = @"首页";
    
    _vc2  = [[ViewController2 alloc] init];
    _nc2 = [[UINavigationController alloc] initWithRootViewController:_vc2];
    _nc2.tabBarItem  = [[UITabBarItem alloc] init];
    _nc2.tabBarItem.title = @"分类";
    
    _vc3  = [[ViewController3 alloc] init];
    _nc3 = [[UINavigationController alloc] initWithRootViewController:_vc3];
    _nc3.tabBarItem  = [[UITabBarItem alloc] init];
    _nc3.tabBarItem.title = @"品牌";

    _vc4  = [[ViewController4 alloc] init];
    _nc4 = [[UINavigationController alloc] initWithRootViewController:_vc4];
    _nc4.tabBarItem  = [[UITabBarItem alloc] init];
    _nc4.tabBarItem.title = @"我的";
    
    self.viewControllers = @[_nc1,_nc2,_nc3,_nc4];
    //对tabbar和navbar的皮肤设置代码放在了主题模块中执行 WMThemeManager
    
    //设置UITabBarItem
    [self setupTabBarVCs];
    
    //设置导航栏控制器
    [self setupNavigationVCs];
}

//设置tabbar
-(void)setupTabBarVCs
{
    //tabbar文字颜色 normal
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:RGB(181, 181, 182)} forState:UIControlStateNormal];
    
    //tabbar文字颜色 select
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:kAppRedColor} forState:UIControlStateSelected];
    
    //tabbar背景色
    [self.tabBar setBarTintColor:[UIColor whiteColor]];
    
    //tabbar item1 图标
    UIImage* imageNormal1 = [UIImage imageNamed:@"tabbarItem1"];
    UIImage* imageSelected1 = [UIImage imageNamed:@"tabbarItem1_sec"];
    imageNormal1 = [imageNormal1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    imageSelected1 = [imageSelected1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.nc1.tabBarItem.image = imageNormal1;
    self.nc1.tabBarItem.selectedImage = imageSelected1;
    
    //tabbar item2 图标
    UIImage* imageNormal2 = [UIImage imageNamed:@"tabbarItem2"];
    UIImage* imageSelected2 = [UIImage imageNamed:@"tabbarItem2_sec"];
    imageNormal2 = [imageNormal2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    imageSelected2 = [imageSelected2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.nc2.tabBarItem.image = imageNormal2;
    self.nc2.tabBarItem.selectedImage = imageSelected2;
    
    //tabbar item3 图标
    UIImage* imageNormal3 = [UIImage imageNamed:@"tabbarItem3"];
    UIImage* imageSelected3 = [UIImage imageNamed:@"tabbarItem3_sec"];
    imageNormal3 = [imageNormal3 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    imageSelected3 = [imageSelected3 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.nc3.tabBarItem.image = imageNormal3;
    self.nc3.tabBarItem.selectedImage = imageSelected3;
    
    //tabbar item4 图标
    UIImage* imageNormal4 = [UIImage imageNamed:@"tabbarItem4"];
    UIImage* imageSelected4 = [UIImage imageNamed:@"tabbarItem4_sec"];
    imageNormal4 = [imageNormal4 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    imageSelected4 = [imageSelected4 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.nc4.tabBarItem.image = imageNormal4;
    self.nc4.tabBarItem.selectedImage = imageSelected4;
}

//设置导航栏 如果不同的vc要用到不同的nav背景色，那么调用LLBaseViewController中的函数去实现
-(void)setupNavigationVCs
{
    //状态栏颜色
    self.nc1.navigationBar.barStyle = UIBarStyleBlack; //状态栏默认白色字体 黑色背景
    self.nc2.navigationBar.barStyle = UIBarStyleBlack; //状态栏默认白色字体 黑色背景
    self.nc3.navigationBar.barStyle = UIBarStyleBlack; //状态栏默认白色字体 黑色背景
    
    //navbar 背景色
    [self.nc1.navigationBar setBarTintColor:kAppRedColor];
    [self.nc2.navigationBar setBarTintColor:kAppRedColor];
    [self.nc3.navigationBar setBarTintColor:kAppRedColor];
    
    //是否有半透明效果
    self.nc1.navigationBar.translucent = NO;
    self.nc2.navigationBar.translucent = NO;
    self.nc3.navigationBar.translucent = NO;
    
    //navbar 文字信息颜色
    [self.nc1.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self.nc2.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self.nc3.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

@end
