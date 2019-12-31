//
//  LLBaseView.m
//  SZMachinery
//
//  Created by zqjs on 2019/7/30.
//  Copyright © 2019 milanoo.com Co., Ltd. All rights reserved.
//

#import "LLBaseView.h"

@implementation LLBaseView

-(void)dealloc
{
    NSLog(@"%@视图(%p)------已被释放",NSStringFromClass([self class]),self);
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //view 已经重新布局
    if(self.viewDidLayoutNewFrameCallBack){
        self.viewDidLayoutNewFrameCallBack(self.frame);
    }
}

-(UIViewController*)getController{
    UIViewController *vc = nil;
    for (UIView *temp = self; temp;temp = temp.superview) {
        if ([temp.nextResponder isKindOfClass:[UIViewController class]]) {
            vc = (UIViewController*)temp.nextResponder;
            break;
        }
    }
    return vc;
}

@end
