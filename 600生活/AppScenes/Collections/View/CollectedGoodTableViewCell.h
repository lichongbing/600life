//
//  CollectedGoodTableViewCell.h
//  600生活
//
//  Created by iOS on 2019/11/13.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectedGoodModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CollectedGoodTableViewCell : UITableViewCell

-(void)fullData:(CollectedGoodModel*)collectedGoodModel;

@end

NS_ASSUME_NONNULL_END
