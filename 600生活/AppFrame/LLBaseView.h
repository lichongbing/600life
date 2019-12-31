//
//  LLBaseView.h
//  SZMachinery
//
//  Created by zqjs on 2019/7/30.
//  Copyright © 2019 milanoo.com Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLBaseView : UIView

//view已经重新布局 获取布局后的frame信息
@property (nonatomic,strong) void (^viewDidLayoutNewFrameCallBack)(CGRect newFrame);

//获取view对应的控制器
-(UIViewController*)getController; //获取试图所在的控制器 小心循环引用

@end

NS_ASSUME_NONNULL_END
