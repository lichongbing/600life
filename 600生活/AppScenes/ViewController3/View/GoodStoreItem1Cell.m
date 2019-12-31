//
//  GoodStoreItem1Cell.m
//  600生活
//
//  Created by iOS on 2019/12/4.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "GoodStoreItem1Cell.h"
#import "GoodStoreItem1SubView.h"

@interface GoodStoreItem1Cell()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *desLab;
@property (weak, nonatomic) IBOutlet UILabel *sellLab;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property(nonatomic,strong) GoodStoreModel* goodStoreModel;

@end

@implementation GoodStoreItem1Cell

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

    [self.icon sd_setImageWithURL:[NSURL URLWithString:goodStoreModel.shop_icon] placeholderImage:kPlaceHolderImg];
    self.nameLab.text = goodStoreModel.shop_title;
    
    
    
    
    NSArray* goods_list = goodStoreModel.goods_list;
    
    if(self.scrollView.subviews.count > 0){
        for(UIView* subViw in self.scrollView.subviews){
            [subViw removeFromSuperview];
        }
    }
    
    CGFloat top = 0;
    
    //只有1个元素
    for(int i = 0; i < goods_list.count; i++){
        GoodStoreGoodModel* goodStoreGoodModel = [goods_list objectAtIndex:i];
        GoodStoreItem1SubView* goodStoreItem1SubView = [[GoodStoreItem1SubView alloc]init];
        [self.scrollView addSubview:goodStoreItem1SubView];
        goodStoreItem1SubView.top = top;
        goodStoreItem1SubView.left = 0;
        [goodStoreItem1SubView fullData:goodStoreGoodModel];
        top = goodStoreItem1SubView.bottom;
        
        UIButton* btn= [UIButton buttonWithType:UIButtonTypeCustom];
        [goodStoreItem1SubView addSubview:btn];
        btn.frame = CGRectMake(0, 0, goodStoreItem1SubView.width, goodStoreItem1SubView.height);
        btn.tag = 10+i;
        [btn addTarget:self action:@selector(goodStoreItem1SubViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)goodStoreItem1SubViewClicked:(UIButton*)btn
{
    NSInteger index = btn.tag - 10;
    GoodStoreGoodModel* goodStoreGoodModel = [self.goodStoreModel.goods_list objectAtIndex:index];
    if(self.goodStoreGoodClickedCallBack){
        self.goodStoreGoodClickedCallBack(goodStoreGoodModel);
    }
}
@end
