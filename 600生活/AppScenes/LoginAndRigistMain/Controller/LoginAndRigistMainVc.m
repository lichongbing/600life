//
//  LoginAndRigistMainVc.m
//  600生活
//
//  Created by iOS on 2019/11/1.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "LoginAndRigistMainVc.h"
#import "InviteCodeViewController.h"  //邀请码
#import "YBPopupMenu.h"
#import "UIImage+ext.h"
#import "LLTabBarController.h"
#import "UserPrivccyViewController.h" //隐私政策阅读

@interface LoginAndRigistMainVc ()<YBPopupMenuDelegate>


@property (weak, nonatomic) IBOutlet UIButton *backBtn;

//登录过期跳转到登录界面来的 会隐藏返回按钮
@property (nonatomic,assign)BOOL ifHiddenBackBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navViewHeightCons;

@property (weak, nonatomic) IBOutlet UIView *telBgView;  //电话号码背景视图
@property (weak, nonatomic) IBOutlet UITextField *telTf;

@property (weak, nonatomic) IBOutlet UIView *pwdBgView;  //密码背景视图
@property (weak, nonatomic) IBOutlet UITextField *pwdTf;


@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn; //获取验证码按钮

@property (weak, nonatomic) IBOutlet UIButton *agreenBtn; //同意按钮

@property (weak, nonatomic) IBOutlet UIButton *loginBtn; //登陆按钮
@property (weak, nonatomic) IBOutlet UIView *infoBgView;

@property(nonatomic,assign)BOOL isShowHistory;//是否展示过历史用户



@end


@interface LoginAndRigistMainVc ()
@property(nonatomic,strong)NSTimer* timer;
@end


@implementation LoginAndRigistMainVc
-(void)awakeFromNib
{
    [super awakeFromNib];
}

-(id)init
{
    if(self = [super init]){
        [self setNavBackItemHidden];
    }
    return self;
}

-(id)initWithNoBackItem
{
    if(self = [super init]){
        [self setNavBackItemHidden];
        self.ifHiddenBackBtn = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if(self.ifHiddenBackBtn){
        self.backBtn.hidden = YES;
    }
    [self setupUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenNavigationBarWithAnimation:animated];
    self.fd_prefersNavigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self showNavigationBarWithAnimation:animated];
}

-(void)setupUI
{
    self.navViewHeightCons.constant = kNavigationBarHeight;
    self.infoBgView.layer.borderColor = kAppBackGroundColor.CGColor;
    self.infoBgView.layer.borderWidth = 1;
    self.infoBgView.layer.cornerRadius = 5;
    
    self.telBgView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    self.pwdBgView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    
    self.getCodeBtn.layer.borderWidth = 1;
    self.getCodeBtn.layer.borderColor = kAppRedColor.CGColor;
    self.getCodeBtn.layer.cornerRadius = 18;
    
    self.loginBtn.layer.borderWidth = 1;
    self.loginBtn.layer.borderColor = kAppBackGroundColor.CGColor;
    self.loginBtn.layer.cornerRadius = 20;

}

#pragma mark - 网络请求

//获取验证码
-(void)requestGetCode
{
    NSDictionary* param = @{
        @"mobile" : self.telTf.text
    };
    
    [self PostWithUrlStr:kFullUrl(kGetValidateCode) param:param showHud:YES resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes) {
            [[LLHudHelper sharedInstance]tipMessage:@"发送成功"];
        }
    } falsed:^(NSError * _Nullable error) {
        
    }];
}

//登陆或者注册
-(void)requestLoginOrRegist
{
    NSDictionary* param = @{
        @"mobile" : self.telTf.text ,    //电话号码
        @"verification_code" : self.pwdTf.text  //验证码
    };
    
    [self PostWithUrlStr:kFullUrl(kLogin) param:param showHud:YES resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes) {
            [self handleLoginOrRegist:res];
        }
    } falsed:^(NSError * _Nullable error) {
        
    }];
}

-(void)handleLoginOrRegist:(NSDictionary*)res
{
    NSError* err = nil;
    LLUser* newUser = [[LLUser alloc]initWithDictionary:res[@"data"][@"user"] error:&err];
    newUser.isLogin = 1;
    
    newUser.expire_time = res[@"data"][@"expire_time"];
    newUser.is_invite = res[@"data"][@"is_invite"];
    newUser.token = res[@"data"][@"token"];
          
    BOOL isInsertSuccess = NO;  //判断新用户或者老用户是否插入db成功
    NSLock *lock = [[NSLock alloc] init];
    [lock lock];
    isInsertSuccess = [[LLUserManager shareManager]insertOrUpdateCurrentUser:newUser];//插入或更新用户
    [lock unlock];
    if(isInsertSuccess){
        //内存中获取对应id的用户
        [[LLUserManager shareManager]switchUserWithId:[NSString stringWithFormat:@"%@",newUser.id]];
        //保存用户头像到本地
        [UIImage saveImageForKey:newUser.avatar];
        //内存中更新token
        [[LLNetWorking sharedWorking]updataHttpHeaderWithToken: newUser.token];
    }else{
         [[LLHudHelper sharedInstance]tipMessage:@"数据库操作失败"];
    }
    
    __weak LoginAndRigistMainVc* wself = self;
    
    //用户数据操作结束 进行跳转或者其他操作
    
    //判断邀请码是否填写了上一级邀请码
   if([LLUserManager shareManager].currentUser.is_invite.intValue == 0){
       dispatch_async(dispatch_get_main_queue(), ^{
           InviteCodeViewController* vc = [[InviteCodeViewController alloc]initWithIsShowRightItem:YES];
           vc.hidesBottomBarWhenPushed = YES;
           [wself.navigationController pushViewController:vc animated:YES];
       });
   } else if ([LLUserManager shareManager].currentUser.is_invite.intValue == 1){
       //填写过了邀请码
       dispatch_async(dispatch_get_main_queue(), ^{
           [wself.navigationController popToRootViewControllerAnimated:YES];
           LLTabBarController* tabVC = [LLTabBarController sharedController];
           [tabVC.nc4 popToRootViewControllerAnimated:NO];
           
           //防止 tabVC被隐藏
           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               [tabVC setSelectedIndex:0];
               tabVC.selectedViewController = tabVC.nc1;
           });
       });
   }
}


