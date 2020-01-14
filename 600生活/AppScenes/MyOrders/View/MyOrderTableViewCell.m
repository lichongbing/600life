//
//  MyOrderTableViewCell.m
//  600生活
//
//  Created by iOS on 2019/11/13.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "MyOrderTableViewCell.h"

@interface MyOrderTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *stroeNameLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *orderLab;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *incomeLab;
@property (weak, nonatomic) IBOutlet UILabel *useMoneyLab;

@property(nonatomic,strong) MyOrderModel* myOrderModel;


@end

@implementation MyOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)fullData:(MyOrderModel*)myOrderModel
{
    self.myOrderModel = myOrderModel;
    
    //图片
    [self.icon sd_setImageWithURL:[NSURL URLWithString:myOrderModel.item_img] placeholderImage:kPlaceHolderImg];
    
    //标题
    self.titleLab.text = myOrderModel.item_title;
    
    //商店名
    self.stroeNameLab.text = [NSString stringWithFormat:@"店铺名称:%@",myOrderModel.seller_shop_title];
    
    //订单状态
    [self setupLabelWithOrderStatus:myOrderModel.tk_status label:self.statusLab];
    
    
    //订单号
    self.orderLab.text = [NSString stringWithFormat:@"订单号:%@",myOrderModel.trade_id];
    
    //日期
    self.createTimeLab.text = myOrderModel.tk_create_time;
    
    //收益
    NSString* uid_earnings = [NSString stringWithFormat:@" 预计收益￥%@ ",myOrderModel.uid_earnings];
    self.incomeLab.text = uid_earnings;
    
    //消费
    if(myOrderModel.pay_price){
        NSString* sub1 = @"消费金额";
        NSString* sub2 = [NSString stringWithFormat:@"￥%@",myOrderModel.pay_price];
        NSString* allStr = [NSString stringWithFormat:@"%@%@",sub1,sub2];
        
        NSMutableAttributedString* mutAttrStr = [[NSMutableAttributedString alloc]initWithString:allStr];
        NSRange redRange = [allStr rangeOfString:sub2];
        [mutAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
        self.useMoneyLab.attributedText = mutAttrStr;
    }
}

-(void)setupLabelWithOrderStatus:(NSNumber*)tk_status label:(UILabel*)lab
{
    int status = tk_status.intValue;
    if(status == 3){
        lab.text = @" 订单结算 ";
        lab.backgroundColor = [UIColor colorWithHexString:@"#72BB23"];
    }
    if(status == 12){
        lab.text = @" 订单付款 ";
        lab.backgroundColor = [UIColor colorWithHexString:@"#F54556"];
    }
    if(status == 13){
        lab.text = @" 订单失效 ";
        lab.backgroundColor = [UIColor colorWithHexString:@"#C4C4C4"];
    }
    if(status == 14){
        lab.text = @" 订单成功 ";
        lab.backgroundColor = [UIColor colorWithHexString:@"#72BB23"];
    }
}

- (IBAction)copyBtnAction:(id)sender {
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    board.string = self.myOrderModel.trade_id;
    [[NSUserDefaults standardUserDefaults]setValue:self.myOrderModel.trade_id forKey:kAppInnerCopyStr];
    [[LLHudHelper sharedInstance]tipMessage:@"复制成功"];
}

//订单查询需要调用
-(void)resetIncomeLabWithStatus:(NSNumber*)Status
{
    if(Status.intValue == 1) {
        self.incomeLab.text = @"无归属";
    }else{
        self.incomeLab.text = nil;
    }
}

@end
