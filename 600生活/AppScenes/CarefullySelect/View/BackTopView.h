//
//  BackTopView.h
//  600生活
//
//  Created by iOS on 2019/12/11.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "LLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BackTopView : LLBaseView

//找相似 被点击
@property (nonatomic,strong) void (^backTopViewClickedCallBack)(void);

@end

NS_ASSUME_NONNULL_END
