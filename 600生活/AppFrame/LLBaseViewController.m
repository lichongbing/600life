//
//  LLBaseViewController.m
//  tomlu
//
//  Created by Tom lu on 2019/4/30.
//  Copyright © 2019 com.luohaifang. All rights reserved.
//

#import "LLBaseViewController.h"
#import "NSString+ext.h"  //字符串宽高
#import "UIImage+ext.h"

@interface LLBaseViewController ()

@end

@implementation LLBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //去除navBar下方横线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    //该版本设置为无translucent效果(默认有毛玻璃效果)默认为YES
    self.navigationController.navigationBar.translucent = NO;
    //view背景色
    self.view.backgroundColor = kAppBackGroundColor;
    
    //有侧滑效果 侧滑效果设置放到了LLBaseNavigationController中处理
//    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    //更改navBar高度  ios11 以上
    self.navigationController.navigationBar.frame = CGRectMake(0, kStatusBarHeight, kScreenWidth, kNavigationBarHeight);
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setNavBarWhiteColor]; //navBar白色
    [self setNavBackItemBlack]; //nav back item 黑色
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

//设置状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    if(kIsIOS13()){
         return UIStatusBarStyleDarkContent;
    }else{
        return UIStatusBarStyleDefault; //黑色文字
    }
}

#pragma mark - navbar
//leftItem 图片
-(void)setNavLeftItemWithImageName:(NSString*)imageName
                          selector:(SEL)sel
{
    UIImage *image = [UIImage imageNamed:imageName];
    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 44, 44)];
    [button setImage:image forState:UIControlStateNormal];
    UIView* btnBgView =  [[UIView alloc] initWithFrame:button.bounds];
    [btnBgView setContentMode:UIViewContentModeTopLeft];
    [btnBgView addSubview:button];
    
    if (sel != nil) {
        [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    } else {
        button.enabled = NO;
    }
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btnBgView];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    self.navigationController.navigationBar.userInteractionEnabled = NO;
}

//rightItem 图片
-(void)setNavRightItemWithImage:(UIImage *)image
                       selector:(SEL)sel
{
    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 44, 25)];
    [button setImage:image forState:UIControlStateNormal];
    if(!self.navigationItem.rightBarButtonItem){
        self.navigationItem.rightBarButtonItem.customView =  button;
    }
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setRightBarButtonItem:rightItem];
    if (sel != nil) {
        [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    } else {
        button.enabled = NO;
    }
}

