//
//  JDGoodTableViewCell.m
//  600生活
//
//  Created by iOS on 2020/1/3.
//  Copyright © 2020 灿男科技. All rights reserved.
//

#import "JDGoodTableViewCell.h"

@interface JDGoodTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *quanhouPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *cellCountLab;
@property (weak, nonatomic) IBOutlet UIButton *quanBtn;
@property (weak, nonatomic) IBOutlet UILabel *incomeLab;

@property(nonatomic,strong)JDGood* jdGood;

@end

@implementation JDGoodTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)fullData:(JDGood*)jdGood
{
    self.jdGood = jdGood;
     
     //图片
     [self.icon sd_setImageWithURL:[NSURL URLWithString:jdGood.pict_url] placeholderImage:kPlaceHolderImg];
     
     //标题
     self.titleLab.text = [NSString stringWithFormat:@"      %@",jdGood.title];
     
     //券后价
     self.quanhouPriceLab.text = jdGood.price.toString;
     
     //旧价格
     self.priceLab.text = [NSString stringWithFormat:@"原价￥%@",jdGood.price];
     
     //销量
     self.cellCountLab.text = [NSString stringWithFormat:@"已售 %@",jdGood.monthly_sales];
     
     //券价值 左边8个空格
     [self.quanBtn setTitle:[NSString stringWithFormat:@"        ￥%@ ",jdGood.quanhou_price] forState:UIControlStateNormal];
     
     //收益
     NSString* earnings = [NSString stringWithFormat:@" 预计收益￥%@ ",jdGood.earnings];
     self.incomeLab.text = earnings;
}

@end
