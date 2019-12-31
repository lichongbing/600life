//
//  CashoutModel.h
//  600生活
//
//  Created by iOS on 2019/12/2.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CashoutModel : JSONModel

@property (nonatomic,copy) NSNumber *status; //状态 状态0-待审核 1-已通过 2-拒绝
@property (nonatomic,copy) NSString *remark;
@property (nonatomic,copy) NSString *success_time;
@property (nonatomic,copy) NSNumber *id;
@property (nonatomic,copy) NSString *trade_id;
@property (nonatomic,copy) NSString *create_time;
@property (nonatomic,copy) NSString *money;

@property(nonatomic,assign)BOOL isShowDetailInfo; //是否展示详信息,客户端添加

@end

NS_ASSUME_NONNULL_END
