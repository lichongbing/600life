//
//  SystemMsgTableViewCell.m
//  600生活
//
//  Created by iOS on 2019/11/18.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "MsgTableViewCell.h"
#import "SPButton.h"

@interface MsgTableViewCell()

@property (weak, nonatomic) IBOutlet SPButton *timeBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIImageView *icon; //下/上
@property (weak, nonatomic) IBOutlet UILabel *dot;//红点

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabTopCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabBottomCons;


@property(nonatomic,strong)MsgModel* msgModel;


@end

@implementation MsgTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)fullData:(MsgModel*)msgModel
{
    self.msgModel = msgModel;
    
    //红点
    self.dot.hidden =  msgModel.read.intValue == 1;
    
    [self.timeBtn setTitle:msgModel.create_time forState:UIControlStateNormal];
    
    self.titleLab.text = msgModel.title;
    
    if(msgModel.isShowDetailInfo){ //展示更多
        self.contentLab.text = msgModel.content;
        self.contentLabTopCons.constant = 10;
        self.contentLabBottomCons.constant = 10;
        self.line.hidden = NO;
        self.icon.image = [UIImage imageNamed:@"上"];
    }else{//更少展示
        self.contentLab.text = nil;
        self.contentLabTopCons.constant = 0;
        self.contentLabBottomCons.constant = 0;
        self.line.hidden = YES;
        self.icon.image = [UIImage imageNamed:@"下"];
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (IBAction)cellClicked:(UIButton*)sender {
    self.msgModel.isShowDetailInfo = !(self.msgModel.isShowDetailInfo);
    if(self.cellClickedCallback){
        self.cellClickedCallback(self.msgModel);
    }
}


-(void)hiddenRedDot
{
    self.dot.hidden = YES;
}

@end
