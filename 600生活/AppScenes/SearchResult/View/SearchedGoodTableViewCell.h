//
//  SearchedGoodTableViewCell.h
//  600生活
//
//  Created by iOS on 2019/11/18.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchedGoodModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchedGoodTableViewCell : UITableViewCell


-(void)fullData:(SearchedGoodModel*)searchedGoodModel keywords:(NSString*)keywords;

@end

NS_ASSUME_NONNULL_END
