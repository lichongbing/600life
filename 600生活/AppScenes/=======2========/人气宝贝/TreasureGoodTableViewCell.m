//
//  BabyGoodTableViewCell.m
//  600生活
//
//  Created by iOS on 2019/11/21.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "TreasureGoodTableViewCell.h"

@interface TreasureGoodTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;  //新价格
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLab; //旧价格
@property (weak, nonatomic) IBOutlet UILabel *sellCountLab;
@property (weak, nonatomic) IBOutlet UIButton *quanBtn;
@property (weak, nonatomic) IBOutlet UILabel *incomeLab;

@end

@implementation TreasureGoodTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)fullData:(TreasureGood*)treasureGood
{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:treasureGood.pict_url]];
    
    self.tipLab.layer.borderWidth = 1;
    self.tipLab.layer.borderColor = [UIColor colorWithHexString:@"#F54556"].CGColor;
    
    //content Lab  8个空格
    
    if([treasureGood.title containsString:@" "]){
        treasureGood.title = [treasureGood.title stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    self.contentLab.text = [NSString stringWithFormat:@"\t  %@",treasureGood.title];
    
    //newPriceLab
    self.priceLab.text = treasureGood.quanhou_price;
    
    //旧价格
    self.oldPriceLab.text = [NSString stringWithFormat:@"￥%@",treasureGood.price];
    
    //已售数量
    self.sellCountLab.text = [NSString stringWithFormat:@"已售 %@",treasureGood.volume];
    
    //券价值//8个空格+1个空格
    [self.quanBtn setTitle:[NSString stringWithFormat:@"        ￥%@ ",treasureGood.quanhou_price] forState:UIControlStateNormal];
    
    //预计收益
    self.incomeLab.text = [NSString stringWithFormat:@" 预计收益 %@ ",treasureGood.earnings];
}

@end
