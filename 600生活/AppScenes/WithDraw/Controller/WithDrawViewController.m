//
//  WithDrawViewController.m
//  600生活
//
//  Created by iOS on 2019/11/19.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "WithDrawViewController.h"
#import "WithDrawHistoryViewController.h"  //提现历史记录
#import "BindAlipayViewController.h"//绑定支付宝

#define kIsBindZFB ([LLUserManager shareManager].currentUser.is_bind_zfb.intValue == 1)

@interface WithDrawViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLab;  //真实姓名
@property (weak, nonatomic) IBOutlet UILabel *acountLab; //收款账户

@property (weak, nonatomic) IBOutlet UITextField *inputMoneyTf;  //提现金额
@property(nonatomic,assign)BOOL isInputMoneyTfOk;

@property (weak, nonatomic) IBOutlet UILabel *remainLab; //余额

@property (weak, nonatomic) IBOutlet UIButton *allMoneyBtn; //全部提现按钮
@property (weak, nonatomic) IBOutlet UIButton *sureBtn; //提现按钮

@end

@implementation WithDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"提现";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.inputMoneyTf.delegate = (id)self;
    
    //未绑定支付宝
    if(!kIsBindZFB){
        __weak WithDrawViewController* wself = self;
        [LLHudHelper alertTitle:@"尚未绑定支付宝" message:@"\n尚未绑定支付宝，是否绑定支付宝？" cancel:@"不必了" sure:@"好的,我要绑定" cancelAction:^{
            [wself.navigationController popViewControllerAnimated:YES];
        } sureAction:^{
            BindAlipayViewController* vc = [BindAlipayViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [wself.navigationController pushViewController:vc animated:YES];
        }];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(kIsBindZFB){
        self.nameLab.text = [NSString stringWithFormat:@"%@",[LLUserManager shareManager].currentUser.zfb_name];
        self.acountLab.text = [NSString stringWithFormat:@"%@",[LLUserManager shareManager].currentUser.zfb_no];
        self.remainLab.text = [NSString stringWithFormat:@"可用余额:￥%@元",[LLUserManager shareManager].currentUser.balance];
        self.inputMoneyTf.enabled = YES;
        self.allMoneyBtn.enabled = YES;
        [self setNavRightItemWithTitle:@"提现记录" titleColor:[UIColor colorWithHexString:@"#666666"] selector:@selector(rightItemAction)];
        self.sureBtn.enabled = YES;
    }else{
        self.nameLab.text = nil;
        self.acountLab.text = nil;
        self.remainLab.text = [NSString stringWithFormat:@"可用余额"];
        self.inputMoneyTf.enabled = NO;
        self.allMoneyBtn.enabled = NO;
        [self setNavRightItemWithTitle:@"" titleColor:[UIColor clearColor] selector:nil];
        self.sureBtn.enabled = NO;
    }
}




#pragma mark - 网络请求
//提现
-(void)requestCashOut
{
    NSDictionary* param = @{
        @"money" : self.inputMoneyTf.text
    };
    
    __weak WithDrawViewController* wself = self;
    [self PostWithUrlStr:kFullUrl(kCashOut) param:param showHud:YES resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes) {
            dispatch_async(dispatch_get_main_queue(), ^{
                 [wself handleCashOut:wself.inputMoneyTf.text];
            });
        }
    } falsed:^(NSError * _Nullable error) {
        
    }];
}

-(void)handleCashOut:(NSString*)outStr
{
    [[LLHudHelper sharedInstance]tipMessage:@"提现成功" delay:2.0];
    float allM = [[LLUserManager shareManager].currentUser.balance floatValue];
    float outM = [outStr floatValue];
    float remain = allM - outM;
    [LLUserManager shareManager].currentUser.balance = [NSString stringWithFormat:@"%.2f",remain];
    self.remainLab.text = [NSString stringWithFormat:@"可用余额:￥%.2f元",remain];
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - control action

-(void)rightItemAction
{
    WithDrawHistoryViewController* vc = [WithDrawHistoryViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)selectAllMoneyBtnAction:(id)sender {
    if([[LLUserManager shareManager].currentUser.balance floatValue] == 0){
        [[LLHudHelper sharedInstance]tipMessage:@"余额不足"];
    }else{
        self.inputMoneyTf.text = [LLUserManager shareManager].currentUser.balance;
    }
}

//确认提现
- (IBAction)sureBtnAction:(id)sender {
   [self requestCashOut];
}

#pragma mark - textfiel delegate

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason API_AVAILABLE(ios(10.0))
{
    if(textField == self.inputMoneyTf){
        self.isInputMoneyTfOk = textField.text.length > 0;
    }
}


-(void)setIsInputMoneyTfOk:(BOOL)isInputMoneyTfOk
{
    _isInputMoneyTfOk = isInputMoneyTfOk;
    if(isInputMoneyTfOk){
        self.sureBtn.backgroundColor = [UIColor colorWithHexString:@"F54556"];
        [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        self.sureBtn.backgroundColor = [UIColor colorWithHexString:@"E6E6E6"];
        [self.sureBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    }
}


@end
