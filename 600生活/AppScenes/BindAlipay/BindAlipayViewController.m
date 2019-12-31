//
//  BindAlipayViewController.m
//  600生活
//
//  Created by iOS on 2019/11/13.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "BindAlipayViewController.h"

@interface BindAlipayViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UITextField *aliTf;

@property(nonatomic,assign)BOOL isNameTfOk;  //名字是否输入
@property(nonatomic,assign)BOOL isAliTfOk;   //支付宝账号是否输入

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property(nonatomic,assign) BOOL isSureBtnEnable; //只用来改变UI 不判断数据逻辑

@end

@implementation BindAlipayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"绑定支付宝";
    self.nameTf.delegate = (id)self;
    self.aliTf.delegate = (id)self;
}

#pragma mark - control action

- (IBAction)sureBtnAction:(id)sender {
    if(self.nameTf.text.length > 0 && self.aliTf.text.length > 0){
        [self requestBindZfb];
    }else{
        [[LLHudHelper sharedInstance]tipMessage:@"请完成输入"];
    }
}


#pragma mark - 网络请求
//绑定支付宝
-(void)requestBindZfb
{
    __weak BindAlipayViewController* wself = self;
    NSDictionary* param = @{
        @"name":self.nameTf.text,
        @"alipay_no":self.aliTf.text
    };
    [[LLNetWorking sharedWorking]helper];
    [self PostWithUrlStr:kFullUrl(kBindZfb) param:param showHud:YES resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes){
            [wself handleBindZfb:res[@"data"]];
        }
    } falsed:^(NSError * _Nullable error) {
    }];
}

-(void)handleBindZfb:(NSDictionary*)data
{
    [[LLHudHelper sharedInstance]tipMessage:@"支付宝绑定成功"];
    __weak BindAlipayViewController* wself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [wself.navigationController popViewControllerAnimated:YES];
    });
}

#pragma mark textfeild delegate

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason API_AVAILABLE(ios(10.0))
{
    if(textField == self.nameTf){
        self.isNameTfOk = textField.text.length == 11;
    }
    
    if(textField == self.aliTf){
        self.isAliTfOk = textField.text.length > 0;
    }
    
    if(self.isAliTfOk && self.isAliTfOk){
        self.isSureBtnEnable = YES;
    }else{
        self.isSureBtnEnable = NO;
    }
}


#pragma mark - setter

-(void)setIsSureBtnEnable:(BOOL)isSureBtnEnable
{
    _isSureBtnEnable = isSureBtnEnable;
    
    __weak BindAlipayViewController* wself = self;
    
    if(isSureBtnEnable) {
    
        dispatch_async(dispatch_get_main_queue(), ^{
            wself.sureBtn.backgroundColor = [UIColor colorWithHexString:@"#F54556"];
            [wself.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        });
        
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            wself.sureBtn.backgroundColor = [UIColor colorWithHexString:@"#E9E9E9"];
            [wself.sureBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        });
       
    }
}


@end
