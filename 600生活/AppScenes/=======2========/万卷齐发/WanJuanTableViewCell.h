//
//  WanJuanTableViewCell.h
//  600生活
//
//  Created by iOS on 2019/11/21.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponGood.h"

NS_ASSUME_NONNULL_BEGIN

@interface WanJuanTableViewCell : UITableViewCell

//传入两个model
-(void)fullDataWithLeftModel:(CouponGood*)couponGood1 rightModel:(CouponGood*)couponGood2;

@property (nonatomic,strong) void (^couponGoodClickedCallBack)(CouponGood* couponGood);

@end

NS_ASSUME_NONNULL_END
