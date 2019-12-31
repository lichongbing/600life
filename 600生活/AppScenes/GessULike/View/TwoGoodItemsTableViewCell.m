//
//  TwoGoodItemsTableViewCell.m
//  600生活
//
//  Created by iOS on 2019/11/7.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "TwoGoodItemsTableViewCell.h"

@interface TwoGoodItemsTableViewCell()

//left
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

@interface TwoGoodItemsTableViewCell()

@property(nonatomic,strong)GuessLikeGoodModel* leftModel;
@property(nonatomic,strong)GuessLikeGoodModel* rightModel;

@end

@implementation TwoGoodItemsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)fullDataWithLeftModel:(GuessLikeGoodModel*)guessLikeGoodModel1 rightModel:(GuessLikeGoodModel*)guessLikeGoodModel2
{
    
    self.leftModel = guessLikeGoodModel1;
    self.rightModel = guessLikeGoodModel2;
    
    if(!self.leftModel.item_id){
        self.leftGoodView.hidden = YES;
    }
    if(!self.rightModel.item_id){
        self.rightGoodView.hidden = YES;
    }
    
    
    [self.icon1 sd_setImageWithURL:[NSURL URLWithString:guessLikeGoodModel1.pict_url] placeholderImage:kPlaceHolderImg];
    if([guessLikeGoodModel1.type isEqualToString:@"0"]){
        self.tip1.text = @"淘宝";
    } else {
        self.tip1.text = @"天猫";
    }
    self.title1.text = [NSString stringWithFormat:@"\t %@",guessLikeGoodModel1.title];
    self.freshPrice1.text = guessLikeGoodModel1.quanhou_price;
    self.oldPrice1.text = [NSString stringWithFormat:@"￥%@",guessLikeGoodModel1.price];
    self.sealCount1.text = [NSString stringWithFormat:@"已售 %@",guessLikeGoodModel1.volume];
    [self.quanBtn1 setTitle:[NSString stringWithFormat:@"        ￥%@ ",guessLikeGoodModel1.coupon_money] forState:UIControlStateNormal];
    self.earning1.text = [NSString stringWithFormat:@" 预计收益￥%@ ",guessLikeGoodModel1.earnings];
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    [self.icon2 sd_setImageWithURL:[NSURL URLWithString:guessLikeGoodModel2.pict_url] placeholderImage:kPlaceHolderImg];
       if([guessLikeGoodModel2.type isEqualToString:@"0"]){
           self.tip2.text = @"淘宝";
       } else {
           self.tip2.text = @"天猫";
       }
       self.title2.text = [NSString stringWithFormat:@"\t %@",guessLikeGoodModel2.title];
       self.freshPrice2.text = guessLikeGoodModel2.quanhou_price;
       self.oldPrice2.text = [NSString stringWithFormat:@"￥%@",guessLikeGoodModel2.price];
       self.sealCount2.text = [NSString stringWithFormat:@"已售 %@",guessLikeGoodModel2.volume];
       [self.quanBtn2 setTitle:[NSString stringWithFormat:@"        ￥%@ ",guessLikeGoodModel2.coupon_money] forState:UIControlStateNormal];
       self.earning2.text = [NSString stringWithFormat:@" 预计收益￥%@ ",guessLikeGoodModel2.earnings];
}

//商品被点击
- (IBAction)goodBtnAction:(UIButton*)sender {
    NSInteger index = sender.tag - 10;
    if(index == 0){
        if(self.guessLikeGoodClickedCallback){
            self.guessLikeGoodClickedCallback(self.leftModel);
        }
    }
    if(index == 1){
        if(self.guessLikeGoodClickedCallback){
            self.guessLikeGoodClickedCallback(self.rightModel);
        }
    }
}

-(void)clearUI
{
    self.title1.text = nil;
    self.freshPrice1.text = nil;
    self.oldPrice1.text = nil;
    self.sealCount1.text = nil;
    [self.quanBtn1 setTitle:nil forState:UIControlStateNormal];
    self.earning1.text = nil;
    
    self.title2.text = nil;
    self.freshPrice2.text = nil;
    self.oldPrice2.text = nil;
    self.sealCount2.text = nil;
    [self.quanBtn2 setTitle:nil forState:UIControlStateNormal];
    self.earning2.text = nil;
}


@end
