//
//  CollectedGoodTableViewCell.m
//  600生活
//
//  Created by iOS on 2019/11/13.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "CollectedGoodTableViewCell.h"

@interface CollectedGoodTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *icon; //头像
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *freshPirceLab; //新价格
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLab;  //旧价格
@property (weak, nonatomic) IBOutlet UILabel *sealCountLab; //卖出量
@property (weak, nonatomic) IBOutlet UIButton *quanBtn;  //券
@property (weak, nonatomic) IBOutlet UILabel *incomeLab;  //收益

@end


@implementation CollectedGoodTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)fullData:(CollectedGoodModel*)collectedGoodModel
{
    
    [self clearUI];
    [self.icon sd_setImageWithURL:[NSURL URLWithString:collectedGoodModel.pict_url] placeholderImage:kPlaceHolderImg];
    
    self.titleLab.text = [NSString stringWithFormat:@"%@",collectedGoodModel.title];
    
    self.freshPirceLab.text = collectedGoodModel.quanhou_price;
    self.oldPriceLab.text = [NSString stringWithFormat:@" 原价￥%@",collectedGoodModel.price];
    
    self.sealCountLab.text = [NSString stringWithFormat:@"已售 %@",collectedGoodModel.volume];
    
    [self.quanBtn setTitle:[NSString stringWithFormat:@"      ￥%@ ",collectedGoodModel.coupon_money] forState:UIControlStateNormal];
    
    NSString* earnings = [NSString stringWithFormat:@" 预计收益￥%@ ",collectedGoodModel.earnings];
    self.incomeLab.text = earnings;
}

-(void)clearUI
{
    self.titleLab.text = nil;
    self.freshPirceLab.text = nil;
    self.oldPriceLab.text = nil;
    self.sealCountLab.text = nil;
    [self.quanBtn setTitle:nil forState:UIControlStateNormal];
    self.incomeLab.text = nil;
}
@end
