//
//  FootMarkTableViewCell.h
//  600生活
//
//  Created by iOS on 2019/11/13.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FootMarkGoodModel.h"  //足迹商品模型


NS_ASSUME_NONNULL_BEGIN

@interface FootMarkTableViewCell : UITableViewCell

-(void)fullData:(FootMarkGoodModel*)footMarkGoodModel;


//找相似 被点击
@property (nonatomic,strong) void (^similarBtnClickedCallback)(FootMarkGoodModel* footMarkGoodModel);
@end

NS_ASSUME_NONNULL_END
