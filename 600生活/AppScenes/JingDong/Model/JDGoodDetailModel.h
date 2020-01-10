//
//  JDGoodDetailModel.h
//  600生活
//
//  Created by iOS on 2020/1/7.
//  Copyright © 2020 灿男科技. All rights reserved.
//

#import "JSONModel.h"
#import "JDGood.h"

NS_ASSUME_NONNULL_BEGIN

@interface JDGoodDetailModel : JSONModel

@property (nonatomic,copy) NSString *shop_id;
@property (nonatomic,copy) NSString *shop_title;
@property (nonatomic,copy) NSString *earnings;
@property (nonatomic,copy) NSArray<NSString*> *small_images;
@property (nonatomic,copy) NSNumber *cat;
@property (nonatomic,copy) NSNumber *item_id;
@property (nonatomic,copy) NSArray<NSString*> *pcDescContent;
@property (nonatomic,copy) NSString *coupon_money;
@property (nonatomic,copy) NSString *shop_url;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSNumber *start_time;
@property (nonatomic,copy) NSArray<JDGood*> *recommend_list;  //推荐商品
@property (nonatomic,copy) NSNumber *end_time;
@property (nonatomic,copy) NSString *pict_url;
@property (nonatomic,copy) NSNumber *monthly_sales;
@property (nonatomic,copy) NSString *coupon_share_url;
@property (nonatomic,copy) NSString *quanhou_price;
@property (nonatomic,copy) NSNumber *user_type;

@end

NS_ASSUME_NONNULL_END
