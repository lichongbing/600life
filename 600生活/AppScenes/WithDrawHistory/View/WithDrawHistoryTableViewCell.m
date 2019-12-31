//
//  WithDrawHistoryTableViewCell.m
//  600生活
//
//  Created by iOS on 2019/11/19.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "WithDrawHistoryTableViewCell.h"

@interface WithDrawHistoryTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *timeLab;   //时间
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;  //金额
@property (weak, nonatomic) IBOutlet UILabel *statusLab; //状态

@property (weak, nonatomic) IBOutlet UIView *moreInfoBg;//更多信息bg
@property (weak, nonatomic) IBOutlet UIImageView *downIcon; //下箭头
@property (weak, nonatomic) IBOutlet UILabel *desLab;  //描述

@property(nonatomic,strong)CashoutModel* cashoutModel;

@end


@implementation WithDrawHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)fullData:(CashoutModel*)cashoutModel
{
    _cashoutModel = cashoutModel;
    
    //状态 状态0-待审核 1-已通过 2-拒绝
    int status = cashoutModel.status.intValue;
    NSString* statusStr = @"";
    if(status == 0){
        statusStr = @"待审核";
    }else if(status == 1){
        statusStr = @"已通过";
    }else if(status == 2){
        statusStr = @"已拒绝";
    }
    self.statusLab.text = statusStr;
    self.statusLab.textColor = [self getStatusColorWithStatus:status];
    
    //提现发起时间
    NSString* create_time = cashoutModel.create_time;
    
    //提现成功时间
    NSString* success_time = cashoutModel.success_time;
    
    if(success_time){
        self.timeLab.text = success_time;
    }else{
        self.timeLab.text = create_time;
    }
   
    //提现金额
    NSString* money = cashoutModel.money;
    self.moneyLab.text = [NSString stringWithFormat:@"%@元",money];
    
    if(!self.cashoutModel.isShowDetailInfo){//不展示更多
        self.moreInfoBg.hidden = YES;
        self.downIcon.image = [UIImage imageNamed:@"下箭头"];
    }else{//展示更多
        self.moreInfoBg.hidden = NO;
        self.downIcon.image = [UIImage imageNamed:@"上箭头"];
    }
    
    if(status == 2){  //拒绝
       self.downIcon.hidden = NO;
        self.desLab.text = cashoutModel.remark;
    }else{
        self.downIcon.hidden = YES;
    }
}

-(UIColor*)getStatusColorWithStatus:(int)status
{
    if(status == 0){
        return [UIColor colorWithHexString:@"#999999"]; //灰色
    } else if (status == 1){
        return [UIColor colorWithHexString:@"#72BB23"];//绿色
    } else if (status == 2){
        return [UIColor colorWithHexString:@"#F54556"]; //红色
    }
    return nil;
}

- (IBAction)cellBtnAction:(UIButton *)sender {
    self.cashoutModel.isShowDetailInfo = !self.cashoutModel.isShowDetailInfo;
    if(_cellClickedCallback){
        _cellClickedCallback(_cashoutModel);
    }
}

@end
