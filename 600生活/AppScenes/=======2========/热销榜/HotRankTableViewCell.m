//
//  HotRankTableViewCell.m
//  600生活
//
//  Created by iOS on 2019/11/21.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "HotRankTableViewCell.h"

@interface HotRankTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;  //新价格
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLab; //旧价格
@property (weak, nonatomic) IBOutlet UILabel *sellCountLab;
@property (weak, nonatomic) IBOutlet UIButton *quanBtn;
@property (weak, nonatomic) IBOutlet UILabel *incomeLab;
@end


@implementation HotRankTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)fullData:(HotRankGoodModel*)hotRankGoodModel
{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:hotRankGoodModel.pict_url]];
    
    //tip Lab
    
//    BOOL isCat = [hotRankGoodModel. isEqualToString:@"1"];
    
    self.tipLab.layer.borderWidth = 1;
    self.tipLab.layer.borderColor = [UIColor colorWithHexString:@"#F54556"].CGColor;
//    if(isCat){
//        self.tipLab.text = @"天猫";
//    }else {
//        self.tipLab.text = @"淘宝";
//    }
    
    //content Lab  8个空格
    
    if([hotRankGoodModel.title containsString:@" "]){
        hotRankGoodModel.title = [hotRankGoodModel.title stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    self.contentLab.text = [NSString stringWithFormat:@"\t  %@",hotRankGoodModel.title];
    
    //newPriceLab
    self.priceLab.text = hotRankGoodModel.quanhou_price;
    
    //旧价格
    self.oldPriceLab.text = [NSString stringWithFormat:@"￥%@",hotRankGoodModel.price];
    
    //已售数量
    self.sellCountLab.text = [NSString stringWithFormat:@"已售 %@",hotRankGoodModel.volume];
    
    //券价值//8个空格+1个空格
    [self.quanBtn setTitle:[NSString stringWithFormat:@"        ￥%@ ",hotRankGoodModel.quanhou_price] forState:UIControlStateNormal];
//    
    //预计收益
    self.incomeLab.text = [NSString stringWithFormat:@" 预计收益 %@ ",hotRankGoodModel.earnings];
}

@end
