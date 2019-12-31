//
//  TwoGoodItemsTableViewCell.h
//  600生活
//
//  Created by iOS on 2019/11/7.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuessLikeGoodModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TwoGoodItemsTableViewCell : UITableViewCell

//传入两个model
-(void)fullDataWithLeftModel:(GuessLikeGoodModel*)guessLikeGoodModel1 rightModel:(GuessLikeGoodModel*)guessLikeGoodModel2;

@property (nonatomic,strong) void (^guessLikeGoodClickedCallback)(GuessLikeGoodModel* guessLikeGoodModel);

@end

NS_ASSUME_NONNULL_END
