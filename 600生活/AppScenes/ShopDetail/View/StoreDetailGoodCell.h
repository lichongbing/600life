//
//  StoreDetailGoodCell.h
//  600生活
//
//  Created by iOS on 2019/12/4.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StroeDetailGoodModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface StoreDetailGoodCell : UITableViewCell

//传入两个model
-(void)fullDataWithLeftModel:(StroeDetailGoodModel*)stroeDetailGoodModel1 rightModel:(StroeDetailGoodModel*)stroeDetailGoodModel2;


@property (nonatomic,strong) void (^storeDetailGoodClickedCallback)(StroeDetailGoodModel* stroeDetailGoodModel);

@end

NS_ASSUME_NONNULL_END
