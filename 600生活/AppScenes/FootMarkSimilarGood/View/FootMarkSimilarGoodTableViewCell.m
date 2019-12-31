//
//  FootMarkSimilarGoodTableViewCell.m
//  600生活
//
//  Created by iOS on 2019/11/13.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "FootMarkSimilarGoodTableViewCell.h"

@interface FootMarkSimilarGoodTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *quanhouPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *cellCountLab;
@property (weak, nonatomic) IBOutlet UIButton *quanBtn;
@property (weak, nonatomic) IBOutlet UILabel *incomeLab;

@property(nonatomic,strong)SimilarGoodModel* similarGoodModel;

@end
@implementation FootMarkSimilarGoodTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)fullData:(SimilarGoodModel*)similarGoodModel
{
    
    self.similarGoodModel = similarGoodModel;
    
    //图片
    [self.icon sd_setImageWithURL:[NSURL URLWithString:similarGoodModel.pict_url] placeholderImage:kPlaceHolderImg];
    
    //标题
    self.titleLab.text = similarGoodModel.title;
    
    //券后价
    self.quanhouPriceLab.text = similarGoodModel.price;
    
    //旧价格
    self.priceLab.text = [NSString stringWithFormat:@"原价￥%@",similarGoodModel.price];
    
    //销量
    self.cellCountLab.text = [NSString stringWithFormat:@"已售 %@",similarGoodModel.volume];
    
    //券价值 左边8个空格
    [self.quanBtn setTitle:[NSString stringWithFormat:@"        ￥%@ ",similarGoodModel.quanhou_price] forState:UIControlStateNormal];
    
    //收益
    NSString* earnings = [NSString stringWithFormat:@" 预计收益￥%@ ",similarGoodModel.earnings];
    self.incomeLab.text = earnings;
}
@end
