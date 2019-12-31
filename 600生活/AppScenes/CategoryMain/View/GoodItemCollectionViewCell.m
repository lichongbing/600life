//
//  GoodItemCollectionViewCell.m
//  600生活
//
//  Created by iOS on 2019/11/19.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "GoodItemCollectionViewCell.h"

@interface GoodItemCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *icon; //图片
@property (weak, nonatomic) IBOutlet UILabel *titleLab; //文字
@end

@implementation GoodItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)fullImageUrlStr:(NSString*)urlStr titleName:(NSString*)titleName
{
    //清空数据
    self.icon.image = [UIImage imageNamed:kDefaultImgName];
    self.titleLab.text = nil;
    
    //重新填充数据
    if(urlStr){
        [self.icon sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:kPlaceHolderImg];
    }
    if(titleName){
        self.titleLab.text = titleName;
    }
}

@end
