//
//  GoodStoreGoodModel.h
//  600生活
//
//  Created by iOS on 2019/11/25.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol GoodStoreGoodModel;

@interface GoodStoreGoodModel : JSONModel

@property (nonatomic,copy) NSString *shop_title;
@property (nonatomic,copy) NSString *volume;
@property (nonatomic,copy) NSString *item_id;
@property (nonatomic,copy) NSString *coupon_money;
@property (nonatomic,copy) NSString *type;  // 1-天猫 0-淘宝
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *shop_icon;
@property (nonatomic,copy) NSString *pict_url;
@property (nonatomic,copy) NSString *seller_id;
@property (nonatomic,copy) NSString *quanhou_price;
@property (nonatomic,copy) NSString *earnings;

@end

NS_ASSUME_NONNULL_END
