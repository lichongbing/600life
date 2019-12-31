//
//  ZhongHeView.m
//  600生活
//
//  Created by iOS on 2019/12/9.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "ZhongHeView.h"


@interface ZhongHeView()

@property (weak, nonatomic) IBOutlet UIButton *btn1;//综合排序
@property (weak, nonatomic) IBOutlet UIButton *btn2;//佣金比例由大到小
@property (weak, nonatomic) IBOutlet UIButton *btn3;//预估收益由高到低

@property (weak, nonatomic) IBOutlet UIButton *btn;  //最大的btn

@property(nonatomic,strong)GoodSelectToolBar* goodSelectToolBar;

@end

@implementation ZhongHeView

-(id)initWithToolBar:(GoodSelectToolBar*)goodSelectToolBar
{
    if (self = [super init]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"ZhongHeView" owner:self options:nil].firstObject;
        self.width = kScreenWidth;
        self.backgroundColor = [UIColor clearColor];
        self.goodSelectToolBar = goodSelectToolBar;
    }
    return self;
}

- (IBAction)btnsAction:(UIButton*)sender
{
    [self clearAllCells];
    [self showOneCellWithBtn:sender];
    
    
    int index = (int)sender.tag - 1000 + 1;
    if(self.goodSelectToolBar.delegate){
         [self.goodSelectToolBar.delegate goodSelectToolBarDidSelecedWithSort:index goodSelectToolBar:self.goodSelectToolBar];
    }
    
     [self dismiss];
}

-(void)clearAllCells
{
    [self unShowOneCellWithBtn:_btn1];
    [self unShowOneCellWithBtn:_btn2];
    [self unShowOneCellWithBtn:_btn3];
}

-(void)showOneCellWithBtn:(UIButton*)btn
{
    UIView* cell = btn.superview;
    UILabel* lab = [cell viewWithTag:100];
    lab.textColor = [UIColor colorWithHexString:@"FA5561"];
    UIImageView* icon = [cell viewWithTag:101];
    icon.hidden = NO;
}

-(void)unShowOneCellWithBtn:(UIButton*)btn
{
    UIView* cell = btn.superview;
    UILabel* lab = [cell viewWithTag:100];
    lab.textColor = [UIColor colorWithHexString:@"151515"];
    UIImageView* icon = [cell viewWithTag:101];
    icon.hidden = YES;
}

#pragma mark - helper

-(void)showOnSupperView:(UIView*)superView frame:(CGRect)frame
{
    [superView addSubview:self];
    self.frame = frame;
    [superView bringSubviewToFront:self];
    __weak ZhongHeView* wself = self;
    [UIView animateWithDuration:0.3 animations:^{
        wself.btn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    } completion:nil];
}

-(void)dismiss
{
    if(self.goodSelectToolBar){
        [self.goodSelectToolBar setSort:0];
    }
    [self removeFromSuperview];
}

- (IBAction)bigBtnAction:(id)sender {
    
    [self dismiss];
}



@end
