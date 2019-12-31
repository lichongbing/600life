//
//  SystemMsgViewController.h
//  600生活
//
//  Created by iOS on 2019/11/18.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "LLViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MsgListViewController : LLViewController

//type 1- 系统消息 2-收益消息
-(id)initWithType:(NSString*)type;

@end

NS_ASSUME_NONNULL_END
