//
//  HotRecommendTableViewCell.h
//  600生活
//
//  Created by iOS on 2019/11/20.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotRecommendGood.h"
NS_ASSUME_NONNULL_BEGIN

@interface HotRecommendTableViewCell : UITableViewCell

-(void)fullDataWithLeftModel:(HotRecommendGood*)hotRecommendGood1 rightModel:(HotRecommendGood*)hotRecommendGood2;

@property (nonatomic,strong) void (^hotRecommendGoodClickedCallback)(HotRecommendGood* hotRecommendGood);

@end

NS_ASSUME_NONNULL_END
