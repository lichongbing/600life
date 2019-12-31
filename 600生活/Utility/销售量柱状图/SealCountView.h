//
//  SealCountView.h
//  600生活
//
//  Created by iOS on 2019/11/26.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "LLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SealCountView : LLBaseView

//0到1 展示售出的比例
@property(nonatomic,assign)CGFloat ratio;

//售出多少件
@property(nonatomic,assign)NSInteger sealCount;
@end

NS_ASSUME_NONNULL_END
