//
//  RushGoodTableViewCell.m
//  600生活
//
//  Created by iOS on 2019/11/20.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "RushGoodTableViewCell.h"
#import "SealCountView.h"

@interface RushGoodTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *incomeLab; //收益
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIView *sealCountBgView;
@property (weak, nonatomic) IBOutlet UILabel *newpriceLab;
@property (weak, nonatomic) IBOutlet UILabel *oldpriceLab;
@property (weak, nonatomic) IBOutlet UIButton *quanBtn;

@end

@implementation RushGoodTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.incomeLab.backgroundColor = [UIColor colorWithHexString:@"#F54556"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)fullData:(RushGoodModel*)rushGoodModel
{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:rushGoodModel.pict_url]];
    self.titleLab.text = [NSString stringWithFormat:@"        %@",rushGoodModel.title]; //8个空格
    
    //sealCountBgView
    SealCountView* sealCountView = [[SealCountView alloc]initWithFrame:CGRectMake(0, 0, _sealCountBgView.width, _sealCountBgView.height)];
    CGFloat coupon_remain_count = rushGoodModel.coupon_remain_count.integerValue;
    CGFloat coupon_total_count = rushGoodModel.coupon_total_count.integerValue;
    CGFloat ratio = coupon_remain_count / coupon_total_count;
    sealCountView.ratio = ratio;
    [_sealCountBgView addSubview:sealCountView];
    
    self.newpriceLab.text = rushGoodModel.quanhou_price;
    self.oldpriceLab.text = [NSString stringWithFormat:@"￥%@",rushGoodModel.price];
    
    NSString* coupon_money = [NSString stringWithFormat:@"        ￥%@ ",rushGoodModel.coupon_money];
    [self.quanBtn setTitle:coupon_money forState:UIControlStateNormal];
    
    self.incomeLab.text = [NSString stringWithFormat:@" 预计收益￥%@ ",rushGoodModel.earnings];
}


- (IBAction)rushBtnAction:(id)sender {
}


@end
