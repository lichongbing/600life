//
//  GoodDetailHotGoodCell.h
//  600生活
//
//  Created by iOS on 2019/11/12.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodayHotGoodModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GoodDetailHotGoodCell : UITableViewCell
/**
 leftModel: 左边传入model
 rightModel:右边传入被处理后的model
 */
-(void)fullDataWithLeftModel:(TodayHotGoodModel*)leftModel rightModel:(TodayHotGoodModel*)rightModel;

@property (nonatomic,strong) void (^goodDetailHotGoodClickedCallback)(TodayHotGoodModel* todayHotGoodModel);

@end

NS_ASSUME_NONNULL_END
