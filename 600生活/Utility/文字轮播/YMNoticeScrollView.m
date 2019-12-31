//
//  YMNoticeScrollView.m
//  600生活
//
//  Created by iOS on 2019/11/7.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "YMNoticeScrollView.h"

@implementation YMNoticeScrollView
{
    UILabel *_scrollLbl;
    NSTimer *_timer;
    NSUInteger _count;
    CGFloat Width;
    CGFloat Height;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    Width = kScreenWidth - 136 - 25;
    Height = self.height;
    _timeInterval = 4;
    _scrollTimeInterval = 0.3;
    [self initSubViews];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        Width =kScreenWidth - 136 - 25;
        Height = frame.size.height;
        _timeInterval = 4;
        _scrollTimeInterval = 0.3;
        [self initSubViews];
    }
    return self;
}


/// 创建Label
- (void)initSubViews {
    self.clipsToBounds = YES;
    _scrollLbl.backgroundColor = [UIColor clearColor];
    _scrollLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
    _scrollLbl.textColor =[UIColor colorWithHexString:@"#333333"];
    _scrollLbl.font = [UIFont systemFontOfSize:13];
    _scrollLbl.numberOfLines = 2;
    _scrollLbl.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction)];
    [_scrollLbl addGestureRecognizer:tap];
    [self addSubview:_scrollLbl];
}
// 开启定时器
- (void)startTimer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:_timeInterval target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}
  
/// 定时器方法
- (void)timerMethod {
    _count++;
    if (_count == _contents.count) {
        _count = 0;
    }
    /// 两次动画实现类似UIScrollView的滚动效果，控制坐标和隐藏状态
    [UIView animateWithDuration:_scrollTimeInterval animations:^{
        _scrollLbl.frame = CGRectMake(0, -Height, Width, Height);
    } completion:^(BOOL finished) {
        _scrollLbl.hidden = YES;
        _scrollLbl.frame = CGRectMake(0, Height, Width, Height);
        _scrollLbl.hidden = NO;
        [UIView animateWithDuration:_scrollTimeInterval animations:^{
            _scrollLbl.text = [self getCurrentContent];
            _scrollLbl.frame = CGRectMake(0, 0, Width, Height);
        } completion:^(BOOL finished) {
              
        }];
    }];
}
/// 获取要展示的内容数组
- (void)setContents:(NSArray *)contents {
    // 判断是否要重新赋值
    if ([self array:contents isEqualTo:_contents]) {
          
        return;
    }
    _contents = contents;
    [self reset];
    if (!contents || contents.count == 0) {
        return;
    }
    [self startTimer];
}
  
/// 重置初始状态
- (void)reset {
      
    _count = 0;
    _scrollLbl.frame = CGRectMake(0, 0, Width, Height);
    _scrollLbl.text = [self getCurrentContent];
    [_timer invalidate];
    _timer = nil;
}
/// 获取当前要展示的内容
- (NSString *)getCurrentContent {
    if (!_contents || _contents.count == 0) {
        return nil;
    }
    return _contents[_count];
}
/// 比较两个数组内容是否相同
- (BOOL)array:(NSArray *)array1 isEqualTo:(NSArray *)array2 {
    if (array1.count != array2.count) {
        return NO;
    }
    for (NSString *str in array1) {
        if (![array2 containsObject:str]) {
            return NO;
        }
    }
    return YES;
}
/// 点击事件
- (void)clickAction {
      
    if (_delegate && [(id)_delegate respondsToSelector:@selector(noticeScrollDidClickAtIndex:content:)]) {
        [_delegate noticeScrollDidClickAtIndex:_count content:_contents[_count]];
    }
}

@end
