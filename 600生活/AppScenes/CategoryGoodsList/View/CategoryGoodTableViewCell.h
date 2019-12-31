//
//  CategoryGoodTableViewCell.h
//  600生活
//
//  Created by iOS on 2019/12/11.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryGoodModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CategoryGoodTableViewCell : UITableViewCell

-(void)fullData:(CategoryGoodModel*)categoryGoodModel keywords:(NSString*)keywords;

@end

NS_ASSUME_NONNULL_END
