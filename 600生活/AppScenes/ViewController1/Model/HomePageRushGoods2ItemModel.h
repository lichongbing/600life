//
//  HomePageRushGoods2ItemModel.h
//  600生活
//
//  Created by iOS on 2019/11/5.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol HomePageRushGoods2ItemModel;

@interface HomePageRushGoods2ItemModel : JSONModel

@property (nonatomic,copy) NSString *label;
@property (nonatomic,copy) NSNumber *id;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *coupon_total_count;
@property (nonatomic,copy) NSString *coupon_remain_count;
@property (nonatomic,copy) NSString *quanhou_price;
@property (nonatomic,copy) NSString *coupon_money;  //优惠券 金额
@property (nonatomic,copy) NSString *pict_url;
@property (nonatomic,copy) NSString *item_id;
@property (nonatomic,copy) NSString *earnings;

@property (nonatomic,copy) NSString *type;  //马上抢中没有这个字段，分页中有这个字段

@end

NS_ASSUME_NONNULL_END
