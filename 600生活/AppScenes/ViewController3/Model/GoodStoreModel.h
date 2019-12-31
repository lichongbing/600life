//
//  GoodStoreModel.h
//  600生活
//
//  Created by iOS on 2019/11/25.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "JSONModel.h"
#import "GoodStoreGoodModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface GoodStoreModel : JSONModel

@property (nonatomic,copy) NSString *shop_title;
@property (nonatomic,copy) NSString *shop_icon;
@property (nonatomic,copy) NSArray<GoodStoreGoodModel*> *goods_list;  //品牌 商品模型
@property (nonatomic,copy) NSString *seller_id;

@end

NS_ASSUME_NONNULL_END
