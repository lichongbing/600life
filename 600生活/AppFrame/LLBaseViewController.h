//
//  LLBaseViewController.h
//  tomlu
//
//  Created by Tom lu on 2019/4/30.
//  Copyright © 2019 com.luohaifang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLBaseViewController : UIViewController


#pragma mark - 导航栏处理
///leftItem 图片
-(void)setNavLeftItemWithImageName:(NSString*)imageName
                          selector:(SEL)sel;

///rightItem 图片
-(void)setNavRightItemWithImage:(UIImage *)image
                       selector:(SEL)sel;

///LeftItem 文字
-(void)setNavLeftItemWithTitle:(NSString*)titleStr
                    titleColor:(UIColor*)titleColor
                      selector:(SEL)sel;

///RightItem 文字
-(void)setNavRightItemWithTitle:(NSString*)titleStr
                     titleColor:(UIColor*)titleColor
                       selector:(SEL)sel;

///nav backItem 隐藏
-(void)setNavBackItemHidden;

///nav backItem-箭头黑色
-(void)setNavBackItemBlack;

///nav backItem-箭头白色
-(void)setNavBackItemWhite;

///黑色navbar背景（或者改为深色） （整体nav生效）
-(void)setNavBarBlackColor;

//红色navbar背景
-(void)setNavBarRedColor;

///白色navbar背景 (或者改为浅色) （整体nav生效）
-(void)setNavBarWhiteColor;

///紫色渐变navbar背景          （整体nav生效）
-(void)setNavBarPurpleGradientColor;

///浅蓝色navbar背景
-(void)setNavBarLightBlueColor;

///设置navBar透明色  (整体nav生效)
-(void)setNavBarClearColor;

//快撮撮蓝色背景
-(void)setNavBarKccColor;

///清空navBar的图片
-(void)setBavBarEmpty;


///navBar透明度  三方
//-(void)setNavBarAlpha:(CGFloat)alpha; //UINavigationController+Smoonth.h

///默认的navbackitem点击响应   特殊控制器需重写(if need)
-(void)navBackItemAction;


@end

NS_ASSUME_NONNULL_END
