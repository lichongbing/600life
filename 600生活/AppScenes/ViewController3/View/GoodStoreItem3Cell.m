//
//  GoodStoreSubTableViewCell.m
//  600生活
//
//  Created by iOS on 2019/11/21.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "GoodStoreItem3Cell.h"
#import "GoodStoreItem3SubView.h"

@interface GoodStoreItem3Cell()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *desLab;
@property (weak, nonatomic) IBOutlet UILabel *sellLab;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property(nonatomic,strong) GoodStoreModel* goodStoreModel;

@end


@implementation GoodStoreItem3Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)fullData:(GoodStoreModel*)goodStoreModel
{
    self.goodStoreModel = goodStoreModel;

    [self clearUI];
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:goodStoreModel.shop_icon] placeholderImage:kPlaceHolderImg];
    self.nameLab.text = goodStoreModel.shop_title;
    
    NSArray* goods_list = goodStoreModel.goods_list;
    
    if(self.scrollView.subviews.count > 0){
        for(UIView* subViw in self.scrollView.subviews){
            [subViw removeFromSuperview];
        }
    }
    
    CGFloat left = 0;
    CGFloat space =  ((kScreenWidth - 40) - 109 * 3 ) / 2; //scrollView的宽度 - 3倍item宽度 / 2个间隙
    for(int i = 0; i < goods_list.count; i++){
        GoodStoreGoodModel* goodStoreGoodModel = [goods_list objectAtIndex:i];
        GoodStoreItem3SubView* goodStoreItem3SubView = [[GoodStoreItem3SubView alloc]init];
        [self.scrollView addSubview:goodStoreItem3SubView];
        goodStoreItem3SubView.top = 0;
        goodStoreItem3SubView.left = left;
        [goodStoreItem3SubView fullData:goodStoreGoodModel];
        left = goodStoreItem3SubView.right + space;
        
        UIButton* btn= [UIButton buttonWithType:UIButtonTypeCustom];
        [goodStoreItem3SubView addSubview:btn];
        btn.frame = CGRectMake(0, 0, goodStoreItem3SubView.width, goodStoreItem3SubView.height);
        [btn addTarget:self action:@selector(goodStoreSubGoodItemViewClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100+i;
    }
}

-(void)goodStoreSubGoodItemViewClicked:(UIButton*)btn
{
    NSInteger index = btn.tag - 100;
    GoodStoreGoodModel* goodStoreGoodModel = [self.goodStoreModel.goods_list objectAtIndex:index];
    if(self.goodStoreGoodClickedCallBack){
        self.goodStoreGoodClickedCallBack(goodStoreGoodModel);
    }
}

-(void)clearUI
{
    self.icon.image = nil;
}
@end
