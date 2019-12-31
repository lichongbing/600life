//
//  OrderListViewController.h
//  600生活
//
//  Created by iOS on 2019/11/13.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "LLViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderListViewController : LLViewController

/**
 *1:所有订单
 *12：付款
 *14，订单成功（已收货）
 *3:结算
 *13，失效
 */
-(id)initWithOrderStatus:(int)orderStatus;

-(void)loadDatasWhenUserDone;  //外部调用 当用户操作时，载入数据


@end

NS_ASSUME_NONNULL_END
