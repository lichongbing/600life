//
//  CollectionGoodModel.h
//  600生活
//
//  Created by iOS on 2019/12/6.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CollectedGoodModel : JSONModel

@property (nonatomic,copy) NSNumber *id;
@property (nonatomic,copy) NSNumber *volume;
@property (nonatomic,copy) NSString *earnings;
@property (nonatomic,copy) NSNumber *cat;
@property (nonatomic,copy) NSString *item_id;
@property (nonatomic,copy) NSString *coupon_money;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *pict_url;
@property (nonatomic,copy) NSString *create_time;
@property (nonatomic,copy) NSNumber *status;
@property (nonatomic,copy) NSString *quanhou_price;

@end

NS_ASSUME_NONNULL_END
