//
//  JDCarefulSelectViewController.h
//  600生活
//
//  Created by iOS on 2020/1/2.
//  Copyright © 2020 灿男科技. All rights reserved.
//

#import "SPMenuSubViewController.h"
#import "BackTopView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JDHomeController : SPMenuSubViewController

@property(nonatomic,strong) BackTopView* backTopView; //返回顶部 要在父vc中去执行

@end

NS_ASSUME_NONNULL_END
