//
//  HomePageRushGoodsTimeListItem.h
//  600生活
//
//  Created by iOS on 2019/11/5.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HomePageRushGoodsTimeListItem ;

@interface HomePageRushGoodsTimeListItem : JSONModel

@property (nonatomic,copy) NSNumber *check;
@property (nonatomic,copy) NSNumber *id;
@property (nonatomic,copy) NSString *time;
@property (nonatomic,copy) NSString *desc;

@end

NS_ASSUME_NONNULL_END
