//
//  IncomeDetailTableViewCell.m
//  600生活
//
//  Created by iOS on 2019/11/14.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "IncomeDetailTableViewCell.h"

@interface IncomeDetailTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *orderNoLab;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *successTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *showCopyLab;  //复制

@property (weak, nonatomic) IBOutlet UILabel *userMoneyLab; //消费金额

@property(nonatomic,strong)IncomeItemModel* incomeItemModel;

@end


@implementation IncomeDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _showCopyLab.layer.borderWidth = 1;
    _showCopyLab.layer.borderColor = [UIColor colorWithHexString:@"#BFBFBF"].CGColor;
    _showCopyLab.layer.cornerRadius = 8;
    _showCopyLab.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)fullData:(IncomeItemModel*)incomeItemModel
{
  
    _incomeItemModel = incomeItemModel;
    self.titleLab.text = incomeItemModel.item_title;
    
    BOOL isAdd = incomeItemModel.earnings.floatValue >= 0;
    if(isAdd){
        self.moneyLab.text = [NSString stringWithFormat:@"+%@元",incomeItemModel.earnings];
        self.moneyLab.textColor = [UIColor colorWithHexString:@"#F3414E"];
    }else{
       self.moneyLab.text = [NSString stringWithFormat:@"-%@元",incomeItemModel.earnings];
        self.moneyLab.textColor = [UIColor greenColor];
    }
    
    //订单创建日
    self.orderNoLab.text = [NSString stringWithFormat:@"结算订单号:%@",incomeItemModel.trade_id];
    NSString* createTimeStr = [Utility getDateStrWithTimesStampNumber:incomeItemModel.tk_create_time Format:@"MM-dd HH:MM"];
    self.createTimeLab.text = [NSString stringWithFormat:@"创建日 %@",createTimeStr];
    
    //订单结算日
    NSString* successTimeStr = [Utility getDateStrWithTimesStampNumber:incomeItemModel.tk_paid_time Format:@"MM-dd HH:MM"];
    self.successTimeLab.text = [NSString stringWithFormat:@"结算日 %@",successTimeStr];
    
    //消费金额
    self.userMoneyLab.text = [NSString stringWithFormat:@"消费金额￥:%@",incomeItemModel.pay_price];
    
}


- (IBAction)copyBtnAction:(UIButton*)sender {

    [[LLHudHelper sharedInstance]tipMessage:@"复制成功"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = _incomeItemModel.trade_id;
    });
}


@end
