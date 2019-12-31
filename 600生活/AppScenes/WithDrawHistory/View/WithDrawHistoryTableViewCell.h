//
//  WithDrawHistoryTableViewCell.h
//  600生活
//
//  Created by iOS on 2019/11/19.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CashoutModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WithDrawHistoryTableViewCell : UITableViewCell

//cell点击后回调
@property (nonatomic,strong) void (^cellClickedCallback)(CashoutModel* cashoutModel);

-(void)fullData:(CashoutModel*)cashoutModel;

@end

NS_ASSUME_NONNULL_END
