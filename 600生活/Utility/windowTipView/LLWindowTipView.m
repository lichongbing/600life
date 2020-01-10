//
//  LLWindowTipView.m
//  600生活
//
//  Created by iOS on 2019/11/18.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "LLWindowTipView.h"

@interface LLWindowTipView()

@property(nonatomic,assign) WindowTipViewType type;

//专属客服
@property (weak, nonatomic) IBOutlet UIView *customerService;

//提醒注册
@property (weak, nonatomic) IBOutlet UIView *goSigin;

//智能搜索
@property (weak, nonatomic) IBOutlet UIView *aiSearch;

//分享
@property (weak, nonatomic) IBOutlet UIView *share;

//跳转淘宝过渡图
@property (weak, nonatomic) IBOutlet UIView *gotoTaoBao;

//上一级用户
@property (weak, nonatomic) IBOutlet UIView *superiorUser;

//发现新版本
@property (weak, nonatomic) IBOutlet UIView *findNewVersion;


@end

@implementation LLWindowTipView

-(id)initWithType:(WindowTipViewType)type
{
    if (self = [super init]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"LLWindowTipView" owner:self options:nil].firstObject;
        self.type = type;
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


#pragma mark - control action

//释放
- (IBAction)bgBtnClicked:(id)sender {
    [self dismiss];
}


/**
 WindowTipViewTypeCustomerService 专属客服
 */

- (IBAction)customerServiceLeftBtnAction:(id)sender {
    if(self.customerServiceLeftBtnAction){
        if(self.customerServiceData[@"wx"]){
             self.customerServiceLeftBtnAction(self.customerServiceData[@"wx"]);
        }
    }
    [self dismiss];
}


- (IBAction)customerServiceRightBtnAction:(id)sender {
    if(self.customerServiceRightBtnAction){
        UIImageView* icon = [self.customerService viewWithTag:1];
        if(icon.image && ![icon.image isEqual:kPlaceHolderImg]){
            self.customerServiceRightBtnAction(icon.image);
        }
    }
    [self dismiss];
}


/**
*WindowTipViewTypeGoSigin  提醒注册
*/
- (IBAction)GoSiginBtnAction:(id)sender {
    if(self.goSiginBtnAction){
        self.goSiginBtnAction();
    }
    [self dismiss];
}


/**
 分享
 */
- (IBAction)shareCancelBtnAction:(id)sender {
    [self dismiss];
}

- (IBAction)shareBtnAction:(UIButton*)sender {
    NSInteger index = sender.tag - 10;
    if(index == 0){
        //微信
        if(self.shareLeftBtnAction){
            self.shareLeftBtnAction();
        }
    }else if(index == 1){
        //朋友圈
        if(self.shareCenterBtnAction){
            self.shareCenterBtnAction();
        }
    }else if(index == 2){
        //下载图
        if(self.shareRightBtnAction){
            self.shareRightBtnAction();
        }
    }
}

/**
智能搜索
*/
- (IBAction)aisearchBtnAction:(id)sender {
    if(self.aiSearchSureBtnAction){
        self.aiSearchSureBtnAction();
    }
}

/**
发现新版本
*/
- (IBAction)fineNewVersionBtnAction:(id)sender {
    if(self.findNewVersionBtnAction){
        self.findNewVersionBtnAction();
    }
}




#pragma mark - helper
-(void)show
{
    if( [[UIApplication sharedApplication].keyWindow viewWithTag:kWindowTipViewTag]) {
        UIView* p = [[UIApplication sharedApplication].keyWindow viewWithTag:kWindowTipViewTag];
        [p removeFromSuperview];
        p = nil;
    }
    
    self.tag = kWindowTipViewTag;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    __weak LLWindowTipView* wself = self;
    
    [UIView animateWithDuration:0.3 animations:^{
        wself.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    } completion:nil];
}

-(void)dismiss
{
    __weak LLWindowTipView* wself = self;
    [UIView animateWithDuration:0.3 animations:^{
        wself.alpha = 0;
    } completion:^(BOOL finished) {
        if(finished){
            [[wself viewWithTag:wself.type] removeFromSuperview];
            [wself removeFromSuperview];
        }
    }];
}

#pragma mark - setter

-(void)setType:(WindowTipViewType)type
{
    kisMainThread;
    _type = type;
    if(type == WindowTipViewTypeCustomerService){
        self.customerService.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [self addSubview:self.customerService];
        
    }else if(type == WindowTipViewTypeGoSigin){
        self.goSigin.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [self addSubview:self.goSigin];
    }else if(type == WindowTipViewTypeAISearch){
        self.aiSearch.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [self addSubview:self.aiSearch];
    } else if (type == WindowTipViewTypeShare){
        self.share.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [self addSubview:self.share];
    } else if(type == WindowTipViewTypeTaoBao){
        self.gotoTaoBao.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [self addSubview:self.gotoTaoBao];
    } else if (type == WindowTipViewTypeSuperiorUser){
        self.superiorUser.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [self addSubview:self.superiorUser];
    } else if (type == WindowTipViewTypeNewVersion){
        self.findNewVersion.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [self addSubview:self.findNewVersion];
    }
}

-(void)setCustomerServiceData:(NSDictionary *)customerServiceData
{
    _customerServiceData = customerServiceData;
    if(self.type == WindowTipViewTypeCustomerService){
        UIImageView* icon = [self.customerService viewWithTag:1];
        [icon sd_setImageWithURL:[NSURL URLWithString:customerServiceData[@"wx_qrcode"]] placeholderImage:kPlaceHolderImg];
    }
}

-(void)setIncome:(NSString *)income
{
    _income = income;
    UILabel* incomeLab = [self.gotoTaoBao viewWithTag:1];
    if(income){
        incomeLab.text = [NSString stringWithFormat:@"收益 ￥%@",income];
    }
}

-(void)setSearchStr:(NSString *)searchStr
{
    _searchStr = searchStr;
    UILabel* contentLab = [self.aiSearch viewWithTag:1];
    contentLab.text = searchStr;
}

-(void)setSuperiorUserInfo:(SuperiorUserInfo *)superiorUserInfo
{
    _superiorUserInfo = superiorUserInfo;
    UIImageView* icon = [self.superiorUser viewWithTag:1];
    UILabel* nameLab = [self.superiorUser viewWithTag:2];
    UILabel* telLab = [self.superiorUser viewWithTag:3];
    
    [icon sd_setImageWithURL:[NSURL URLWithString:superiorUserInfo.avatar]];
    nameLab.text = superiorUserInfo.username;
    telLab.text = superiorUserInfo.mobile;
}

@end
