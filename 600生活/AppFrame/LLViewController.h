//
//  LLViewController.h
//  tomlu
//
//  Created by Tom lu on 2019/4/30.
//  Copyright © 2019 com.luohaifang. All rights reserved.
//

#import "LLTableViewController.h"



NS_ASSUME_NONNULL_BEGIN

@interface LLViewController : LLTableViewController

//图片选择
@property (nonatomic,strong) UIImagePickerController *pickerVC;
//拍照获取图片
-(void)takePicture;
//相册选取图片
-(void)takePhoto;


///隐藏导航栏 无动画 viewdidload中调用
-(void)hiddenNavigationBar;

///显示导航栏 无动画 viewdidload中调用
-(void)showNavigationBar;

///隐藏导航栏 结合下面的方法 viewwillapear中使用
-(void)hiddenNavigationBarWithAnimation:(BOOL)animated;

///显示导航栏 结合上面的方法 viewwilldisapear中使用
-(void)showNavigationBarWithAnimation:(BOOL)animated;

///视图内容超出到状态栏 (默认情况下 不会超出状态栏 在安全线以下)
-(void)contentViewBeyondStatusBar;

//震动反馈
-(void)impactLight;

@end

NS_ASSUME_NONNULL_END
