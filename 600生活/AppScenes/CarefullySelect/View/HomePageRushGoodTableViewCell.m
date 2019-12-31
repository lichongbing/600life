//
//  HomePageRushGoodTableViewCell.m
//  600生活
//
//  Created by iOS on 2019/11/26.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "HomePageRushGoodTableViewCell.h"
#import "SealCountView.h"

@interface HomePageRushGoodTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIView *ratioBg;  //卖出柱状图背景
@property (weak, nonatomic) IBOutlet UILabel *freshLab; //新价格

@property (weak, nonatomic) IBOutlet UILabel *oldLab;  //旧价格 包含￥
@property (weak, nonatomic) IBOutlet UIButton *quanBtn;

@property (weak, nonatomic) IBOutlet UILabel *incomeLab; //预计收益


@end

@implementation HomePageRushGoodTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)fullData:(HomePageRushGoods2ItemModel*)homePageRushGoods2ItemModel
{
    [self clearUI];
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:homePageRushGoods2ItemModel.pict_url] placeholderImage:kPlaceHolderImg];
    self.titleLab.text = [NSString stringWithFormat:@"\t  %@",homePageRushGoods2ItemModel.title]; //8个空格
  
    //比例
    SealCountView* sealCountView = [[SealCountView alloc]initWithFrame:CGRectMake(0, 0, _ratioBg.width, 20)];
    float coupon_remain_count = [homePageRushGoods2ItemModel.coupon_remain_count integerValue];
    float coupon_total_count = [homePageRushGoods2ItemModel.coupon_total_count integerValue];
    CGFloat ratio = coupon_remain_count / coupon_total_count;
    sealCountView.ratio = ratio;
    sealCountView.sealCount = (NSInteger)coupon_total_count - (NSInteger)coupon_remain_count;
    [self.ratioBg addSubview:sealCountView];
    
    self.freshLab.text = homePageRushGoods2ItemModel.quanhou_price;
    self.oldLab.text = [NSString stringWithFormat:@"￥%@",homePageRushGoods2ItemModel.price];

    NSString* coupon_money = [NSString stringWithFormat:@"    ￥%@",homePageRushGoods2ItemModel.coupon_money];
    [self.quanBtn setTitle:coupon_money forState:UIControlStateNormal];
    
    self.incomeLab.text = [NSString stringWithFormat:@" 预计收益￥%@ ",homePageRushGoods2ItemModel.earnings];
}

-(void)clearUI
{
    self.titleLab.text = nil;
    if(self.ratioBg.subviews.count > 0){
        for(UIView* subView in self.ratioBg.subviews){
            [subView removeFromSuperview];
        }
    }
    
    [self.quanBtn setTitle:nil forState:UIControlStateNormal];
    self.incomeLab.text = nil;
}

@end
