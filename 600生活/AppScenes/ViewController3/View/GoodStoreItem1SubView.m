//
//  GoodStoreItem2SubView.m
//  600生活
//
//  Created by iOS on 2019/12/4.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "GoodStoreItem1SubView.h"


@interface GoodStoreItem1SubView()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *leftPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *rightPriceLab;
@property (weak, nonatomic) IBOutlet UIButton *quanBtn;
@property (weak, nonatomic) IBOutlet UILabel *qijianLab;  //旗舰店

@property (weak, nonatomic) IBOutlet UILabel *incomeLab; //收益

@end
@implementation GoodStoreItem1SubView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.qijianLab.layer.borderColor = [UIColor colorWithHexString:@"#FE2741"].CGColor;
    self.qijianLab.layer.borderWidth = 0.5;
}

-(id)init
{
    if(self = [super init]){
        self = [[NSBundle mainBundle] loadNibNamed:@"GoodStoreItem1SubView" owner:self options:nil].firstObject;
        self.frame = CGRectMake(0, 0, kScreenWidth - (7+19)*2, 120);
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"GoodStoreItem1SubView" owner:self options:nil].firstObject;
        self.frame = frame;
       }
       return self;
}

-(void)fullData:(GoodStoreGoodModel*)goodStoreGoodModel
{
    BOOL isCat = [goodStoreGoodModel.type isEqualToString:@"1"]; //是否是天猫
    if(isCat){
        self.qijianLab.text = @"天猫";
    }else{
        self.qijianLab.text = @"淘宝";
    }
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:goodStoreGoodModel.pict_url]];
    
    self.titleLab.text = [NSString stringWithFormat:@"            %@",goodStoreGoodModel.title];
    
    self.leftPriceLab.text = goodStoreGoodModel.quanhou_price;
    
    self.rightPriceLab.text = goodStoreGoodModel.price;
    
    [self.quanBtn setTitle:[NSString stringWithFormat:@"       ￥%@ ",goodStoreGoodModel.coupon_money] forState:UIControlStateNormal];
    
    NSString* earnings = [NSString stringWithFormat:@" 预计收益￥%@ ",goodStoreGoodModel.earnings];
    self.incomeLab.text = earnings;
    
 
}

@end
