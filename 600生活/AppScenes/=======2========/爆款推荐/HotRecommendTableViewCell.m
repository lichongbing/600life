//
//  HotRecommendTableViewCell.m
//  600生活
//
//  Created by iOS on 2019/11/20.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "HotRecommendTableViewCell.h"

@interface HotRecommendTableViewCell()

//left
@property (weak, nonatomic) IBOutlet UIView *leftGoodView;
@property (weak, nonatomic) IBOutlet UIImageView *icon1;  //图片
@property (weak, nonatomic) IBOutlet UILabel *title1;      //标题
@property (weak, nonatomic) IBOutlet UILabel *freshPrice1;  //新价格
@property (weak, nonatomic) IBOutlet UILabel *quanLab1;  //券价值

//right
@property (weak, nonatomic) IBOutlet UIView *rightGoodView;
@property (weak, nonatomic) IBOutlet UIImageView *icon2;  //图片
@property (weak, nonatomic) IBOutlet UILabel *title2;      //标题
@property (weak, nonatomic) IBOutlet UILabel *freshPrice2;  //新价格
@property (weak, nonatomic) IBOutlet UILabel *quanLab2;  //券价值

@end

@interface HotRecommendTableViewCell()

@property(nonatomic,strong)HotRecommendGood* leftModel;
@property(nonatomic,strong)HotRecommendGood* rightModel;

@end


@implementation HotRecommendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)fullDataWithLeftModel:(HotRecommendGood*)hotRecommendGood1 rightModel:(HotRecommendGood*)hotRecommendGood2
{
    self.leftModel = hotRecommendGood1;
    self.rightModel = hotRecommendGood2;
    
    if(!self.leftModel.item_id){
        self.leftGoodView.hidden = YES;
    }
    if(!self.rightModel.item_id){
        self.rightGoodView.hidden = YES;
    }
    
    [self.icon1 sd_setImageWithURL:[NSURL URLWithString:hotRecommendGood1.pict_url]];
    
    self.title1.text = [NSString stringWithFormat:@"%@",hotRecommendGood1.title];
    
    self.quanLab1.text = hotRecommendGood1.coupon_money;
    
    self.freshPrice1.text = [NSString stringWithFormat:@" 券后价¥%@ ",hotRecommendGood1.quanhou_price];
    
      /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    [self.icon2 sd_setImageWithURL:[NSURL URLWithString:hotRecommendGood2.pict_url]];
    
    self.title2.text = [NSString stringWithFormat:@"%@",hotRecommendGood2.title];
    
    self.quanLab2.text = hotRecommendGood2.coupon_money;
    
    self.freshPrice2.text = [NSString stringWithFormat:@" 券后价¥%@ ",hotRecommendGood2.quanhou_price];
}

//商品被点击
- (IBAction)goodBtnAction:(UIButton*)sender {
    NSInteger index = sender.tag - 10;
    if(index == 0){
        if(self.hotRecommendGoodClickedCallback){
            self.hotRecommendGoodClickedCallback(self.leftModel);
        }
    }
    if(index == 1){
        if(self.hotRecommendGoodClickedCallback){
            self.hotRecommendGoodClickedCallback(self.rightModel);
        }
    }
}


@end
