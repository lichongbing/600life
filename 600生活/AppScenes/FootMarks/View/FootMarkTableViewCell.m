//
//  FootMarkTableViewCell.m
//  600生活
//
//  Created by iOS on 2019/11/13.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "FootMarkTableViewCell.h"

@interface FootMarkTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *quanhouPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *cellCountLab;
@property (weak, nonatomic) IBOutlet UIButton *quanBtn;

@property(nonatomic,strong)FootMarkGoodModel* footMarkGoodModel;

@end


@implementation FootMarkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)fullData:(FootMarkGoodModel*)footMarkGoodModel
{
    
    self.footMarkGoodModel = footMarkGoodModel;
    
    [self clearUI];
    
    //图片
    [self.icon sd_setImageWithURL:[NSURL URLWithString:footMarkGoodModel.pict_url] placeholderImage:kPlaceHolderImg];
    
    //标题
    self.titleLab.text = footMarkGoodModel.title;
    
    //券后价
    self.quanhouPriceLab.text = footMarkGoodModel.quanhou_price;
    
    //旧价格
    self.priceLab.text = [NSString stringWithFormat:@"原价￥%@",footMarkGoodModel.price];
    
    //销量
    self.cellCountLab.text = [NSString stringWithFormat:@"已售 %@",footMarkGoodModel.volume];
    
    //券价值 左边8个空格
    [self.quanBtn setTitle:[NSString stringWithFormat:@"        ￥%@ ",footMarkGoodModel.coupon_money] forState:UIControlStateNormal];
}

-(void)clearUI
{
    //标题
    self.titleLab.text = nil;
    
    //券后价
    self.quanhouPriceLab.text = nil;
    
    //旧价格
    self.priceLab.text = nil;
    
    //销量
    self.cellCountLab.text = nil;
    
    //券价值 左边8个空格
    [self.quanBtn setTitle:nil forState:UIControlStateNormal];
}

#pragma mark - control action

- (IBAction)similarBtnAction:(id)sender {
    if(self.similarBtnClickedCallback){
        self.similarBtnClickedCallback(self.footMarkGoodModel);
    }
}

@end
