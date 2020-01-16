//
//  HYX_BtnTopImgBottomLab.m
//  600生活
//
//  Created by iOS on 2020/1/16.
//  Copyright © 2020 灿男科技. All rights reserved.
//

#import "HYX_BtnTopImgBottomLab.h"

@implementation HYX_BtnTopImgBottomLab
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    CGFloat btn_W = frame.size.width;
//    CGFloat btn_H = frame.size.height;
    self.backgroundColor = [UIColor redColor];
    self.btn_topImg = [[UIImageView alloc]initWithFrame:CGRectMake((btn_W - 44)/2, 0, 44, 44)];
    self.btn_topImg.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.btn_topImg];
    
    self.btn_bottomLab = [[UILabel alloc]initWithFrame:CGRectMake(0, self.btn_topImg.bottom + 10, btn_W, 12)];
    self.btn_bottomLab.textAlignment = NSTextAlignmentCenter;
//    self.btn_bottomLab.font = [UIFont fontWithName:@"Source Han Sans CN" size: 12];
    self.btn_bottomLab.textColor = RGB(51, 51, 51);
    [self addSubview:self.btn_bottomLab];
    
    return self;
}

-(void)setBtn_topImg:(UIImageView *)btn_topImg{
    _btn_topImg = btn_topImg;
}
-(void)setBtn_bottomLab:(UILabel *)btn_bottomLab{
    _btn_bottomLab = btn_bottomLab;
}
@end
