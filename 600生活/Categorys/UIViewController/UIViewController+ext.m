//
//  UIViewController+ext.m
//  600生活
//
//  Created by iOS on 2019/12/7.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "UIViewController+ext.h"



@implementation UIViewController (ext)

/**
 判断当前vc是否正在被展示
 */
-(BOOL)isCurrentViewControllerVisible
{
    return (self.isViewLoaded && self.view.window);
}

@end
