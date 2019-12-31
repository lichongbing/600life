//
//  SimilarGoodView.m
//  600生活
//
//  Created by iOS on 2019/11/12.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "SimilarGoodView.h"

@interface SimilarGoodView()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIView *priceBgView;
@property (weak, nonatomic) IBOutlet UIButton *quanBtn;

@property (weak, nonatomic) IBOutlet UILabel *freshPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLab;


@end

@implementation SimilarGoodView

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.icon.width = self.icon.height = self.width;
    self.titleLab.width = self.width;
    self.priceBgView.width = self.width;
}

-(id)init
{
    if(self = [super init]){
        self = [[NSBundle mainBundle] loadNibNamed:@"SimilarGoodView" owner:self options:nil].firstObject;
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"SimilarGoodView" owner:self options:nil].firstObject;
        self.frame = frame;
       }
       return self;
}

-(void)fullData:(SmilarGoodModel*)smilarGoodModel
{
    self.titleLab.text = smilarGoodModel.title;
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:smilarGoodModel.pict_url]];
    
    self.freshPriceLab.text = smilarGoodModel.quanhou_price;
    self.oldPriceLab.text = [NSString stringWithFormat:@"￥%@",smilarGoodModel.price];
    [self.quanBtn setTitle:[NSString stringWithFormat:@"      ￥%@",smilarGoodModel.quanhou_price] forState:UIControlStateNormal];
}
@end
