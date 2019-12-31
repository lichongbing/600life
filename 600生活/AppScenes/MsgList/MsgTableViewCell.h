//
//  SystemMsgTableViewCell.h
//  600生活
//
//  Created by iOS on 2019/11/18.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MsgTableViewCell : UITableViewCell

-(void)fullData:(MsgModel*)msgModel;

//cell点击后回调
@property (nonatomic,strong) void (^cellClickedCallback)(MsgModel* msgModel);


//隐藏红点
-(void)hiddenRedDot;

@end

NS_ASSUME_NONNULL_END
