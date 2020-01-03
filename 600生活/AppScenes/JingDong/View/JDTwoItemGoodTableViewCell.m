//
//  JDHomeRecommendTableViewCell.m
//  600生活
//
//  Created by iOS on 2020/1/2.
//  Copyright © 2020 灿男科技. All rights reserved.
//

#import "JDTwoItemGoodTableViewCell.h"

@interface JDTwoItemGoodTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *leftGoodView;
@property (weak, nonatomic) IBOutlet UIImageView *icon1;  //图片
@property (weak, nonatomic) IBOutlet UILabel *tip1;        //来源(天猫)
@property (weak, nonatomic) IBOutlet UILabel *title1;      //标题
@property (weak, nonatomic) IBOutlet UILabel *freshPrice1;  //新价格
@property (weak, nonatomic) IBOutlet UILabel *oldPrice1;   //旧价格
@property (weak, nonatomic) IBOutlet UILabel *sealCount1; //售出数量
@property (weak, nonatomic) IBOutlet UIButton *quanBtn1;  //券价值
@property (weak, nonatomic) IBOutlet UILabel *earning1;  //收益

//right
@property (weak, nonatomic) IBOutlet UIView *rightGoodView;
@property (weak, nonatomic) IBOutlet UIImageView *icon2;  //图片
@property (weak, nonatomic) IBOutlet UILabel *tip2;        //来源(天猫)
@property (weak, nonatomic) IBOutlet UILabel *title2;      //标题
@property (weak, nonatomic) IBOutlet UILabel *freshPrice2;  //新价格
@property (weak, nonatomic) IBOutlet UILabel *oldPrice2;   //旧价格
@property (weak, nonatomic) IBOutlet UILabel *sealCount2; //售出数量
@property (weak, nonatomic) IBOutlet UIButton *quanBtn2;  //券价值
@property (weak, nonatomic) IBOutlet UILabel *earning2;  //收益

@end


@interface JDTwoItemGoodTableViewCell()

@property(nonatomic,strong)JDGood* leftModel;
@property(nonatomic,strong)JDGood* rightModel;

@end

@implementation JDTwoItemGoodTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)fullDataWithLeftModel:(JDGood*)jdHomeRecommendGood1 rightModel:(JDGood*)jdHomeRecommendGood2
{
    self.leftModel = jdHomeRecommendGood1;
    self.rightModel = jdHomeRecommendGood2;
    
    if(!self.leftModel.item_id){
        self.leftGoodView.hidden = YES;
    }
    if(!self.rightModel.item_id){
        self.rightGoodView.hidden = YES;
    }
    
    [self.icon1 sd_setImageWithURL:[NSURL URLWithString:jdHomeRecommendGood1.pict_url] placeholderImage:kPlaceHolderImg];
    self.title1.text = [NSString stringWithFormat:@"\t %@",jdHomeRecommendGood1.title];
    self.freshPrice1.text = jdHomeRecommendGood1.quanhou_price.toString;
    self.oldPrice1.text = [NSString stringWithFormat:@"￥%@",jdHomeRecommendGood1.price];
    self.sealCount1.text = [NSString stringWithFormat:@"已售 %@",jdHomeRecommendGood1.monthly_sales];
    [self.quanBtn1 setTitle:[NSString stringWithFormat:@"        ￥%@ ",jdHomeRecommendGood1.earnings] forState:UIControlStateNormal];
    self.earning1.text = [NSString stringWithFormat:@" 预计收益￥%@ ",jdHomeRecommendGood1.earnings];
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    [self.icon2 sd_setImageWithURL:[NSURL URLWithString:jdHomeRecommendGood2.pict_url] placeholderImage:kPlaceHolderImg];
    self.title2.text = [NSString stringWithFormat:@"\t %@",jdHomeRecommendGood2.title];
    self.freshPrice2.text = jdHomeRecommendGood2.quanhou_price.toString;
    self.oldPrice2.text = [NSString stringWithFormat:@"￥%@",jdHomeRecommendGood2.price];
    self.sealCount2.text = [NSString stringWithFormat:@"已售 %@",jdHomeRecommendGood2.monthly_sales];
    [self.quanBtn2 setTitle:[NSString stringWithFormat:@"        ￥%@ ",jdHomeRecommendGood2.earnings] forState:UIControlStateNormal];
    self.earning2.text = [NSString stringWithFormat:@" 预计收益￥%@ ",jdHomeRecommendGood2.earnings];
}

@end
