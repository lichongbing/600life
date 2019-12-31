//
//  IncomeRankTableViewCell.h
//  600生活
//
//  Created by iOS on 2019/12/26.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IncomeRankModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IncomeRankTableViewCell : UITableViewCell

-(void)fullData:(IncomeRankModel*)incomeRankModel indexPath:(NSIndexPath*)indexPath;

@end

NS_ASSUME_NONNULL_END
