//
//  UIColor+ext.h
//  tomlu
//
//  Created by Tom lu on 2019/4/30.
//  Copyright © 2019 com.luohaifang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (ext)

//形参:hex字符串 返回UIColor
+ (UIColor *) colorWithHexString: (NSString *)hexStr;


@end

NS_ASSUME_NONNULL_END
