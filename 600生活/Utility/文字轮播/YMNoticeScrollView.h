//
//  YMNoticeScrollView.h
//  600生活
//
//  Created by iOS on 2019/11/7.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YMNoticeScrollViewDelegate
  
@optional
/// 点击代理
- (void)noticeScrollDidClickAtIndex:(NSInteger)index content:(NSString *)content;
  
@end

@interface YMNoticeScrollView : UIView

@property (nonatomic, weak) id<YMNoticeScrollViewDelegate> delegate;

/// 滚动文字数组
@property (nonatomic, strong) NSArray *contents;
  
/// 文字停留时长，默认4S
@property (nonatomic, assign) NSTimeInterval timeInterval;
  
/// 文字滚动时长，默认0.3S
@property (nonatomic, assign) NSTimeInterval scrollTimeInterval;

@end

NS_ASSUME_NONNULL_END
