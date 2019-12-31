//
//  StroeDetailGoodModel.h
//  600生活
//
//  Created by iOS on 2019/12/4.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface StroeDetailGoodModel : JSONModel

@property (nonatomic,copy) NSString *volume;
@property (nonatomic,copy) NSString *shop_icon;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *earnings;
@property (nonatomic,copy) NSString *coupon_money;
@property (nonatomic,copy) NSString *quanhou_price;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *pict_url;
@property (nonatomic,copy) NSString *shop_title;
@property (nonatomic,copy) NSString *item_id;

@end

NS_ASSUME_NONNULL_END
