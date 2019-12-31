//
//  SelectedGoodTableViewCell.m
//  600生活
//
//  Created by iOS on 2019/11/8.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "SelectedGoodTableViewCell.h"

@interface SelectedGoodTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *icon; //头像
@property (weak, nonatomic) IBOutlet UILabel *typeLab;  //类型 0淘宝 1天猫
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIView *redView;  //深红色柱状
@property (weak, nonatomic) IBOutlet UILabel *radioLab; //比例
@property (weak, nonatomic) IBOutlet UILabel *freshPirceLab; //新价格
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLab;  //旧价格
@property (weak, nonatomic) IBOutlet UILabel *sealCountLab; //卖出量
@property (weak, nonatomic) IBOutlet UIButton *quanBtn;  //券
@property (weak, nonatomic) IBOutlet UILabel *incomeLab;  //收益

@end

@implementation SelectedGoodTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)fullData:(SelectedGoodModel*)selectedGoodModel
{
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:selectedGoodModel.pict_url]];
    
    self.typeLab.text = [selectedGoodModel.type isEqualToString:@"0"] ? @"淘宝" : @"天猫";
    
    self.titleLab.text = [NSString stringWithFormat:@"\t  %@",selectedGoodModel.title];
    
    self.freshPirceLab.text = selectedGoodModel.quanhou_price;
    self.oldPriceLab.text = [NSString stringWithFormat:@"%@ ￥%@",self.typeLab.text,selectedGoodModel.price];
    
    self.sealCountLab.text = [NSString stringWithFormat:@"已售 %@",selectedGoodModel.volume];
    
    [self.quanBtn setTitle:[NSString stringWithFormat:@"      ￥%@ ",selectedGoodModel.coupon_money] forState:UIControlStateNormal];
    
    self.incomeLab.text = [NSString stringWithFormat:@" 预计收益￥%@ ",selectedGoodModel.earnings];
}



@end
