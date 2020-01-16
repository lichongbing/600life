//
//  HYX_BtnTopImgBottomLab.h
//  600生活
//
//  Created by iOS on 2020/1/16.
//  Copyright © 2020 灿男科技. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma 自己写的Btn扩展类，一个按钮上边图片、下边文字

NS_ASSUME_NONNULL_BEGIN
@interface HYX_BtnTopImgBottomLab : UIButton

@property (nonatomic,strong)UIImageView *btn_topImg;//图标
@property (nonatomic,strong)UILabel *btn_bottomLab;//文字

@end

NS_ASSUME_NONNULL_END
