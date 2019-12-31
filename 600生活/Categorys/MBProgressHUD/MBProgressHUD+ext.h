//
//  MBProgressHUD+ext.h
//  600生活
//
//  Created by iOS on 2019/12/27.
//  Copyright © 2019 灿男科技. All rights reserved.



#import "MBProgressHUD.h"
#import "HudCustomImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (ext)

-(void)addAnimation;

//lhf - 老板需求 隐藏背景view
-(void)hiddenMBBackgroundEffectView;

@end

NS_ASSUME_NONNULL_END
