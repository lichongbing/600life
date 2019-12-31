//
//  MsgModel.h
//  600生活
//
//  Created by iOS on 2019/12/5.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MsgModel : JSONModel

@property (nonatomic,copy) NSNumber *id;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *create_time;
@property (nonatomic,copy) NSNumber *read; //1-已读消息 0-未读

//客户端自定义参数是否展示更多
@property(nonatomic,assign)BOOL isShowDetailInfo;


@end

NS_ASSUME_NONNULL_END
