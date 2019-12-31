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
@property (weak, nonatomic) IBOutlet UILabel *recommandLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;  //电话和时间
@property (weak, nonatomic) IBOutlet UIImageView *levelIcon;

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
    
    //推荐人
    if(fansModel.count.intValue > 0){
        self.recommandLab.hidden = NO;
        self.recommandLab.text = [NSString stringWithFormat:@"推荐%@人>",fansModel.count];
    }else{
        self.recommandLab.hidden = YES;
    }
    
//    self.recommandLab.text = nil;
    
    //电话和时间
    NSArray* timeStrArr = [fansModel.create_time componentsSeparatedByString:@" "];
    NSString* timeStr = nil;
    if(timeStrArr.count == 2){
        timeStr = timeStrArr.firstObject;
    }
    self.timeLab.text = [NSString stringWithFormat:@"%@  %@",fansModel.mobile,timeStr];
    
    //等级
    int level = fansModel.level.intValue;
    UIImage* levelImage = nil;
    if(level == 3){
        levelImage = [UIImage imageNamed:@"等级青铜"];
    }else if(level == 2){
        levelImage = [UIImage imageNamed:@"等级黄金"];
    }else if(level == 1){
        levelImage = [UIImage imageNamed:@"等级白银"];
    }
    self.levelIcon.image = levelImage;
    
}
@end
