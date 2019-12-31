//
//  CategoryGoodTableViewCell.m
//  600生活
//
//  Created by iOS on 2019/12/11.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "CategoryGoodTableViewCell.h"

@interface CategoryGoodTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *newpriceLab;
@property (weak, nonatomic) IBOutlet UILabel *oldpriceLab;
@property (weak, nonatomic) IBOutlet UILabel *sellCountLab;
@property (weak, nonatomic) IBOutlet UIButton *quanBtn;
@property (weak, nonatomic) IBOutlet UILabel *incomeLab;

@end

@implementation CategoryGoodTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tipLab.layer.borderWidth = 1;
    self.tipLab.layer.borderColor = self.tipLab.textColor.CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)fullData:(CategoryGoodModel*)categoryGoodModel keywords:(NSString*)keywords
{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:categoryGoodModel.pict_url] placeholderImage:kPlaceHolderImg];
    
    self.tipLab.text = [categoryGoodModel.type isEqualToString:@"0"] ? @"淘宝" : @"天猫";
    
    self.contentLab.text = [NSString stringWithFormat:@"\t  %@",categoryGoodModel.title];
    [self changeKeywordsToRedColor:self.contentLab keywords:keywords];//关键字变色
    
    self.newpriceLab.text = categoryGoodModel.quanhou_price;
    self.oldpriceLab.text = [NSString stringWithFormat:@"%@ ￥%@",self.tipLab.text,categoryGoodModel.price];
    
    self.sellCountLab.text = [NSString stringWithFormat:@"月销量 %@",categoryGoodModel.volume];
    
    [self.quanBtn setTitle:[NSString stringWithFormat:@"      ￥%@ ",categoryGoodModel.coupon_money] forState:UIControlStateNormal];
    
    
    self.incomeLab.text = [NSString stringWithFormat:@" 预计收益￥%.2f ",categoryGoodModel.earnings.floatValue];
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

@end
