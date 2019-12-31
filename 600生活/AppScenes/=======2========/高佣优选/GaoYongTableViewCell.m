//
//  HightMoneyRandTableViewCell.m
//  600生活
//
//  Created by iOS on 2019/11/21.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "GaoYongTableViewCell.h"


@interface GaoYongTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;  //新价格
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLab; //旧价格
@property (weak, nonatomic) IBOutlet UILabel *sellCountLab;
@property (weak, nonatomic) IBOutlet UIButton *quanBtn;
@property (weak, nonatomic) IBOutlet UILabel *incomeLab;

@end

@implementation GaoYongTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tipLab.layer.borderWidth = 1;
    self.tipLab.layer.borderColor = [UIColor colorWithHexString:@"#F54556"].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)fullData:(GaoYongGood*)gaoYongGood
{
    
    [self clearUI];
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:gaoYongGood.pict_url] placeholderImage:kPlaceHolderImg];

    //content Lab  8个空格
    
    if([gaoYongGood.title containsString:@" "]){
        gaoYongGood.title = [gaoYongGood.title stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    self.contentLab.text = [NSString stringWithFormat:@"\t  %@",gaoYongGood.title];
    
    //newPriceLab
    self.priceLab.text = gaoYongGood.quanhou_price;
    
    //旧价格
    self.oldPriceLab.text = [NSString stringWithFormat:@"￥%@",gaoYongGood.price];
    
    //已售数量
    self.sellCountLab.text = [NSString stringWithFormat:@"已售 %@",gaoYongGood.volume];
    
    //券价值//8个空格+1个空格
    [self.quanBtn setTitle:[NSString stringWithFormat:@"        ￥%@ ",gaoYongGood.quanhou_price] forState:UIControlStateNormal];
    
    //预计收益
    self.incomeLab.text = [NSString stringWithFormat:@" 预计收益 %@ ",gaoYongGood.earnings];
}

-(void)clearUI
{
    self.contentLab.text = nil;
    
    //newPriceLab
    self.priceLab.text = nil;
    
    //旧价格
    self.oldPriceLab.text = nil;
    
    //已售数量
    self.sellCountLab.text = nil;
    
    //券价值//8个空格+1个空格
    [self.quanBtn setTitle:nil forState:UIControlStateNormal];
    
    //预计收益
    self.incomeLab.text = nil;
}


@end
