//
//  StoreDetailGoodCell.m
//  600生活
//
//  Created by iOS on 2019/12/4.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "StoreDetailGoodCell.h"

@interface StoreDetailGoodCell()
//left
@property (weak, nonatomic) IBOutlet UIView *leftGoodView;
@property (weak, nonatomic) IBOutlet UIImageView *icon1;  //图片
@property (weak, nonatomic) IBOutlet UILabel *tip1;        //来源(天猫)
@property (weak, nonatomic) IBOutlet UILabel *title1;      //标题
@property (weak, nonatomic) IBOutlet UILabel *freshPrice1;  //新价格
@property (weak, nonatomic) IBOutlet UILabel *oldPrice1;   //旧价格
@property (weak, nonatomic) IBOutlet UIButton *quanBtn1;  //券价值
@property (weak, nonatomic) IBOutlet UILabel *earning1;  //收益

//right
@property (weak, nonatomic) IBOutlet UIView *rightGoodView;
@property (weak, nonatomic) IBOutlet UIImageView *icon2;  //图片
@property (weak, nonatomic) IBOutlet UILabel *tip2;        //来源(天猫)
@property (weak, nonatomic) IBOutlet UILabel *title2;      //标题
@property (weak, nonatomic) IBOutlet UILabel *freshPrice2;  //新价格
@property (weak, nonatomic) IBOutlet UILabel *oldPrice2;   //旧价格
@property (weak, nonatomic) IBOutlet UIButton *quanBtn2;  //券价值
@property (weak, nonatomic) IBOutlet UILabel *earning2;  //收益
@end

@interface StoreDetailGoodCell()

@property(nonatomic,strong)StroeDetailGoodModel* leftModel;
@property(nonatomic,strong)StroeDetailGoodModel* rightModel;

@end

@implementation StoreDetailGoodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)fullDataWithLeftModel:(StroeDetailGoodModel*)stroeDetailGoodModel1 rightModel:(StroeDetailGoodModel*)stroeDetailGoodModel2
{
    
    self.leftModel = stroeDetailGoodModel1;
    self.rightModel = stroeDetailGoodModel2;
    
    if(!self.leftModel.item_id){
        self.leftGoodView.hidden = YES;
    }
    if(!self.rightModel.item_id){
        self.rightGoodView.hidden = YES;
    }
    
    
    [self.icon1 sd_setImageWithURL:[NSURL URLWithString:stroeDetailGoodModel1.pict_url]];
    if([stroeDetailGoodModel1.type isEqualToString:@"0"]){
        self.tip1.text = @"淘宝";
    } else {
        self.tip1.text = @"天猫";
    }
    self.title1.text = [NSString stringWithFormat:@"\t  %@",stroeDetailGoodModel1.title];
    self.freshPrice1.text = stroeDetailGoodModel1.quanhou_price;
    self.oldPrice1.text = [NSString stringWithFormat:@"￥%@",stroeDetailGoodModel1.price];
    [self.quanBtn1 setTitle:[NSString stringWithFormat:@"        ￥%@ ",stroeDetailGoodModel1.coupon_money] forState:UIControlStateNormal];
    self.earning1.text = [NSString stringWithFormat:@" 预计收益￥%@ ",stroeDetailGoodModel1.earnings];
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    [self.icon2 sd_setImageWithURL:[NSURL URLWithString:stroeDetailGoodModel2.pict_url]];
       if([stroeDetailGoodModel2.type isEqualToString:@"0"]){
           self.tip2.text = @"淘宝";
       } else {
           self.tip2.text = @"天猫";
       }
       self.title2.text = [NSString stringWithFormat:@"\t  %@",stroeDetailGoodModel2.title];
       self.freshPrice2.text = stroeDetailGoodModel2.quanhou_price;
       self.oldPrice2.text = [NSString stringWithFormat:@"￥%@",stroeDetailGoodModel2.price];
       [self.quanBtn2 setTitle:[NSString stringWithFormat:@"        ￥%@ ",stroeDetailGoodModel2.coupon_money] forState:UIControlStateNormal];
       self.earning2.text = [NSString stringWithFormat:@" 预计收益￥%@ ",stroeDetailGoodModel2.earnings];
}

//商品被点击
- (IBAction)goodBtnAction:(UIButton*)sender {
    NSInteger index = sender.tag - 10;
    if(index == 0){
        if(self.storeDetailGoodClickedCallback){
            self.storeDetailGoodClickedCallback(self.leftModel);
        }
    }
    if(index == 1){
        if(self.storeDetailGoodClickedCallback){
            self.storeDetailGoodClickedCallback(self.rightModel);
        }
    }
}

@end
