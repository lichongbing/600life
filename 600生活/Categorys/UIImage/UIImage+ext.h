//
//  UIImage+ext.h
//  600生活
//
//  Created by iOS on 2019/11/4.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ext)

/**
 color转image

 @param color color
 @return image
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 image转color

 @param image image
 @param rect 设置的颜色的大小
 @return color
 */
+(UIColor *)imageTocolor:(UIImage *)image withrect:(CGRect)rect;


/**
 *  改变图片的大小
 */
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)newsize;


/**
 保存图片到本地
imageUrl：服务端图片地址
 */
+(void)saveImageForKey:(NSString*)imageUrl;


/**
获取本地图片
imageUrl：服务端图片地址
*/
+(UIImage*)getImageForKey:(NSString*)imageUrl;


/* Image 拼接
 * masterImage  主图片
 * headImage   头图片
 * footImage   尾图片
 */
+(UIImage *)addHeadImage:(UIImage *)headImage footImage:(UIImage *)footImage toMasterImage:(UIImage *)masterImage;


/**
 压缩图片到指定大小
 */
+ (UIImage *)compressImageSize:(UIImage *)image toByte:(NSUInteger)maxLength;
@end

NS_ASSUME_NONNULL_END
