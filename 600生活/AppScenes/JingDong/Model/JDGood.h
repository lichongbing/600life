//
//  JDHomeRecommendGood.h
//  600生活
//
//  Created by iOS on 2020/1/2.
//  Copyright © 2020 灿男科技. All rights reserved.
//  京东商品

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JDGood : JSONModel

@property (nonatomic,copy) NSNumber *coupon_amount;
@property (nonatomic,copy) NSNumber *price;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSNumber *user_type;
@property (nonatomic,copy) NSNumber *monthly_sales;
@property (nonatomic,copy) NSNumber *quanhou_price;
@property (nonatomic,copy) NSString *shop_title;
@property (nonatomic,copy) NSString *pict_url;
@property (nonatomic,copy) NSNumber *item_id;
@property (nonatomic,copy) NSString *earnings;

@end

NS_ASSUME_NONNULL_END
