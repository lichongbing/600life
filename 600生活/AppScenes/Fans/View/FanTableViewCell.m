//
//  FanTableViewCell.m
//  600生活
//
//  Created by iOS on 2019/11/18.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "FanTableViewCell.h"


@interface FanTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *headIcon;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *telLab;  //电话
@property (weak, nonatomic) IBOutlet UILabel *timeLab; //时间

@end


@implementation FanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)fullData:(FansModel*)fansModel
{
    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:fansModel.avatar] placeholderImage:kPlaceHolderUser];
    
    self.nameLab.text = fansModel.user_nickname;

    //电话
    self.telLab.text = fansModel.mobile;
    //时间
    self.timeLab.text = [Utility getDateStrWithTimesStampNumber:fansModel.create_time Format:@"YYYY-MM-DD"];
}
@end
