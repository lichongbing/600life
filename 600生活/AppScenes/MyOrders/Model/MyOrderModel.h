//
//  MyOrderModel.h
//  600生活
//
//  Created by iOS on 2019/11/13.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MyOrderModel;

@interface MyOrderModel : JSONModel

@property (nonatomic,copy) NSNumber *uid;  //用户id
@property (nonatomic,copy) NSString *item_img;  //商品图片
@property (nonatomic,copy) NSNumber *id;   //订单id
@property (nonatomic,copy) NSString *seller_shop_title;  //店铺名称
@property (nonatomic,copy) NSString *pay_price;  //支付金额
@property (nonatomic,copy) NSString *trade_id;  //订单号
@property (nonatomic,copy) NSString *tk_create_time;  //订单创建时间
@property (nonatomic,copy) NSString *item_title;  //商品标题
@property (nonatomic,copy) NSString *uid_earnings;  //用户收益
@property (nonatomic,copy) NSNumber *tk_status;  //订单状态 3：订单结算，12：订单付款， 13：订单失效，14：订单成功',

@end

NS_ASSUME_NONNULL_END
