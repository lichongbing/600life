//
//  UIImageView+ext.m
//  600生活
//
//  Created by iOS on 2019/12/8.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "UIImageView+ext.h"
#import <ImageIO/ImageIO.h> //gifImageName

@implementation UIImageView (ext)

-(void)gifImageName:(NSString*)gifName gifAnimationDuration:(float)duration
{
    NSURL *gifUrl = [[NSBundle mainBundle] URLForResource:gifName withExtension:@"gif"];
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)gifUrl, NULL);
    size_t imagesCount = CGImageSourceGetCount(gifSource);
    
    NSMutableArray *imageArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < imagesCount; i++) {
        //由数据源gifSource生成一张CGImageRef类型的图片
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        [imageArr addObject:image];
        CGImageRelease(imageRef);
    }
    self.animationImages = imageArr;
    //动画的总时长(一组动画坐下来的时间 6张图片显示一遍的总时间)
    self.animationDuration = duration;
    self.animationRepeatCount = 0;
    [self startAnimating];//开始动画
    // [self stopAnimating];//停止动画
}


+ (UIImage *)getNewImageWithSuperImageView:(UIImageView *)imageView
{
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, imageView.opaque, [[UIScreen mainScreen] scale]);//图形以选项开始图像上下文
    [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
/**渲染属性和方法。* * /
/*将接收器及其子处理器呈现为“ctx”。这个方法
*从图层树直接渲染。在坐标空间中呈现的层。
*/
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();//*图像从当前图像上下文获取图像
    UIGraphicsEndImageContext();//结束图像上下文
    return img;
}
@end
