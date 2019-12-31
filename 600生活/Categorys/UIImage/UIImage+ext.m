//
//  UIImage+ext.m
//  600生活
//
//  Created by iOS on 2019/11/4.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "UIImage+ext.h"
#import <CoreImage/CoreImage.h>

@implementation UIImage (ext)

//color转image
+ (UIImage *)imageWithColor:(UIColor *)color
{
    if (color == nil) {
        return nil;
    }
    
    CGRect rect=CGRectMake(0.0f, 0.0f, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


//图片转颜色并并且拉伸效果
+(UIColor *)imageTocolor:(UIImage *)image withrect:(CGRect)rect
{
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.f);
    [image drawInRect:rect];
    UIImage *lastImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIColor *color = [UIColor colorWithPatternImage:lastImage];
    return color;
}

/**
 *  改变图片的大小
 */
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)newsize
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(newsize);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}


/**
 保存图片到本地
 imageUrl：服务端图片地址
 */
+(void)saveImageForKey:(NSString*)imageUrl
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString * homePath =NSHomeDirectory();
        NSString* imgPath = [NSString stringWithFormat:@"%@/%@",homePath,imageUrl];
        UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
         BOOL res = [UIImagePNGRepresentation(image) writeToFile:imgPath atomically:YES];
        NSLog(@"保存图片结果:%d",res);
    });
}


/**
获取本地图片
imageUrl：服务端图片地址
*/
+(UIImage*)getImageForKey:(NSString*)imageUrl
{
    NSString * homePath =NSHomeDirectory();
    NSString* imgPath = [NSString stringWithFormat:@"%@/%@",homePath,imageUrl];
    return [[UIImage alloc]initWithContentsOfFile:imgPath];
}



/* Image 拼接
 * masterImage  主图片
 * headImage   头图片
 * footImage   尾图片
 */
+ (UIImage *)addHeadImage:(UIImage *)headImage footImage:(UIImage *)footImage toMasterImage:(UIImage *)masterImage {
    
    CGSize size;
    size.width = masterImage.size.width;
    
    CGFloat headHeight = !headImage? 0:size.width/headImage.size.width*headImage.size.height;
    CGFloat footHeight = !footImage? 0:size.width/footImage.size.width*footImage.size.height;
    
    size.height = masterImage.size.height + headHeight + footHeight;
    
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    
    if (headImage)
        [headImage drawInRect:CGRectMake(0, 0, masterImage.size.width, headHeight)];
    
    
    [masterImage drawInRect:CGRectMake(0, headHeight, masterImage.size.width, masterImage.size.height)];
    
    if (footImage)
        [footImage drawInRect:CGRectMake(0, masterImage.size.height + headHeight, masterImage.size.width, footHeight)];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return resultImage;
}


/*!
 *  @brief 使图片压缩后刚好小于指定大小
 *
 *  @param image 当前要压缩的图 maxLength 压缩后的大小
 *
 *  @return 图片对象
 */
//图片质量压缩到某一范围内，如果后面用到多，可以抽成分类或者工具类,这里压缩递减比二分的运行时间长，二分可以限制下限。
+ (UIImage *)compressImageSize:(UIImage *)image toByte:(NSUInteger)maxLength
{
    //首先判断原图大小是否在要求内，如果满足要求则不进行压缩，over
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    //原图大小超过范围，先进行“压处理”，这里 压缩比 采用二分法进行处理，6次二分后的最小压缩比是0.015625，已经够小了
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    //判断“压处理”的结果是否符合要求，符合要求就over
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;
    
    //缩处理，直接用大小的比例作为缩处理的比例进行处理，因为有取整处理，所以一般是需要两次处理
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        //获取处理后的尺寸
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
        //通过图片上下文进行处理图片
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //获取处理后图片的大小
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    return resultImage;
}

@end
