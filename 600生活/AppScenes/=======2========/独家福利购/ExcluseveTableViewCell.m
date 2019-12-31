//
//  ExcluseveTableViewCell.m
//  600生活
//
//  Created by iOS on 2019/11/21.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "ExcluseveTableViewCell.h"

@interface ExcluseveTableViewCell()

//left

@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIImageView *icon1;  //图片
//@property (weak, nonatomic) IBOutlet UILabel *tip1;        //来源(天猫)
@property (weak, nonatomic) IBOutlet UILabel *title1;      //标题
@property (weak, nonatomic) IBOutlet UILabel *freshPrice1;  //新价格
@property (weak, nonatomic) IBOutlet UILabel *oldPrice1;   //旧价格
//@property (weak, nonatomic) IBOutlet UILabel *sealCount1; //售出数量
//@property (weak, nonatomic) IBOutlet UIButton *quanBtn1;  //券价值
//@property (weak, nonatomic) IBOutlet UILabel *earning1;  //收益

//right
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIImageView *icon2;  //图片
//@property (weak, nonatomic) IBOutlet UILabel *tip2;        //来源(天猫)
@property (weak, nonatomic) IBOutlet UILabel *title2;      //标题
@property (weak, nonatomic) IBOutlet UILabel *freshPrice2;  //新价格
@property (weak, nonatomic) IBOutlet UILabel *oldPrice2;   //旧价格
//@property (weak, nonatomic) IBOutlet UILabel *sealCount2; //售出数量
//@property (weak, nonatomic) IBOutlet UIButton *quanBtn2;  //券价值
//@property (weak, nonatomic) IBOutlet UILabel *earning2;  //收益

@end

@interface ExcluseveTableViewCell()
@property(nonatomic,strong)WelFareGoodModel* welFareGoodModel1;
@property(nonatomic,strong)WelFareGoodModel* welFareGoodModel2;
@end

@implementation ExcluseveTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)fullDataWithLeftModel:(WelFareGoodModel*)welFareGoodModel1 rightModel:(WelFareGoodModel*)welFareGoodModel2
{
    self.welFareGoodModel1 = welFareGoodModel1;
    self.welFareGoodModel2 = welFareGoodModel2;
    
    [self clearUI];
    
    [self.icon1 sd_setImageWithURL:[NSURL URLWithString:welFareGoodModel1.pict_url] placeholderImage:kPlaceHolderImg];
    self.title1.text = [NSString stringWithFormat:@"%@",welFareGoodModel1.title];
    
    self.oldPrice1.text = [NSString stringWithFormat:@"%@",welFareGoodModel1.coupon_money];//券价值
    self.freshPrice1.text = [NSString stringWithFormat:@" 券后价%@ ",welFareGoodModel1.quanhou_price];//券后价
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    [self.icon2 sd_setImageWithURL:[NSURL URLWithString:welFareGoodModel2.pict_url] placeholderImage:kPlaceHolderImg];
    self.title2.text = [NSString stringWithFormat:@"%@",welFareGoodModel2.title];
    
    self.oldPrice2.text = [NSString stringWithFormat:@"%@",welFareGoodModel2.coupon_money];//券价值
    self.freshPrice2.text = [NSString stringWithFormat:@" 券后价%@ ",welFareGoodModel2.quanhou_price];//券后价
    
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    if(self.welFareGoodModel1.item_id == nil){
        self.leftView.hidden = YES;
    }
    
    if(self.welFareGoodModel2.item_id == nil){
        self.rightView.hidden = YES;
    }
}

-(void)clearUI
{
    
    self.title1.text = nil;
    self.oldPrice1.text = nil;//券价值
    self.freshPrice1.text = nil;//券后价
    
    self.title2.text = nil;
    self.oldPrice2.text = nil;//券价值
    self.freshPrice2.text = nil;//券后价
    
    self.leftView.hidden = NO;
    self.rightView.hidden = NO;
}


- (IBAction)CellSubItemClicked:(UIButton*)sender {
    if(self.welFareGoodClickedCallBack){
        if(sender.tag == 10){
            self.welFareGoodClickedCallBack(self.welFareGoodModel1);
        }else if(sender.tag == 11){
            self.welFareGoodClickedCallBack(self.welFareGoodModel2);
        }
    }
}

@end
