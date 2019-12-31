//
//  SelectedGoodTableViewCell.h
//  600生活
//
//  Created by iOS on 2019/11/8.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectedGoodModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelectedGoodTableViewCell : UITableViewCell

-(void)fullData:(SelectedGoodModel*)selectedGoodModel;

@end

NS_ASSUME_NONNULL_END
