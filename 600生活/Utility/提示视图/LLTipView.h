//
//  LLTipView.h
//  600生活
//
//  Created by iOS on 2019/11/11.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "LLBaseView.h"


///风格
typedef NS_ENUM(NSInteger,LLTipViewType)
{
    LLTipViewTypeNormal = 0,  //正常type 只有图片和文字
    LLTipViewTypeNoNet        //无网络type  除了图片文字 还 多了一个按钮
};

NS_ASSUME_NONNULL_BEGIN

@interface LLTipView : LLBaseView

//当前tipView的类型
@property(nonatomic,assign)LLTipViewType type;

/**
 type 风格，除了无网络外 都传0
 iconName 图片名
 msg 提示信息
 */
-(instancetype)initWithType:(LLTipViewType)type
         iconName:(NSString*)iconName
              msg:(NSString*)msg
        superView:(UIView*)superView;

//刷新按钮被点击后回调
@property (nonatomic,strong) void (^refreshBtnCallback)(void);


@end

NS_ASSUME_NONNULL_END
