//
//  ChangePhoneViewController.m
//  600生活
//
//  Created by iOS on 2019/11/13.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "ChangePhone1ViewController.h"
#import "ChangePhone2ViewController.h"

@interface ChangePhone1ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *oldTelLab;//原手机号码
@property (weak, nonatomic) IBOutlet UITextField *yanTf; //输入验证码tf
@property(nonatomic,assign) BOOL isYanTfOk;  //输入验证码是否输入
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;//获取验证码按钮
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;  //确认按钮



@property(nonatomic,strong)NSTimer* timer;

@end

@implementation ChangePhone1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"修改电话号码";
    NSString* oldMobie = [LLUserManager shareManager].currentUser.mobile;
    NSMutableString* mutStr = [[NSMutableString alloc]initWithString:oldMobie];
    NSRange rage = NSMakeRange(3, 4);
    [mutStr replaceCharactersInRange:rage withString:@"****"];
    self.oldTelLab.text = mutStr;
    self.yanTf.delegate = (id)self;
}

#pragma mark - control action

//获取验证码
- (IBAction)getCodeBtnAction:(id)sender {
    [self requestGetCode];
    [self initTimer];
}


- (IBAction)sureBtnAction:(id)sender {
    if(self.isYanTfOk){ //如果tf有值
        [self requestVerifyMobile]; //校验手机和输入的验证码
    }else{ //[self handleVerifyMobile];
        [[LLHudHelper sharedInstance]tipMessage:@"请输入验证码"];
    }
}

#pragma mark - 网络请求

//获取验证码
-(void)requestGetCode
{
    NSDictionary* param = @{
        @"mobile" : [LLUserManager shareManager].currentUser.mobile
    };
    
    [self PostWithUrlStr:kFullUrl(kGetValidateCode) param:param showHud:YES resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes) {
            [[LLHudHelper sharedInstance]tipMessage:@"发送成功"];
        }
    } falsed:^(NSError * _Nullable error) {
        
    }];
}

//校验手机号
-(void)requestVerifyMobile
{
    NSDictionary* param = @{
        @"mobile" : [LLUserManager shareManager].currentUser.mobile,
        @"verification_code" : _yanTf.text
    };
    
    __weak ChangePhone1ViewController* wself = self;
    [self PostWithUrlStr:kFullUrl(kVerifyMobile) param:param showHud:YES resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes) {
            [wself handleVerifyMobile];
        }
    } falsed:^(NSError * _Nullable error) {
        
    }];
}

-(void)handleVerifyMobile
{
    [[LLHudHelper sharedInstance]tipMessage:@"校验成功"];
    
    __weak ChangePhone1ViewController* wself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ChangePhone2ViewController* vc = [ChangePhone2ViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        [wself.navigationController pushViewController:vc animated:YES];
    });
}




#pragma mark textfeild delegate

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason API_AVAILABLE(ios(10.0))
{
    if(textField == self.yanTf){
        self.isYanTfOk = textField.text.length > 0;
    }
}

-(void)setIsYanTfOk:(BOOL)isYanTfOk
{
    _isYanTfOk = isYanTfOk;
    __weak ChangePhone1ViewController* wself = self;
       
       if(isYanTfOk) {
       
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

#pragma mark - heler

-(void)initTimer
{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        [[NSRunLoop mainRunLoop] run];
        [_timer fire];
    }
}

-(void)timerAction:(NSTimer*)timer
{
    static int s_timerCounter = 60;   //计时器 最多60秒
    if (s_timerCounter > 0) {
        __weak ChangePhone1ViewController* wself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            wself.getCodeBtn.enabled = NO;
            [wself.getCodeBtn setTitle:[NSString stringWithFormat:@"%d秒",s_timerCounter] forState:UIControlStateNormal];
            wself.getCodeBtn.backgroundColor = [UIColor lightGrayColor];
            [wself.getCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            s_timerCounter--;
        });
    } else if (s_timerCounter == 0) {
        s_timerCounter = 60;  //重置时间未max
        [self deInitGlobalQueueTimer]; //析构timer
        __weak ChangePhone1ViewController* wself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            wself.getCodeBtn.enabled = YES;
            [wself.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            wself.getCodeBtn.backgroundColor = [UIColor whiteColor];
            [wself.getCodeBtn setTitleColor:[UIColor colorWithHexString:@"F54556"] forState:UIControlStateNormal];
        });
    }
}


-(void)deInitGlobalQueueTimer
{
    [_timer invalidate];
    _timer = nil;
}
@end
