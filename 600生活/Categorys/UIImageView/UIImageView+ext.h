//
//  UIImageView+ext.h
//  600生活
//
//  Created by iOS on 2019/12/8.
//  Copyright © 2019 灿男科技. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (ext)

/**
 添加gif动画
 gifName : git名  不要加.gif后缀
 duration 动画时间
 */
-(void)gifImageName:(NSString*)gifName gifAnimationDuration:(float)duration;


/**
 如果imageview上面有子控件，调用该方法，产生一个新的imageview 新的imageview的图 包含了全部父子内容
 */
+ (UIImage *)getNewImageWithSuperImageView:(UIImageView *)imageView;


@end

NS_ASSUME_NONNULL_END
