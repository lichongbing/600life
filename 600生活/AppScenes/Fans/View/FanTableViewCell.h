//
//  FanTableViewCell.h
//  600生活
//
//  Created by iOS on 2019/11/18.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FansModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FanTableViewCell : UITableViewCell

-(void)fullData:(FansModel*)fansModel;

@end

NS_ASSUME_NONNULL_END
