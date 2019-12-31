//
//  QuickCreateView.h
//  TomLu
//
//  Created by Tom lu on 2018/2/28.
//  Copyright © 2018年 com.haifangluo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QuickCreateView : NSObject

/** 快速创建系统按键*/
+ (UIButton *)addSystemButtonWithFrame:(CGRect)frame
                                 title:(NSString *)title
                                   tag:(int)tag
                                target:(id)target
                                action:(SEL)action;

/** 快速创建图片按键*/
+ (UIButton *)addCustomButtonWithFrame:(CGRect)frame
                                 title:(NSString *)title
                                 image:(UIImage *)image
                               bgImage:(UIImage *)bgImage
                                   tag:(int)tag
                                target:(id)target
                                action:(SEL)action;

/** 快速创标签*/
+ (UILabel *)addLableWithFrame:(CGRect)frame
                          text:(NSString *)text
                     textColor:(UIColor *)color;

/** 快速创标签*/
+ (UILabel *)addLableWithFrame:(CGRect)frame
                          text:(NSString *)text
                     textColor:(UIColor *)color
                 textAlignment:(NSTextAlignment)textAlignment
                          font:(UIFont*)font
                        center:(CGPoint)center;

/** 快速图片视图*/
+ (UIImageView *)addImageViewWithFrame:(CGRect)frame
                                 image:(UIImage *)image;


@end
