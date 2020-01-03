//
//  GoodSelectToolBar.m
//  600生活
//
//  Created by iOS on 2019/11/8.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "GoodSelectToolBar.h"
#import "SPButton.h"

@interface GoodSelectToolBar()

@property (weak, nonatomic) IBOutlet SPButton *btn1;

@property (weak, nonatomic) IBOutlet SPButton *btn2;

@property (weak, nonatomic) IBOutlet SPButton *btn3;

@property (weak, nonatomic) IBOutlet SPButton *btn4;

@property (weak, nonatomic) IBOutlet UIImageView *btn4_newLab;

@property(nonatomic,assign)GoodSelectToolBarType type;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn1WidthCons;

@end

@implementation GoodSelectToolBar

-(id)initWithGoodSelectToolBarType:(GoodSelectToolBarType)type
{
    if(self = [super init]){
        self = [[NSBundle mainBundle] loadNibNamed:@"GoodSelectToolBar" owner:self options:nil].firstObject;
        self.width = kScreenWidth;
        self.height = 40;
        self.type = type;
        if(type == GoodSelectToolBarType1){
            self.btn1WidthCons.constant = kScreenWidth * 0.3333 * 0.3333;
            [self setNeedsLayout];
        }
    }
    return self;
}



//四个按钮都在这里响应
- (IBAction)btnsAction:(UIButton*)sender {
    NSInteger tag = sender.tag;
    
    [self clearBtnsWithoutBtnHasTag:tag];
    
    if (tag == 10){//综合
        if([sender.imageView.image isEqual:[UIImage imageNamed:@"searchBar单独上三角红色"]]) {
            [sender setImage:[UIImage imageNamed:@"searchBar单独下三角"] forState:UIControlStateNormal];
            // -1 打开
            [self.delegate goodSelectToolBarDidSelecedWithSort:-1 goodSelectToolBar:self];//不传sort字段
        }else{
            [sender setImage:[UIImage imageNamed:@"searchBar单独上三角红色"] forState:UIControlStateNormal];
            // 0 关闭
            [self.delegate goodSelectToolBarDidSelecedWithSort:0 goodSelectToolBar:self];
        }
    } else if (tag == 11 ) { //券后价
        
        if([sender.imageView.image isEqual:[UIImage imageNamed:@"searchBar两个灰色"]]) {
            [sender setImage:[UIImage imageNamed:@"searchBar两个灰色上方红色"] forState:UIControlStateNormal];
            [self.delegate goodSelectToolBarDidSelecedWithSort:5 goodSelectToolBar:self]; //价格增加
        } else if ([sender.imageView.image isEqual:[UIImage imageNamed:@"searchBar两个灰色上方红色"]]) {
            [sender setImage:[UIImage imageNamed:@"searchBar两个灰色下方红色"] forState:UIControlStateNormal];
            [self.delegate goodSelectToolBarDidSelecedWithSort:4 goodSelectToolBar:self]; //价格降低
        } else if ([sender.imageView.image isEqual:[UIImage imageNamed:@"searchBar两个灰色下方红色"]]) {
            [sender setImage:[UIImage imageNamed:@"searchBar两个灰色"] forState:UIControlStateNormal];
            [self.delegate goodSelectToolBarDidSelecedWithSort:-1 goodSelectToolBar:self]; //关闭下方控件
        }
    } else if (tag == 12) { //销量
        
        if([sender.imageView.image isEqual:[UIImage imageNamed:@"searchBar两个灰色"]]) {
            [sender setImage:[UIImage imageNamed:@"searchBar两个灰色上方红色"] forState:UIControlStateNormal];
            [self.delegate goodSelectToolBarDidSelecedWithSort:7 goodSelectToolBar:self]; //销量增加
        } else if ([sender.imageView.image isEqual:[UIImage imageNamed:@"searchBar两个灰色上方红色"]]) {
            [sender setImage:[UIImage imageNamed:@"searchBar两个灰色下方红色"] forState:UIControlStateNormal];
            [self.delegate goodSelectToolBarDidSelecedWithSort:6 goodSelectToolBar:self]; //销量降低
        } else if ([sender.imageView.image isEqual:[UIImage imageNamed:@"searchBar两个灰色下方红色"]]) {
            [sender setImage:[UIImage imageNamed:@"searchBar两个灰色"] forState:UIControlStateNormal];
            [self.delegate goodSelectToolBarDidSelecedWithSort:-1 goodSelectToolBar:self]; //关闭下方控件
        }
    } else { //最新
        if(_btn4_newLab.hidden == YES){
            _btn4_newLab.hidden = NO;
            [self.delegate goodSelectToolBarDidSelecedWithSort:8 goodSelectToolBar:self]; //最新
        }else{
            _btn4_newLab.hidden = YES;
            [self.delegate goodSelectToolBarDidSelecedWithSort:-1 goodSelectToolBar:self]; //关闭下方控件
        }
    }
}

-(void)clearBtnsWithoutBtnHasTag:(NSInteger)tag
{
    if(tag == 10) {
           [_btn2 setImage:[UIImage imageNamed:@"searchBar两个灰色"] forState:UIControlStateNormal];
           [_btn3 setImage:[UIImage imageNamed:@"searchBar两个灰色"] forState:UIControlStateNormal];
           _btn4_newLab.hidden = YES;
    } else if (tag == 11) {
        [_btn1 setImage:[UIImage imageNamed:@"searchBar单独下三角"] forState:UIControlStateNormal];
        [_btn3 setImage:[UIImage imageNamed:@"searchBar两个灰色"] forState:UIControlStateNormal];
        _btn4_newLab.hidden = YES;
    } else if (tag == 12) {
            [_btn1 setImage:[UIImage imageNamed:@"searchBar单独下三角"] forState:UIControlStateNormal];
            [_btn2 setImage:[UIImage imageNamed:@"searchBar两个灰色"] forState:UIControlStateNormal]; ;
              _btn4_newLab.hidden = YES;
    } else if (tag == 13) {
        [_btn1 setImage:[UIImage imageNamed:@"searchBar单独下三角"] forState:UIControlStateNormal];
        [_btn2 setImage:[UIImage imageNamed:@"searchBar两个灰色"] forState:UIControlStateNormal];
        [_btn3 setImage:[UIImage imageNamed:@"searchBar两个灰色"] forState:UIControlStateNormal];
    }
}


/**
 用户切换sort 调用这个后不会再回调delegate  这个方法有待保留
 */
-(void)setSort:(int)sort
{
    if(sort == 0) {
        [_btn1 setImage:[UIImage imageNamed:@"searchBar单独下三角"] forState:UIControlStateNormal];
    }else if (sort == 1) {
        [_btn1 setImage:[UIImage imageNamed:@"searchBar单独上三角红色"] forState:UIControlStateNormal];
    }
}

@end
