//
//  IncomeDetailSubViewController.h
//  600生活
//
//  Created by iOS on 2020/1/6.
//  Copyright © 2020 灿男科技. All rights reserved.
//

#import "LLViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface IncomeDetailSubViewController : LLViewController

//0 个人收益明细    1 推广收益明细
-(id)initWithType:(int)type;

@property(nonatomic,strong)NSString* time;  //保存用户选取的时间 YYYY-MM

@end

NS_ASSUME_NONNULL_END
