//
//  WanJuanTableViewCell.m
//  600生活
//
//  Created by iOS on 2019/11/21.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "WanJuanTableViewCell.h"

@interface WanJuanTableViewCell()

//left
@property (weak, nonatomic) IBOutlet UIImageView *icon1;  //图片
@property (weak, nonatomic) IBOutlet UILabel *tip1;        //来源(天猫)
@property (weak, nonatomic) IBOutlet UILabel *title1;      //标题
@property (weak, nonatomic) IBOutlet UILabel *freshPrice1;  //新价格
@property (weak, nonatomic) IBOutlet UILabel *oldPrice1;   //旧价格
//@property (weak, nonatomic) IBOutlet UILabel *sealCount1; //售出数量
@property (weak, nonatomic) IBOutlet UIButton *quanBtn1;  //券价值
//@property (weak, nonatomic) IBOutlet UILabel *earning1;  //收益

//right
@property (weak, nonatomic) IBOutlet UIImageView *icon2;  //图片
@property (weak, nonatomic) IBOutlet UILabel *tip2;        //来源(天猫)
@property (weak, nonatomic) IBOutlet UILabel *title2;      //标题
@property (weak, nonatomic) IBOutlet UILabel *freshPrice2;  //新价格
@property (weak, nonatomic) IBOutlet UILabel *oldPrice2;   //旧价格
//@property (weak, nonatomic) IBOutlet UILabel *sealCount2; //售出数量
@property (weak, nonatomic) IBOutlet UIButton *quanBtn2;  //券价值
//@property (weak, nonatomic) IBOutlet UILabel *earning2;  //收益

@end

@interface WanJuanTableViewCell()
@property(nonatomic,strong)CouponGood* couponGood1;
@property(nonatomic,strong)CouponGood* couponGood2;
@end

@implementation WanJuanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)fullDataWithLeftModel:(CouponGood*)couponGood1 rightModel:(CouponGood*)couponGood2
{
    self.couponGood1 = couponGood1;
    self.couponGood2 = couponGood2;
    
    [self.icon1 sd_setImageWithURL:[NSURL URLWithString:couponGood1.pict_url]];
    if(couponGood1.type.intValue == 0){
        self.tip1.text = @"淘宝";
    } else {
        self.tip1.text = @"天猫";
    }
    
    self.title1.text = [NSString stringWithFormat:@"\t  %@",couponGood1.title];
    
    self.oldPrice1.text = [NSString stringWithFormat:@"￥%@",couponGood1.price];//原价
    self.freshPrice1.text = [NSString stringWithFormat:@"%@ ",couponGood1.quanhou_price];//券后价
//    self.sealCount1.text = [NSString stringWithFormat:@"已售 %@",couponGood1.volume];
    [self.quanBtn1 setTitle:[NSString stringWithFormat:@"        ￥%@ ",couponGood1.coupon_money] forState:UIControlStateNormal];
//    self.earning1.text = [NSString stringWithFormat:@" 预计收益￥%@ ",couponGood1.earnings];
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    [self.icon2 sd_setImageWithURL:[NSURL URLWithString:couponGood2.pict_url]];
    if(couponGood2.type.intValue == 0){
        self.tip2.text = @"淘宝";
    } else {
        self.tip2.text = @"天猫";
    }
    self.title2.text = [NSString stringWithFormat:@"\t  %@",couponGood2.title];
    
    self.oldPrice2.text = [NSString stringWithFormat:@"￥%@",couponGood2.price];//原价
    self.freshPrice2.text = [NSString stringWithFormat:@"%@ ",couponGood2.quanhou_price];//券后价
//    self.sealCount2.text = [NSString stringWithFormat:@"已售 %@",couponGood2.volume];
    [self.quanBtn2 setTitle:[NSString stringWithFormat:@"        ￥%@ ",couponGood2.coupon_money] forState:UIControlStateNormal];
//    self.earning2.text = [NSString stringWithFormat:@" 预计收益￥%@ ",couponGood2.earnings];
}

- (IBAction)cellSubItemClicked:(UIButton*)sender {
    if(self.couponGoodClickedCallBack){
        if(sender.tag == 10){
            self.couponGoodClickedCallBack(self.couponGood1);
        }else if(sender.tag == 11){
            self.couponGoodClickedCallBack(self.couponGood2);
        }
    }
}

@end
