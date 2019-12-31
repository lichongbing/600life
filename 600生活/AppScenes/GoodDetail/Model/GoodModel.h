//
//  GoodModel.h
//  600生活
//
//  Created by iOS on 2019/11/12.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "JSONModel.h"
#import "SmilarGoodModel.h"  //相似商品
#import "TodayHotGoodModel.h"  //今日热销商品

NS_ASSUME_NONNULL_BEGIN

@interface GoodModel : JSONModel

@property (nonatomic,copy) NSNumber *is_collect; //是否收藏 1-收藏 0-未收藏
@property (nonatomic,copy) NSString *title; //商品标题
@property (nonatomic,copy) NSString *shop_icon; //店铺Logo
@property (nonatomic,copy) NSString *coupon_share_url; //优惠卷链接，点击跳转使用需要拼接relationId关系ID  分享时也是分享这个str
@property (nonatomic,copy) NSString *score2;  //专家服务
@property (nonatomic,copy) NSString *shop_title; //店铺名称
@property (nonatomic,copy) NSString *monthly_sales; //月销量
@property (nonatomic,copy) NSString *all_sell_count; //总销量
@property (nonatomic,copy) NSString *pict_url;  //主图
@property (nonatomic,copy) NSString *yunfeixian;  //是否包含运费险    0不包括  1包括 ？
@property (nonatomic,copy) NSString *user_type; //是否天猫 0淘宝 1天猫
@property (nonatomic,copy) NSString *tkl;      //?????????
@property (nonatomic,copy) NSNumber *earnings;  //预估收益
@property (nonatomic,copy) NSString *cat;    //   ?
@property (nonatomic,copy) NSString *coupon_money;  //优惠卷金额
@property (nonatomic,copy) NSString *quanhou_price;   //卷后价/
@property (nonatomic,copy) NSString *item_id;   //商品ID
@property (nonatomic,copy) NSString *taobao_item_url;  //淘宝商品链接
@property (nonatomic,copy) NSString *score1;  //宝贝描述
@property (nonatomic,copy) NSString *price;   //   ?
@property (nonatomic,copy) NSString *score3;    // 物流服务
@property (nonatomic,copy) NSString *shop_url;   // 进入店铺url

@property (nonatomic,copy) NSArray<SmilarGoodModel*> *smilar_goods; //相似商品
@property (nonatomic,copy) NSArray<NSString*> *small_images;  //小图
@property (nonatomic,copy) NSArray<TodayHotGoodModel*> *today_hot_goods;  //今日热销
@property (nonatomic,copy) NSArray<NSString*> *pcDescContent;  //商品详情图

@end

NS_ASSUME_NONNULL_END
