//
//  GoodStoreSubGoodItemView.m
//  600生活
//
//  Created by iOS on 2019/11/21.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "GoodStoreItem3SubView.h"

@interface GoodStoreItem3SubView()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *leftPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *rightPriceLab;
@property (weak, nonatomic) IBOutlet UIButton *quanBtn;
@property (weak, nonatomic) IBOutlet UILabel *qijianLab;  //旗舰店


@end

@implementation GoodStoreItem3SubView

-(void)layoutSubviews
{
    [super layoutSubviews];
    
//    self.icon.width = self.icon.height = self.width;
//    self.titleLab.width = self.width;
//    self.priceBgView.width = self.width;
}

-(id)init
{
    if(self = [super init]){
        self = [[NSBundle mainBundle] loadNibNamed:@"GoodStoreItem3SubView" owner:self options:nil].firstObject;
        self.frame = CGRectMake(0, 0, 109, 178);
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"GoodStoreItem3SubView" owner:self options:nil].firstObject;
        self.frame = frame;
       }
       return self;
}

-(void)fullData:(GoodStoreGoodModel*)goodStoreGoodModel
{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:goodStoreGoodModel.pict_url]];
    
    self.titleLab.text = goodStoreGoodModel.title;
    
    self.leftPriceLab.text = goodStoreGoodModel.quanhou_price;
    
    self.rightPriceLab.text = goodStoreGoodModel.price;
    
    [self.quanBtn setTitle:[NSString stringWithFormat:@"        ￥%@ ",goodStoreGoodModel.coupon_money] forState:UIControlStateNormal];
    
    self.qijianLab.hidden = NO;
}

@end
