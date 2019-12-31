//
//  ChangePhone2ViewController.m
//  600生活
//
//  Created by iOS on 2019/11/13.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "ChangePhone2ViewController.h"

@interface ChangePhone2ViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *telTf;
@property(nonatomic,assign)BOOL isTelTfOk;

@property (weak, nonatomic) IBOutlet UITextField *yanTf;
@property(nonatomic,assign)BOOL isYanTfOk;
@property(nonatomic,strong)NSTimer* timer;

@property (weak, nonatomic) IBOutlet UIButton *yanBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property(nonatomic,assign)BOOL isAllInpulOk;

@end

@implementation ChangePhone2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"修改手机号";
    self.telTf.delegate = (id)self;
    self.yanTf.delegate = (id)self;
}

//kChangeMobile
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

//更改手机号
-(void)requestChangeNameWithNewName:(NSString*)mobile verification_code:(NSString*)verification_code
{
    NSDictionary* param = @{
        @"mobile" : mobile,
        @"verification_code" : verification_code
    };
    __weak ChangePhone2ViewController* wself = self;
    [self PostWithUrlStr:kFullUrl(kChangeMobile) param:param showHud:YES resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes){
            [[LLHudHelper sharedInstance]tipMessage:@"修改成功"];
            LLUser* user = [LLUserManager shareManager].currentUser;
            user.mobile = wself.telTf.text;
           [[LLUserManager shareManager]insertOrUpdateCurrentUser:user];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIViewController* vc = [self.navigationController.viewControllers objectAtIndex:1];
                [wself.navigationController popToViewController:vc animated:YES];
            });
        }
    } falsed:^(NSError * _Nullable error) {
    }];
}

#pragma mark - control action

//获取验证码
- (IBAction)yanBtnAction:(id)sender {
    [self requestGetCode];
    [self initTimer];
}

- (IBAction)sureBtnAction:(id)sender {
    if(_isAllInpulOk){
        [self requestChangeNameWithNewName:self.telTf.text verification_code:self.yanTf.text];
    }else{
        [[LLHudHelper sharedInstance]tipMessage:@"请正确输入"];
    }
}

#pragma mark textfeild delegate

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason API_AVAILABLE(ios(10.0))
{
    if(textField == self.telTf){
        self.isTelTfOk = textField.text.length == 11;
    }
    if(textField == self.yanTf){
        self.isYanTfOk = textField.text.length > 0;
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
        __weak ChangePhone2ViewController* wself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            wself.yanBtn.enabled = NO;
            [wself.yanBtn setTitle:[NSString stringWithFormat:@"%d秒",s_timerCounter] forState:UIControlStateNormal];
            wself.yanBtn.backgroundColor = [UIColor lightGrayColor];
            [wself.yanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            s_timerCounter--;
        });
    } else if (s_timerCounter == 0) {
        s_timerCounter = 60;  //重置时间未max
        [self deInitGlobalQueueTimer]; //析构timer
        __weak ChangePhone2ViewController* wself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            wself.yanBtn.enabled = YES;
            [wself.yanBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            wself.yanBtn.backgroundColor = [UIColor whiteColor];
            [wself.yanBtn setTitleColor:[UIColor colorWithHexString:@"F54556"] forState:UIControlStateNormal];
        });
    }
}


-(void)deInitGlobalQueueTimer
{
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - setter
-(void)setIsAllInpulOk:(BOOL)isAllInpulOk
{
    _isAllInpulOk = isAllInpulOk;
    __weak ChangePhone2ViewController* wself = self;
          
          if(isAllInpulOk) {
          
              dispatch_async(dispatch_get_main_queue(), ^{
                  wself.sureBtn.backgroundColor = [UIColor colorWithHexString:@"#F54556"];
                  [wself.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                  [wself.sureBtn setTitle:@"完成" forState:UIControlStateNormal];
              });
              
          } else {
              dispatch_async(dispatch_get_main_queue(), ^{
                  wself.sureBtn.backgroundColor = [UIColor colorWithHexString:@"#E9E9E9"];
                  [wself.sureBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
                  [wself.sureBtn setTitle:@"验证后绑定新手机" forState:UIControlStateNormal];
              });
             
          }
}
@end
