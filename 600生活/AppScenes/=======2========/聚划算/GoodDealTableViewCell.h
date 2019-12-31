//
//  GoodDealTableViewCell.h
//  600生活
//
//  Created by iOS on 2019/11/21.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodDealGood.h"

NS_ASSUME_NONNULL_BEGIN

@interface GoodDealTableViewCell : UITableViewCell

-(void)fullData:(GoodDealGood*)goodDealGood;

@end

NS_ASSUME_NONNULL_END
