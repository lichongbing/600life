//
//  GoodStoreItem1Cell.h
//  600生活
//
//  Created by iOS on 2019/12/4.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodStoreModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GoodStoreItem1Cell : UITableViewCell

-(void)fullData:(GoodStoreModel*)goodStoreModel;

@property (nonatomic,strong) void (^goodStoreGoodClickedCallBack)(GoodStoreGoodModel* goodStoreGoodModel);
@end

NS_ASSUME_NONNULL_END
