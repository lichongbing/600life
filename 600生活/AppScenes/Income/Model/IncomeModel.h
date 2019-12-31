//
//  IncomeModel.h
//  600生活
//
//  Created by iOS on 2019/12/2.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IncomeModel : JSONModel

@property (nonatomic,copy) NSNumber *today_other; //今日其它金额
@property (nonatomic,copy) NSNumber *last_month_settlement; //上月结算金额
@property (nonatomic,copy) NSNumber *today_order_count; //本月付款笔数
@property (nonatomic,copy) NSString *total_earnings; //累积收益
@property (nonatomic,copy) NSNumber *today_forecast; //今日预估收益 金额
@property (nonatomic,copy) NSNumber *month_forecast; //本月预估金额
@property (nonatomic,copy) NSNumber *month_order_count; //本月付款笔数
@property (nonatomic,copy) NSString *balance; //余额
@property (nonatomic,copy) NSNumber *month_other;//本月其它金额

@end

NS_ASSUME_NONNULL_END
