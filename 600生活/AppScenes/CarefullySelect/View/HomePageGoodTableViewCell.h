//
//  HomePageGoodTableViewCell.h
//  600生活
//
//  Created by iOS on 2019/11/7.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageGoodsListItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomePageGoodTableViewCell : UITableViewCell

-(void)fullData:(HomePageGoodsListItemModel*)homePageGoodsListItemModel;

@end

NS_ASSUME_NONNULL_END
