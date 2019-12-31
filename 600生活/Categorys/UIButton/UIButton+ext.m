//
//  UIButton+ext.m
//  600生活
//
//  Created by iOS on 2019/12/8.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "UIButton+ext.h"
#import <ImageIO/ImageIO.h> //gifImageName


@implementation UIButton (ext)


-(void)addGifImgWithName:(NSString*)gifName duration:(float)duration
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
    
    self.imageView.animationImages = imageArr;
    //动画的总时长(一组动画坐下来的时间 6张图片显示一遍的总时间)
    self.imageView.animationDuration = duration;
    self.imageView.animationRepeatCount = 0;
    [self.imageView startAnimating];//开始动画
    [self setImage:kPlaceHolderImg forState:UIControlStateNormal];
    // [self stopAnimating];//停止动画
}

-(void)removeGifImg
{
    if(self.imageView.animationImages.count > 0){
        [self.imageView stopAnimating];
        self.imageView.animationImages = nil;
    }
}
@end
