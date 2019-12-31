//
//  LoginAndRigistInviteCodeVc.m
//  600生活
//
//  Created by iOS on 2019/11/1.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "InviteCodeViewController.h"
#import "ScanQRCodeViewController.h" //扫描二维码
#import "LoginAndRigistMainVc.h"

@interface InviteCodeViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *codeTf;
@property(nonatomic,assign)BOOL isCodeTfOK;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;


@property(nonatomic,assign)BOOL isShowRightItem; //是否展示rightItem

@end

@implementation InviteCodeViewController


//是否展示rightItem按钮("跳过"按钮)
-(id)initWithIsShowRightItem:(BOOL)isShow
{
    if(self = [super init]){
        self.isShowRightItem = isShow;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.contentView.layer.borderWidth = 1;
       self.contentView.layer.borderColor = [UIColor colorWithHexString:@"#FFCACF"].CGColor;
    
    self.title = @"邀请码";
    
    if(self.isShowRightItem){
         [self setNavRightItemWithTitle:@"跳过填写" titleColor:[UIColor blackColor] selector:@selector(rightItemAction)];
    }
   
    self.view.backgroundColor = [UIColor whiteColor];
    self.nameLab.text = [NSString stringWithFormat:@"%@",[LLUserManager shareManager].currentUser.user_nickname];
    
    self.codeTf.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)rightItemAction
{
    NSArray* vcs = self.navigationController.viewControllers;
    if(vcs.count > 0){
        LoginAndRigistMainVc* vc = [vcs objectAtIndex:vcs.count -2];
        if([vc isKindOfClass:[LoginAndRigistMainVc class]]){
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}


#pragma mark - 网络请求
-(void)requestInsertInviteCode
{
    __weak InviteCodeViewController* wself = self;
    NSDictionary* param = @{
        @"invite_code":self.codeTf.text
    };
    
    [self PostWithUrlStr:kFullUrl(kInviteCode) param:param showHud:YES resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes){
            [wself handleInsertInviteCode:res[@"data"]];
        }
    } falsed:^(NSError * _Nullable error) {
    }];
}

-(void)handleInsertInviteCode:(NSDictionary*)data
{
    LLUser* user = [LLUserManager shareManager].currentUser;
    user.is_invite = [NSNumber numberWithInt:1];
    [[LLUserManager shareManager]insertOrUpdateCurrentUser:user];
    
    [[LLHudHelper sharedInstance]tipMessage:@"操作成功"];
    __weak InviteCodeViewController* wself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [wself.navigationController popViewControllerAnimated:YES];
    });
}

//二维码按钮
- (IBAction)qrBtnAction:(id)sender {
    ScanQRCodeViewController* vc = [[ScanQRCodeViewController alloc]init];
    vc.title = @"扫描二维码";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    vc.didSuccessScanCallBack = ^(NSString * _Nonnull content) {
        
    };
}

//确认
- (IBAction)sureBtnAction:(id)sender {
    if(_isCodeTfOK){
        [self requestInsertInviteCode];
    }else{
        [[LLHudHelper sharedInstance]tipMessage:@"请输入邀请码"];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason API_AVAILABLE(ios(10.0))
{
    if(textField == self.codeTf){
        self.isCodeTfOK = textField.text.length > 0;
    }
}

#pragma mark - helper
-(void)setIsCodeTfOK:(BOOL)isCodeTfOK
{
    _isCodeTfOK = isCodeTfOK;
    
    __weak InviteCodeViewController* wself = self;
    if(isCodeTfOK) {
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
