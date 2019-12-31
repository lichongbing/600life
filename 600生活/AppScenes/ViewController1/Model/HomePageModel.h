//
//  HomePageModel.h
//  600生活
//
//  Created by iOS on 2019/11/5.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "JSONModel.h"

#import "HomePageMenuModel.h"   //首页分类菜单

#import "HomePageBannerModel.h"  //首页广告
#import "HomePageActivityModel.h" //首页活动
#import "HomePageTopModel.h"      //头条数据
#import "HomePageExclusiveModel.h"  //独家福利购
#import "HomePageJuanModel.h"     //券
#import "HomePageBestGoodModel.h"  //严选好货
#import "HomePageHotGoodModel.h"   //热销榜单排行
#import "HomePageRushGoodsModel.h"      //限时秒杀
#import "HomePageRushGoods2ItemModel.h"  //马上抢

#import "HomePageGoodsListItemModel.h"   //底部 商品列表

NS_ASSUME_NONNULL_BEGIN

@interface HomePageModel : JSONModel

/**
 * 数据来源于kHomePage 这个接口
 */
@property (nonatomic,copy) NSArray<HomePageBannerModel*> *banner_list;    //轮播图广告
@property (nonatomic,copy) NSArray<HomePageActivityModel*> *activity_list;  //活动集合
@property (nonatomic,copy) NSArray<HomePageTopModel*> *top_list;       //头条 广告
@property (nonatomic,copy) HomePageExclusiveModel *exclusive_list;     //独家福利购
@property (nonatomic,copy) NSArray<HomePageJuanModel*> *juan_store;       //万卷齐发
@property (nonatomic,copy) NSArray<HomePageBestGoodModel*> *best_goods;       //严选好货
@property (nonatomic,copy) NSArray<HomePageHotGoodModel*> *hot_goods;         //热销榜单排行
@property (nonatomic,copy) HomePageRushGoodsModel *rush_goods;                  //限时秒杀商品集合
@property (nonatomic,copy) NSArray<HomePageRushGoods2ItemModel*> *rush_goods_2;       //马上抢商品集合


/**
* 数据来源于kHomePageList 这个接口
*/
@property (nonatomic,copy) NSArray<HomePageGoodsListItemModel*> *goods_list;       //马上抢商品集合

@end

NS_ASSUME_NONNULL_END
