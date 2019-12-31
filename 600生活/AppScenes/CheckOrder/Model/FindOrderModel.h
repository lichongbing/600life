//
//  FindOrderModel.h
//  600生活
//
//  Created by iOS on 2019/12/3.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FindOrderModel : JSONModel

@property (nonatomic,copy) NSNumber *status;
@property (nonatomic,copy) NSString *item_img;
@property (nonatomic,copy) NSNumber *id;
@property (nonatomic,copy) NSString *trade_id;
@property (nonatomic,copy) NSString *seller_shop_title;
@property (nonatomic,copy) NSString *pay_price;
@property (nonatomic,copy) NSString *tk_create_time;
@property (nonatomic,copy) NSString *item_title;
@property (nonatomic,copy) NSNumber *earnigns;
@property (nonatomic,copy) NSNumber *tk_status;

//这个字段是客户端自定义的 因为这个接口没有返回订单id
@property (nonatomic,copy) NSString *orderId;
@end

NS_ASSUME_NONNULL_END
