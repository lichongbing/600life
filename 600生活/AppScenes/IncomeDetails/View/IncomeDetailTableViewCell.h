//
//  IncomeDetailTableViewCell.h
//  600生活
//
//  Created by iOS on 2019/11/14.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IncomeItemModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface IncomeDetailTableViewCell : UITableViewCell

-(void)fullData:(IncomeItemModel*)incomeItemModel;

@end

NS_ASSUME_NONNULL_END
