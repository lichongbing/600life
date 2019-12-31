//
//  UIButton+ext.h
//  600生活
//
//  Created by iOS on 2019/12/8.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (ext)

/**
 添加gif动画
 gifName : git名  不要加.gif后缀
 duration 动画时间
 */
-(void)addGifImgWithName:(NSString*)gifName duration:(float)duration;


/**
 删除gif动画
 */
-(void)removeGifImg;
@end

NS_ASSUME_NONNULL_END
