//
//  SearchedGoodTableViewCell.m
//  600生活
//
//  Created by iOS on 2019/11/18.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "SearchedGoodTableViewCell.h"

@interface SearchedGoodTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@property (weak, nonatomic) IBOutlet UIImageView *shopIcon;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLab;

@property (weak, nonatomic) IBOutlet UILabel *newpriceLab;
@property (weak, nonatomic) IBOutlet UILabel *oldpriceLab;
@property (weak, nonatomic) IBOutlet UILabel *sellCountLab;
@property (weak, nonatomic) IBOutlet UIButton *quanBtn;
@property (weak, nonatomic) IBOutlet UILabel *incomeLab;

@end


@implementation SearchedGoodTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    _tipLab.layer.borderColor = [UIColor colorWithHexString:@"#FE2741"].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)fullData:(SearchedGoodModel*)searchedGoodModel keywords:(NSString*)keywords
{
    [self clearDataBeforeReuse];
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:searchedGoodModel.pict_url] placeholderImage:kPlaceHolderImg];
    
    self.tipLab.text = [searchedGoodModel.user_type isEqualToString:@"0"] ? @"淘宝" : @"天猫";
    
    BOOL isCat = [searchedGoodModel.user_type isEqualToString:@"1"];
    if(isCat){
        self.shopIcon.image = [UIImage imageNamed:@"天猫logo"];
    }else{
        self.shopIcon.image = [UIImage imageNamed:@"淘宝logo"];
    }
    self.shopNameLab.text = searchedGoodModel.shop_title;
    
    
    self.contentLab.text = [NSString stringWithFormat:@"\t  %@",searchedGoodModel.title];
    [self changeKeywordsToRedColor:self.contentLab keywords:keywords];//关键字变色
    
    self.newpriceLab.text = searchedGoodModel.quanhou_price;
    self.oldpriceLab.text = [NSString stringWithFormat:@"%@ ￥%@",self.tipLab.text,searchedGoodModel.price];
    
    self.sellCountLab.text = [NSString stringWithFormat:@"月销量 %@",searchedGoodModel.monthly_sales];
    
    [self.quanBtn setTitle:[NSString stringWithFormat:@"      ￥%@ ",searchedGoodModel.coupon_money] forState:UIControlStateNormal];
    
    NSString* forecast_earnings = [NSString stringWithFormat:@" 预计收益￥%.2f ",searchedGoodModel.forecast_earnings.floatValue];
    self.incomeLab.text = forecast_earnings;
    
}


-(void)changeKeywordsToRedColor:(UILabel*)contentLab keywords:(NSString*)keywords
{
    NSString* contentStr = contentLab.text;
    NSString* lowerFullContentStr = [contentStr lowercaseString]; //整体改小写
    NSString* lowerKeywords = [keywords lowercaseString];//关键字改小写
    
    NSRange keywordsRange = NSMakeRange(0, 0);
    if(lowerKeywords){
        keywordsRange = [lowerFullContentStr rangeOfString:lowerKeywords];
    }
    
    NSMutableAttributedString *mutAttrStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
    [mutAttrStr addAttribute:NSForegroundColorAttributeName value:RGB(112, 156, 248) range:keywordsRange];
    self.contentLab.attributedText = mutAttrStr;
}

-(void)clearDataBeforeReuse
{
    self.contentLab.text = nil;
    [self.quanBtn setTitle:nil forState:UIControlStateNormal];
    self.incomeLab.text = nil;
}
@end
