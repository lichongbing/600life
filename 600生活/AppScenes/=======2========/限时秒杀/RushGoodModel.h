//
//  RushGoodModel.h
//  600生活
//
//  Created by iOS on 2019/11/20.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RushGoodModel : JSONModel

@property (nonatomic,copy) NSNumber *is_rob;
@property (nonatomic,copy) NSString *coupon_remain_count;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSNumber *earnings;
@property (nonatomic,copy) NSString *coupon_money;
@property (nonatomic,copy) NSString *label;
@property (nonatomic,copy) NSString *quanhou_price;
@property (nonatomic,copy) NSString *coupon_total_count;
@property (nonatomic,copy) NSString *pict_url;
@property (nonatomic,copy) NSString *item_id;

@end

NS_ASSUME_NONNULL_END
