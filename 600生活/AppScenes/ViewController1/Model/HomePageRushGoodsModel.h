//
//  HomePageRushGoods.h
//  600生活
//
//  Created by iOS on 2019/11/5.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "JSONModel.h"

#import "HomePageRushGoodsListItem.h"
#import "HomePageRushGoodsTimeListItem.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HomePageRushGoodsModel;

@interface HomePageRushGoodsModel : JSONModel

@property (nonatomic,copy) NSNumber *end_time;
@property (nonatomic,copy) NSArray<HomePageRushGoodsListItem*> *list;
@property (nonatomic,copy) NSArray<HomePageRushGoodsTimeListItem*> *time_list;

@end

NS_ASSUME_NONNULL_END
