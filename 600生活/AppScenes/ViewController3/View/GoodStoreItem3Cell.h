//
//  GoodStoreSubTableViewCell.h
//  600生活
//
//  Created by iOS on 2019/11/21.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodStoreModel.h"    //品牌商品模型
NS_ASSUME_NONNULL_BEGIN


//有三个商品
@interface GoodStoreItem3Cell : UITableViewCell

-(void)fullData:(GoodStoreModel*)goodStoreModel;

@property (nonatomic,strong) void (^goodStoreGoodClickedCallBack)(GoodStoreGoodModel* goodStoreGoodModel);

@end

NS_ASSUME_NONNULL_END
