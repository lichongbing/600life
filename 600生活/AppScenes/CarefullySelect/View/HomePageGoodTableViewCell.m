//
//  HomePageGoodTableViewCell.m
//  600生活
//
//  Created by iOS on 2019/11/7.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "HomePageGoodTableViewCell.h"
#import "UILabel+ext.h"


@interface HomePageGoodTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *shopIcon;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLab;

@property (weak, nonatomic) IBOutlet UILabel *freshLab; //新价格

@property (weak, nonatomic) IBOutlet UILabel *oldLab;  //旧价格 包含￥
@property (weak, nonatomic) IBOutlet UIButton *quanBtn;
@property (weak, nonatomic) IBOutlet UILabel *incomeLab;  //预计收益



@end


@implementation HomePageGoodTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.titleLab alignTop];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)fullData:(HomePageGoodsListItemModel*)homePageGoodsListItemModel
{
    
    [self clearUI];
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:homePageGoodsListItemModel.pict_url] placeholderImage:kPlaceHolderImg];
    

    BOOL isCat = [homePageGoodsListItemModel.type isEqualToString:@"1"];
    if(isCat){
        self.shopIcon.image = [UIImage imageNamed:@"天猫logo"];
    }else{
        self.shopIcon.image = [UIImage imageNamed:@"淘宝logo"];
    }
    
    self.shopNameLab.text = homePageGoodsListItemModel.shop_title;
    
    self.titleLab.text = [NSString stringWithFormat:@"\t  %@",homePageGoodsListItemModel.title]; //8个空格
    
    
    
    
    self.freshLab.text = homePageGoodsListItemModel.quanhou_price;
    self.oldLab.text = [NSString stringWithFormat:@"￥%@",homePageGoodsListItemModel.price];

    NSString* coupon_money = [NSString stringWithFormat:@"       ￥%@ ",homePageGoodsListItemModel.coupon_money];
    [self.quanBtn setTitle:coupon_money forState:UIControlStateNormal];
    
    self.incomeLab.text = [NSString stringWithFormat:@" 预计收益￥%@ ",homePageGoodsListItemModel.earnings];
}

-(void)clearUI
{
    self.titleLab.text = nil;
    self.shopIcon.image = nil;
    self.shopNameLab.text = nil;
    [self.quanBtn setTitle:nil forState:UIControlStateNormal];
    self.incomeLab.text = nil;
}



@end
