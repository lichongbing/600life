//
//  JDHomeRecommendTableViewCell.h
//  600生活
//
//  Created by iOS on 2020/1/2.
//  Copyright © 2020 灿男科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDGood.h"
NS_ASSUME_NONNULL_BEGIN

@interface JDTwoItemGoodTableViewCell : UITableViewCell

//传入两个model
-(void)fullDataWithLeftModel:(JDGood*)jdHomeRecommendGood1 rightModel:(JDGood*)jdHomeRecommendGood2;

@property (nonatomic,strong) void (^jdTwoItemOneGoodClickedCallback)(JDGood* jdGood);

@end

NS_ASSUME_NONNULL_END
