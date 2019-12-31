//
//  FootMarkGood.h
//  600生活
//
//  Created by iOS on 2019/11/13.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FootMarkGoodModel;
@interface FootMarkGoodModel : JSONModel

@property (nonatomic,copy) NSNumber *id;
@property (nonatomic,copy) NSNumber *volume; //销量
@property (nonatomic,copy) NSNumber *status; //状态 1-正常 0-失效
@property (nonatomic,copy) NSString *price;  //原价
@property (nonatomic,copy) NSString *title;  //商品标题
@property (nonatomic,copy) NSString *earnings;  //预估收益
@property (nonatomic,copy) NSString *coupon_money;  //优惠卷面额
@property (nonatomic,copy) NSNumber *cat;  //商品分类ID，查看相似商品时传递
@property (nonatomic,copy) NSString *quanhou_price;  //卷后价
@property (nonatomic,copy) NSString *pict_url;  //商品图片链接
@property (nonatomic,copy) NSString *item_id;  //商品ID
@property (nonatomic,copy) NSString *create_time;  //时间

@end

NS_ASSUME_NONNULL_END
