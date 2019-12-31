//
//  ExcluseveTableViewCell.h
//  600生活
//
//  Created by iOS on 2019/11/21.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WelFareGoodModel.h" //独家福利购 模型

NS_ASSUME_NONNULL_BEGIN

@interface ExcluseveTableViewCell : UITableViewCell

//传入两个model
-(void)fullDataWithLeftModel:(WelFareGoodModel*)welFareGoodModel1 rightModel:(WelFareGoodModel*)welFareGoodModel2;

@property (nonatomic,strong) void (^welFareGoodClickedCallBack)(WelFareGoodModel* welFareGoodModel);
@end

NS_ASSUME_NONNULL_END
