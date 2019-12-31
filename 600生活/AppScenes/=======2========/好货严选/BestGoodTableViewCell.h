//
//  BestGoodTableViewCell.h
//  600生活
//
//  Created by iOS on 2019/11/22.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BestSelectGoodModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BestGoodTableViewCell : UITableViewCell

-(void)fullData:(BestSelectGoodModel*)bestSelectGoodModel;

@end

NS_ASSUME_NONNULL_END
