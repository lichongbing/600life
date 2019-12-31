//
//  ZhongHeView.h
//  600生活
//
//  Created by iOS on 2019/12/9.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "LLBaseView.h"
#import "GoodSelectToolBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZhongHeView : LLBaseView

-(id)initWithToolBar:(GoodSelectToolBar*)goodSelectToolBar;

-(void)showOnSupperView:(UIView*)superView frame:(CGRect)frame;

-(void)dismiss;


@end

NS_ASSUME_NONNULL_END
