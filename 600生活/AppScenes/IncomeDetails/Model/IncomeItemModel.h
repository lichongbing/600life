//
//  IncomeItemModel.h
//  600生活
//
//  Created by iOS on 2019/12/2.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IncomeItemModel : JSONModel

@property (nonatomic,copy) NSString *pay_price;
@property (nonatomic,copy) NSNumber *id;
@property (nonatomic,copy) NSString *earnings;
@property (nonatomic,copy) NSString *item_title;
@property (nonatomic,copy) NSString *trade_id;
@property (nonatomic,copy) NSNumber *create_time; //创建时间

@end

NS_ASSUME_NONNULL_END
