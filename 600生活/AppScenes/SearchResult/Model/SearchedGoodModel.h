//
//  SearchedGoodModel.h
//  600生活
//
//  Created by iOS on 2019/11/18.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchedGoodModel : JSONModel

@property (nonatomic,copy) NSNumber *forecast_earnings;
@property (nonatomic,copy) NSString *coupon_money;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *user_type;
@property (nonatomic,copy) NSString *monthly_sales;
@property (nonatomic,copy) NSString *coupon_id;
@property (nonatomic,copy) NSString *shop_title;
@property (nonatomic,copy) NSString *pict_url;
@property (nonatomic,copy) NSString *item_id;
@property (nonatomic,copy) NSString *quanhou_price;

@end

NS_ASSUME_NONNULL_END
