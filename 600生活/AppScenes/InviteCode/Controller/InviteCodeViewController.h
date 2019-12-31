//
//  LoginAndRigistInviteCodeVc.h
//  600生活
//
//  Created by iOS on 2019/11/1.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface InviteCodeViewController : LLViewController

//是否展示rightItem按钮("跳过"按钮)
-(id)initWithIsShowRightItem:(BOOL)isShow;

@end

NS_ASSUME_NONNULL_END
