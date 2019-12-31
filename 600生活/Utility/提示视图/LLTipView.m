//
//  LLTipView.m
//  600生活
//
//  Created by iOS on 2019/11/11.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "LLTipView.h"

@interface LLTipView()
//当前tipView的图片
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
//当前tipView的提示文字
@property (weak, nonatomic) IBOutlet UILabel *msgLab;
//当前tipView的无网络重加载按钮
@property (weak, nonatomic) IBOutlet UIButton *noNetBtn;

@property(nonatomic,strong)NSString* iconName;
@property(nonatomic,strong)NSString* msg;

@end


@implementation LLTipView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.width = kScreenWidth;
}

//设置根据父视图 得到自身frame
-(instancetype)initWithType:(LLTipViewType)type
         iconName:(NSString*)iconName
              msg:(NSString*)msg
        superView:(UIView*)superView
{
    if (self = [super init]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"LLTipView" owner:self options:nil].firstObject;
        self.frame = CGRectMake(0, 0, superView.width, superView.height);
        self.type = type;
        self.tag = kTipViewTag;
        [superView addSubview:self];
        self.iconName = [[NSString alloc]initWithString:iconName];
        self.msg = [[NSString alloc]initWithString:msg];
        [self resetupUIWithSuperView];
    }
    return self;
}


-(void)resetupUIWithSuperView
{
    self.imageView.width = self.width * 182 / 375;
    self.imageView.height = self.imageView.width * 125 / 182;
    self.imageView.centerX = self.width * 0.5;
    self.imageView.centerY = self.height * 0.4;
    self.imageView.image = [UIImage imageNamed:self.iconName];
    
    self.msgLab.width = self.width;
    self.msgLab.height = 20;
    self.msgLab.top = self.imageView.bottom + 10;
    self.msgLab.left = 0;
    self.msgLab.text = self.msg;
       
    self.noNetBtn.top = self.msgLab.bottom + 10;
    self.noNetBtn.centerX = self.width * 0.5;
}

-(void)setType:(LLTipViewType)type
{
    _type = type;
    
    if(_type == LLTipViewTypeNoNet){
        self.backgroundColor = kAppBackGroundColor;
        _noNetBtn.hidden = NO;
        [self addNoNetFunction];
        
    } else {
        _noNetBtn.hidden = YES;
    }
}



#pragma mark -- 刷新数据
-(void)addNoNetFunction
{
    [_noNetBtn addTarget:self action:@selector(noNetBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)noNetBtnAction:(UIButton*)btn
{
    if(self.refreshBtnCallback){
        self.refreshBtnCallback();
    }
}



@end
