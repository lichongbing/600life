//
//  GoodDetailHotGoodCell.m
//  600生活
//
//  Created by iOS on 2019/11/12.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "GoodDetailHotGoodCell.h"

@interface GoodDetailHotGoodCell()
@property (weak, nonatomic) IBOutlet UIView *leftGoodView;
@property (weak, nonatomic) IBOutlet UIImageView *iconLeft;
@property (weak, nonatomic) IBOutlet UILabel *typeLabLeft;
@property (weak, nonatomic) IBOutlet UILabel *titleLabLeft;
@property (weak, nonatomic) IBOutlet UILabel *newpriceLabLeft;
@property (weak, nonatomic) IBOutlet UILabel *oldpriceLabLeft;
@property (weak, nonatomic) IBOutlet UILabel *sellCountLabLeft;
@property (weak, nonatomic) IBOutlet UIButton *quanBtnLeft;
@property (weak, nonatomic) IBOutlet UILabel *incomeLabLeft;


@property (weak, nonatomic) IBOutlet UIView *rightGoodView;
@property (weak, nonatomic) IBOutlet UIImageView *iconRight;
@property (weak, nonatomic) IBOutlet UILabel *typeLabRight;
@property (weak, nonatomic) IBOutlet UILabel *titleLabRight;
@property (weak, nonatomic) IBOutlet UILabel *newpriceLabRight;
@property (weak, nonatomic) IBOutlet UILabel *oldpriceLabRight;
@property (weak, nonatomic) IBOutlet UILabel *sellCountLabRight;
@property (weak, nonatomic) IBOutlet UIButton *quanBtnRight;
@property (weak, nonatomic) IBOutlet UILabel *incomeLabRight;

@end

@interface GoodDetailHotGoodCell()

@property(nonatomic,strong)TodayHotGoodModel* leftModel;
@property(nonatomic,strong)TodayHotGoodModel* rightModel;

@end

@implementation GoodDetailHotGoodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)fullDataWithLeftModel:(TodayHotGoodModel*)leftModel rightModel:(TodayHotGoodModel*)rightModel
{
    
    self.leftModel = leftModel;
    self.rightModel = rightModel;
    
    if(!self.leftModel.item_id){
        self.leftGoodView.hidden = YES;
    }
    if(!self.rightModel.item_id){
        self.rightGoodView.hidden = YES;
    }
    
    [self.iconLeft sd_setImageWithURL:[NSURL URLWithString:leftModel.pict_url]];
    if([leftModel.type isEqualToString:@"0"]){
        self.typeLabLeft.text = @"淘宝";
    } else {
        self.typeLabLeft.text = @"天猫";
    }
    self.titleLabLeft.text = [NSString stringWithFormat:@"\t  %@",leftModel.title];
    self.newpriceLabLeft.text = leftModel.quanhou_price;
    self.oldpriceLabLeft.text = [NSString stringWithFormat:@"￥%@",leftModel.price];
    self.sellCountLabLeft.text = [NSString stringWithFormat:@"已售 %@",leftModel.volume];
    [self.quanBtnLeft setTitle:[NSString stringWithFormat:@"        ￥%@ ",leftModel.coupon_money] forState:UIControlStateNormal];
    self.incomeLabLeft.text = [NSString stringWithFormat:@" 预计收益￥%@ ",leftModel.earnings];
      
      /////////////////////////////////////////////////////////////////////////////////////////////////////////////
      
     [self.iconRight sd_setImageWithURL:[NSURL URLWithString:rightModel.pict_url]];
        if([rightModel.type isEqualToString:@"0"]){
            self.typeLabRight.text = @"淘宝";
        } else {
            self.typeLabRight.text = @"天猫";
        }
        self.titleLabRight.text = [NSString stringWithFormat:@"\t  %@",rightModel.title];
        self.newpriceLabRight.text = rightModel.quanhou_price;
        self.oldpriceLabRight.text = [NSString stringWithFormat:@"￥%@",rightModel.price];
        self.sellCountLabRight.text = [NSString stringWithFormat:@"已售 %@",rightModel.volume];
        [self.quanBtnRight setTitle:[NSString stringWithFormat:@"        ￥%@ ",rightModel.coupon_money] forState:UIControlStateNormal];
        self.incomeLabRight.text = [NSString stringWithFormat:@" 预计收益￥%@ ",rightModel.earnings];
}


//商品被点击
- (IBAction)goodBtnAction:(UIButton*)sender {
    NSInteger index = sender.tag - 10;
    if(index == 0){
        if(self.goodDetailHotGoodClickedCallback){
            self.goodDetailHotGoodClickedCallback(self.leftModel);
        }
    }
    if(index == 1){
        if(self.goodDetailHotGoodClickedCallback){
            self.goodDetailHotGoodClickedCallback(self.rightModel);
        }
    }
}

@end
