//
//  GoodSelectToolBar.h
//  600生活
//
//  Created by iOS on 2019/11/8.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLBaseView.h"
NS_ASSUME_NONNULL_BEGIN


/**
 *GoodSelectToolBarTypeDefault 包含最新
 *GoodSelectToolBarType1 不包含最新
 */

typedef NS_ENUM(NSUInteger, GoodSelectToolBarType) {
    GoodSelectToolBarTypeDefault  = 0,
    GoodSelectToolBarType1
};

@class GoodSelectToolBar;

@protocol GoodSelectToolBarDelegate <NSObject>

@optional

- (void)goodSelectToolBarDidSelecedWithSort:(int)sort goodSelectToolBar:(GoodSelectToolBar*)goodSelectToolBar;

@end

/**
 商品搜索sort值:
 0: 不传递sort字段给后台
 1：综合排序
 2：佣金比例由大到小
 3：预估收益由高到低
 4：价格由大到小
 5：价格由小到大
 6：月销量由大到小
 7：月销量由小到大
 */

@interface GoodSelectToolBar : LLBaseView

@property(nonatomic,assign)id<GoodSelectToolBarDelegate> delegate;

-(id)initWithGoodSelectToolBarType:(GoodSelectToolBarType)type;
/**
 用户切换sort 调用这个后不会再回调delegate
 */
-(void)setSort:(int)sort;

@end

NS_ASSUME_NONNULL_END