//LeftItem 文字
-(void)setNavLeftItemWithTitle:(NSString*)titleStr
                    titleColor:(UIColor*)titleColor
                      selector:(SEL)sel
{
    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 50, 44)];
    [button setTitle:titleStr forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    if (sel != nil) {
        [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    } else {
        button.enabled = NO;
    }
}

//RightItem 文字
-(void)setNavRightItemWithTitle:(NSString*)titleStr
                     titleColor:(UIColor*)titleColor
                       selector:(SEL)sel
{
    UIButton *button;
    //判断是否存在button
    if(!self.navigationItem.rightBarButtonItem){
        button = [UIButton buttonWithType: UIButtonTypeCustom];
    }else{
        button =  self.navigationItem.rightBarButtonItem.customView;
    }
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.frame = CGRectMake(0, 0, 35, 20);
    if (titleStr.length > 3) {
        button.width = [titleStr sizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, button.height)].width;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }else
        if (titleStr.length > 2) {
            button.width = button.width + 30;
        }else{
            button.width = button.width + 10;
        }
    
    button.left = 0;
    button.top = 0;
    [button setTitle:titleStr forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
    if (sel != nil) {
        [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    } else {
        button.enabled = NO;
    }
}

//nav backItem 隐藏
-(void)setNavBackItemHidden
{
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
    [self.navigationItem setLeftBarButtonItem:backBarButtonItem];
}

//返回-箭头黑色 （或者深色）
-(void)setNavBackItemBlack
{
    [self setNavLeftItemWithImageName:@"nav_back_black" selector:@selector(navBackItemAction)];
}

//返回-箭头白色 （或者浅色）
-(void)setNavBackItemWhite
{
    [self setNavLeftItemWithImageName:@"nav_back_white" selector:@selector(navBackItemAction)];
}

//黑色navbar背景（或者改为深色）
-(void)setNavBarBlackColor
{
    //状态栏
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    //黑色navBar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor blackColor]] forBarMetrics:UIBarMetricsDefault];
    
    //返回按钮颜色 kNaviBarBackItemColor
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //barButtonItem颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

//红色navbar背景
-(void)setNavBarRedColor
{
    //状态栏
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    //红色navBar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#F54556"]] forBarMetrics:UIBarMetricsDefault];
    
    //文字颜色 白色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //barButtonItem颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

//白色navbar背景 (或者改为浅色)
-(void)setNavBarWhiteColor
{
    //状态栏 黑色文字
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    //narBar白色背景
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    
    //返回按钮颜色 kNaviBarBackItemColor
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    //barButtonItem颜色 黑色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:[UIColor blackColor]}];
}

///紫色渐变navbar背景
-(void)setNavBarPurpleGradientColor
{
    //状态栏 白色文字
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    //narBar紫色背景
    CGRect frame = CGRectMake(0, 0, kScreenWidth, kStatusBarHeight+ kNavigationBarHeight);
    UIImageView *imgview = [[UIImageView alloc]initWithFrame:frame];
    UIGraphicsBeginImageContext(imgview.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGContextScaleCTM(context, frame.size.width, frame.size.height);
    CGFloat colors[] = {
        70.0/255.0, 6/255.0, 241/255.0, 1.0,
        164/255.0, 49/255.0, 216/255.0, 1.0,
    };
    
    CGGradientRef backGradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
    CGColorSpaceRelease(rgb);
    
    //设置颜色渐变的方向，范围在(0,0)与(1.0,1.0)之间，如(0,0)(1.0,0)代表水平方向渐变,(0,0)(0,1.0)代表竖直方向渐变
    CGContextDrawLinearGradient(context, backGradient, CGPointMake(0, 0), CGPointMake(1.0, 0), kCGGradientDrawsBeforeStartLocation);
    
    [self.navigationController.navigationBar setBackgroundImage:UIGraphicsGetImageFromCurrentImageContext()  forBarMetrics:UIBarMetricsDefault];
    
    //返回按钮颜色 白色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //barButtonItem颜色 白色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

///浅蓝色navbar背景
-(void)setNavBarLightBlueColor
{
    //状态栏 白色文字
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    //narBar浅蓝  浅紫
    CGRect frame = CGRectMake(0, 0, kScreenWidth, kStatusBarHeight+ kNavigationBarHeight);
    UIImageView *imgview = [[UIImageView alloc]initWithFrame:frame];
    UIGraphicsBeginImageContext(imgview.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGContextScaleCTM(context, frame.size.width, frame.size.height);
    CGFloat colors[] = {
        83/255.0, 151/255.0, 255/255.0, 1.0,
        150.0/255.0, 119/255.0, 254/255.0, 1.0,
    };
    
    CGGradientRef backGradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
    CGColorSpaceRelease(rgb);
    
    //设置颜色渐变的方向，范围在(0,0)与(1.0,1.0)之间，如(0,0)(1.0,0)代表水平方向渐变,(0,0)(0,1.0)代表竖直方向渐变
    CGContextDrawLinearGradient(context, backGradient, CGPointMake(0, 0), CGPointMake(1.0, 0), kCGGradientDrawsBeforeStartLocation);
    
    [self.navigationController.navigationBar setBackgroundImage:UIGraphicsGetImageFromCurrentImageContext()  forBarMetrics:UIBarMetricsDefault];
    
    //返回按钮颜色 白色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //barButtonItem颜色 白色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
}


//设置navBar透明色
-(void)setNavBarClearColor
{
    //状态栏 黑色文字
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    //narBar 透明色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    
    //返回按钮颜色 透明色
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    
    //barButtonItem 透明色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:[UIColor clearColor]}];
}


//快撮撮蓝色背景
-(void)setNavBarKccColor
{
    //状态栏 白色文字
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    //narBar 红色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kAppRedColor] forBarMetrics:UIBarMetricsDefault];
    
    //返回按钮颜色 白色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //barButtonItem 透明色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

///清空navBar的图片
-(void)setBavBarEmpty
{
    //navbar 背景图 默认  nil
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    //状态栏 默认色 (黑色文字)
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

//默认的navbackitem点击响应
-(void)navBackItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}






@end
