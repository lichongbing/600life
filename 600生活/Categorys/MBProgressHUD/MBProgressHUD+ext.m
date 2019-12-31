//
//  MBProgressHUD+ext.m
//  600生活
//
//  Created by iOS on 2019/12/27.
//  Copyright © 2019 灿男科技. All rights reserved.
//
// Refresh_Gif_1
// Refresh_Gif_21

#import "MBProgressHUD+ext.h"

@implementation MBProgressHUD (ext)

-(void)addAnimation
{
    self.mode = MBProgressHUDModeCustomView;
    UIImage *image = [[UIImage imageNamed:@"Refresh_Gif_11"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    //该imageView作为 Hud的customView  必须重写intrinsicContentSize函数，所以用了HudCustomImageView
    HudCustomImageView* mainImageView= [[HudCustomImageView alloc] initWithImage:image];
    static NSMutableArray* s_imagesArr = nil;
    if(s_imagesArr == nil){
        s_imagesArr = [NSMutableArray new];
        for(int i = 1; i <= 11; i++){
            NSString* imageName = [NSString stringWithFormat:@"Refresh_Gif_%d",i];
            UIImage* image = [UIImage imageNamed:imageName];
            if(image){
                [s_imagesArr addObject:image];
            }
        }
    }
    mainImageView.animationImages = s_imagesArr;
    [mainImageView setAnimationDuration:1.f];
    [mainImageView setAnimationRepeatCount:0];
    [mainImageView startAnimating];
    self.customView = mainImageView;
    self.animationType = MBProgressHUDAnimationFade;
}

//lhf - 老板需求 隐藏背景view
-(void)hiddenMBBackgroundEffectView
{
    self.bezelView.backgroundColor = [UIColor clearColor];
    for(UIView* subView in self.bezelView.subviews){
        if([subView isKindOfClass:[UIVisualEffectView class]]){
            subView.hidden = YES;
        }
    }
}

@end
