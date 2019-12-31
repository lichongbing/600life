//
//  MyOrderTableViewCell.h
//  600生活
//
//  Created by iOS on 2019/11/13.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyOrderTableViewCell : UITableViewCell

-(void)fullData:(MyOrderModel*)myOrderModel;

//订单查询需要调用
-(void)resetIncomeLabWithStatus:(NSNumber*)Status;


@end

NS_ASSUME_NONNULL_END