#pragma mark - control action

- (IBAction)backItemAction:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)telTfDidBeginEditing:(UITextField*)sender {
   
    
    if(_isShowHistory == YES){
        return;
    }
    
    CGFloat telBgViewTop = _telBgView.top;
    CGFloat top = telBgViewTop + 40;
    CGFloat left = 32 + 13 + 14 + 80;
    
    NSArray* users = [[LLUserManager shareManager]getAllRecordUsers];
    
    if(users.count == 0){return;}
    
    NSMutableArray* titles = [NSMutableArray new];
    NSMutableArray* avatars = [NSMutableArray new];
    
    for(int i = 0; i < users.count; i++){
        LLUser* user = [users objectAtIndex:i];
        NSString* title = user.user_nickname;
        NSString* avatar = user.avatar;
        if(title){
            [titles addObject:title];
        }
        
        UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:kFullUrl(avatar)]]];
        if(image){
            [avatars addObject:[UIImage scaleToSize:image size:CGSizeMake(25, 25)]];
            //表示所有图片已经ok
            if(avatars.count == users.count){
                [YBPopupMenu showAtPoint:CGPointMake(left, top) titles:titles icons:avatars menuWidth:200 delegate:self];
            }
        }
    }
    
   
    _isShowHistory = YES;
}

- (IBAction)telTfDidEndEditing:(UITextField*)sender {
    
}

- (IBAction)pwdTfDidEndEditing:(UITextField*)sender {
    
}

//获取验证码按钮
- (IBAction)getCodeBtnAction:(UIButton*)sender {
    if (_telTf.text.length != 11) {
        [[LLHudHelper sharedInstance]tipMessage:@"请正确输入手机号"];
    } else {
        [self requestGetCode];
        [self initTimer];
        _pwdTf.text = nil;
    }
}

//隐私政策点击
- (IBAction)readBtnAction:(UIButton*)sender {
    NSString* url = kFullUrl(kUserPrivccy);
    UserPrivccyViewController* vc = [[UserPrivccyViewController alloc]initWithUrl:url title:@"用户协议"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


//同意隐私政策

- (IBAction)agreenBtnAction:(UIButton*)sender {
    sender.selected = !sender.isSelected;
    if(sender.selected) {
        [sender setImage:[UIImage imageNamed:@"loginMain_check"] forState:UIControlStateNormal];
    } else {
        [sender setImage:[UIImage imageNamed:@"loginMain_uncheck"] forState:UIControlStateNormal];
    }
}

//登陆按钮点击
- (IBAction)loginBtnAction:(UIButton*)sender {
    
    if(_telTf.text.length != 11){
        [[LLHudHelper sharedInstance]tipMessage:@"请正确输入电话号码"];
        return;
    }
    
    if(_pwdTf.text.length == 0){
        [[LLHudHelper sharedInstance]tipMessage:@"请输入验证码"];
        return;
    }
    
    
    if(!_agreenBtn.selected){
        [[LLHudHelper sharedInstance]tipMessage:@"确认已阅读用户协议"];
        return;
    }
    
    //网络请求 登录接口
    [self requestLoginOrRegist];
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
        __weak LoginAndRigistMainVc* wself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            wself.getCodeBtn.enabled = NO;
            [wself.getCodeBtn setTitle:[NSString stringWithFormat:@"%d秒",s_timerCounter] forState:UIControlStateNormal];
            wself.getCodeBtn.backgroundColor = [UIColor lightGrayColor];
            s_timerCounter--;
        });
    } else if (s_timerCounter == 0) {
        s_timerCounter = 60;  //重置时间未max
        [self deInitGlobalQueueTimer]; //析构timer
        __weak LoginAndRigistMainVc* wself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            wself.getCodeBtn.enabled = YES;
            [wself.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            wself.getCodeBtn.backgroundColor = [UIColor whiteColor];
        });
    }
}


-(void)deInitGlobalQueueTimer
{
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - YBPopupMenu 代理
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu
{
    NSArray* users = [[LLUserManager shareManager]getAllRecordUsers];
    LLUser* user = [users objectAtIndex:index];
    _telTf.text = user.mobile;
}

@end
