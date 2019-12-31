//
//  CenterSettingViewController.m
//  600生活
//
//  Created by iOS on 2019/11/12.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "CenterSettingViewController.h"
#import "SPButton.h"
#import "LCActionSheet.h"
#import "CHangeNameViewController.h"    //修改昵称
#import "ChangePhone1ViewController.h"  //绑定手机号
#import "BindAlipayViewController.h"  //支付宝绑定
#import "LoginAndRigistMainVc.h"  //登录
//#import "ClearCacheTool.h"  //清理缓存
#import <SDWebImage.h> //清理sd图片缓存

#import <AlibcTradeSDK/AlibcTradeSDK.h> //授权

#import "WebViewViewController.h"
#import "LLWindowTipView.h"  //我的上级
#import "SuperiorUserInfo.h"  //上级用户信息
#import "InviteCodeViewController.h"

@interface CenterSettingViewController ()<LCActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *icon; //头像
@property (weak, nonatomic) IBOutlet SPButton *nickNameLab; //展示昵称
@property (weak, nonatomic) IBOutlet SPButton *registTimeLab; //创建时间
@property (weak, nonatomic) IBOutlet SPButton *taobaoBtn;  //是否淘宝授权
@property (weak, nonatomic) IBOutlet SPButton *aliBtn;   //是否支付宝绑定
@property (weak, nonatomic) IBOutlet SPButton *telLab; //电话号码
@property (weak, nonatomic) IBOutlet SPButton *cacheBtn;  //展示缓存按钮



@property(nonatomic,assign) NSInteger cacheFileCounter;//缓存文件个数
@property(nonatomic,assign) NSString* cacheFileSizeStr;//缓存文件大小

@property(nonatomic,strong)SuperiorUserInfo* superiorUserInfo;

@end

@implementation CenterSettingViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"设置";
    
    __weak CenterSettingViewController* wself = self;
    [[SDImageCache sharedImageCache] calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
        float cacheFloat = totalSize/1000/1000;
        NSString* cacheStr = [NSString stringWithFormat:@"%.2f",cacheFloat];
        NSString* cecheMBStr = [NSString stringWithFormat:@"%@MB",cacheStr];
        [wself.cacheBtn setTitle:cecheMBStr forState:UIControlStateNormal];
        wself.cacheFileCounter = fileCount;
        wself.cacheFileSizeStr = cacheStr;
    }];
    
    
    //检查是app否变活跃
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appDidBecomeActiveNofificationAction:) name:kAppDidBecomeActiveNofification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.nickNameLab setTitle:[LLUserManager shareManager].currentUser.user_nickname forState:UIControlStateNormal];
    
    //获取用户信息
    [self requestGetUserInfo];
}

#pragma mark - 网络请求
//获取用户数据
-(void)requestGetUserInfo
{
    __weak CenterSettingViewController* wself = self;
    [self GetWithUrlStr:kFullUrl(kGetUserInfo) param:nil showHud:NO resCache:^(id  _Nullable cacheData) {
        if(kSuccessCache){
            [wself handleGetUserInfo:cacheData[@"data"]];
        }
    } success:^(id  _Nullable res) {
        if(kSuccessRes){
            [wself handleGetUserInfo:res[@"data"]];
        }
        
    } falsed:^(NSError * _Nullable error) {
       
    }];
}

-(void)handleGetUserInfo:(NSDictionary*)data
{
    NSError* err = nil;
    LLUser* newUser = [[LLUser alloc]initWithDictionary:data error:&err];
  
    //用内存中的数据 给newUser准备接口无法返回的数据
       NSNumber* idSNumber = [[LLUserManager shareManager].currentUser.id copy];
       NSNumber* expire_time = [[LLUserManager shareManager].currentUser.expire_time copy];
       NSString* token = [[LLUserManager shareManager].currentUser.token copy];
       BOOL isLogin = [LLUserManager shareManager].currentUser.isLogin;
    
    //newUser赋值
       newUser.id = idSNumber;
       newUser.expire_time = expire_time;
       newUser.token = token;
       newUser.isLogin = isLogin;
    
    //更新dbuser
       [[LLUserManager shareManager]insertOrUpdateCurrentUser:newUser];
    
    //切换内存中的user
    [[LLUserManager shareManager]switchUserWithId:[NSString stringWithFormat:@"%@",newUser.id]];
    
    __weak CenterSettingViewController* wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        //头像
        NSString* iconStr = [LLUserManager shareManager].currentUser.avatar;
        NSString* iconUrlStr = kFullUrl(iconStr);
        [wself.icon sd_setImageWithURL:[NSURL URLWithString:iconUrlStr] placeholderImage:kPlaceHolderUser];
        
        //昵称
        [wself.nickNameLab setTitle:[LLUserManager shareManager].currentUser.user_nickname forState:UIControlStateNormal];
        
        //注册时间
        NSString* timeStr = [Utility getDateStrWithTimesStampNumber:[LLUserManager shareManager].currentUser.create_time Format:@"YYYY-MM-dd"];
        [wself.registTimeLab setTitle:timeStr forState:UIControlStateNormal];
        
        //是否淘宝授权
        BOOL isTbAuth = [LLUserManager shareManager].currentUser.relation_id.length > 0;
        if(isTbAuth){
            [wself.taobaoBtn setTitle:@"已授权" forState:UIControlStateNormal];
        }else{
            [wself.taobaoBtn setTitle:@"未授权" forState:UIControlStateNormal];
        }
        
        //是否绑已定支付宝
        
        BOOL isAliAuth = [LLUserManager shareManager].currentUser.is_bind_zfb.intValue == 1;
        if(isAliAuth){
            [wself.aliBtn setTitle:@"已绑定" forState:UIControlStateNormal];
        }else{
            [wself.aliBtn setTitle:@"未绑定" forState:UIControlStateNormal];
        }
        
        //电话号码
        NSString* telStr = [LLUserManager shareManager].currentUser.mobile;
        if(!telStr || telStr.length == 0){
            telStr = @"暂无电话号码信息";
        }
        [wself.telLab setTitle:telStr forState:UIControlStateNormal];
    });
}


//api/user/upload
//修改用户头像
-(void)requestChangeUserIcon:(UIImage*)image
{
    //上传图片之前压缩图片
    NSData *newImgData = UIImageJPEGRepresentation(image, 0.3);
    UIImage *newImg = [UIImage imageWithData:newImgData];
    
    //开始请求
    [self uploadOneGrounpImgWithURL:kFullUrl(kChangeUserIcon) parameters:nil name:@"file" images:@[newImg] progress:^(NSProgress *progress) {
        
    } success:^(id res) {
        if(kSuccessRes){
             [[LLHudHelper sharedInstance]tipMessage:@"设置成功"];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//1002授权失败 1-成功
//淘宝授权
-(void)requestTaobaoAuth
{
    __weak CenterSettingViewController* wself = self;
    [self GetWithUrlStr:kFullUrl(kTbAuth) param:nil showHud:YES resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes){
            [wself handleTaobaoAuth:res[@"data"]];
        }
    } falsed:^(NSError * _Nullable error) {
        
    }];
}

-(void)handleTaobaoAuth:(NSString*)urlStr
{
    __weak CenterSettingViewController* wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        WebViewViewController* vc = [[WebViewViewController alloc]initWithUrl:urlStr title:@"淘宝授权"];
        vc.isNeedJS = YES;
        vc.hidesBottomBarWhenPushed = YES;
        [wself.navigationController pushViewController:vc animated:YES];
    });
}

//解除淘宝授权
-(void)requestTaobaoUnAuth
{
    __weak CenterSettingViewController* wself = self;
    [self GetWithUrlStr:kFullUrl(kTbUnAuth) param:nil showHud:YES resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes){
            [LLUserManager shareManager].currentUser.relation_id = nil;
            [[LLHudHelper sharedInstance]tipMessage:@"解除淘宝授权成功"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [wself.taobaoBtn setTitle:@"未授权" forState:UIControlStateNormal];
            });
        }else{
            [[LLHudHelper sharedInstance]tipMessage:@"解除授权失败"];
        }
    } falsed:^(NSError * _Nullable error) {
        
    }];
}

//解除支付宝绑定(支付宝绑定的接口在绑定界面调用)
-(void)requestAliPayUnAuth
{
    __weak CenterSettingViewController* wself = self;
    [[LLNetWorking sharedWorking]Delete:kFullUrl(kUnBindZfb) param:nil success:^(id  _Nonnull res) {
        if(kSuccessRes){
            [wself handleAliPayUnAuth];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

-(void)handleAliPayUnAuth
{
    __weak CenterSettingViewController* wself = self;
    [[LLHudHelper sharedInstance]tipMessage:@"解除支付宝绑定成功"];
    [LLUserManager shareManager].currentUser.is_bind_zfb = [NSNumber numberWithInt:0];
    dispatch_async(dispatch_get_main_queue(), ^{
        [wself.aliBtn setTitle:@"未绑定" forState:UIControlStateNormal];
    });
}

-(void)requestMyParentCodeInfo
{
    __weak CenterSettingViewController* wself = self;
    [self GetWithUrlStr:kFullUrl(kParentUsrCodeInfo) param:nil showHud:YES resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes){ //kSuccessRes
            dispatch_async(dispatch_get_main_queue(), ^{
                [wself handleParentCodeInfo:res[@"data"]];
            });
        } else if ([res[@"code"] intValue] == 2) {//无上级
            [self handleNoInvateCode];
        }
    } falsed:^(NSError * _Nullable error) {
        
    }];
}

//有上级
-(void)handleParentCodeInfo:(NSDictionary*)data
{
    self.superiorUserInfo = [[SuperiorUserInfo alloc]initWithDictionary:data error:nil];
    LLWindowTipView* view = [[LLWindowTipView alloc]initWithType:WindowTipViewTypeSuperiorUser];
    view.superiorUserInfo = self.superiorUserInfo;
    [view show];
}

//无上级
-(void)handleNoInvateCode
{
    __weak CenterSettingViewController* wself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       [Utility ShowAlert:@"未填写邀请码" message:@"\n未填写上级邀请码,是否填写" buttonName:@[@"好的,去填写",@"不用了,谢谢"] sureAction:^{
           InviteCodeViewController* vc = [[InviteCodeViewController alloc]init];
           vc.hidesBottomBarWhenPushed = YES;
           [wself.navigationController pushViewController:vc animated:YES];
       } cancleAction:nil];
    });
}

#pragma mark - control action

- (IBAction)headBtnAction:(id)sender {
    [self.view endEditing:YES];
    NSArray* titleArr = @[@"拍照",@"从相册中选择"];
    LCActionSheet* actionSheet = [LCActionSheet sheetWithTitle:@"" delegate:(id)self cancelButtonTitle:@"取消" otherButtonTitleArray:titleArr];
    actionSheet.buttonColor = [UIColor colorWithHexString:@"#1776D4"];
    actionSheet.destructiveButtonColor = [UIColor colorWithHexString:@"#1776D4"];
    [actionSheet show];
}

//修改昵称
- (IBAction)nickBtnAction:(id)sender {
    CHangeNameViewController* vc = [[CHangeNameViewController alloc]initWithName:@"昵称"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//修改电话
- (IBAction)changPhoneBtnAction:(id)sender {
    ChangePhone1ViewController* vc = [[ChangePhone1ViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//淘宝授权
- (IBAction)taoBaoBtnAction:(id)sender {
    
    if([LLUserManager shareManager].currentUser.relation_id.length > 0){
        //已授权
        __weak CenterSettingViewController* wself = self;
        [LLHudHelper alertTitle:@"解除淘宝授权" message:@"\n已处于授权状态，是否解除淘宝授权？" cancel:@"不必了" sure:@"是的,解除授权" cancelAction:nil sureAction:^{
            [wself requestTaobaoUnAuth];
        }];
    }else{
        //未授权
         [self requestTaobaoAuth];
    }
}


- (IBAction)alipayBtnAction:(id)sender {
    
    if( [[LLUserManager shareManager].currentUser.is_bind_zfb intValue] == 1){
        //已绑定
        __weak CenterSettingViewController* wself = self;
        [LLHudHelper alertTitle:@"解除支付宝绑定" message:@"\n已处于绑定状态，是否解除绑定？" cancel:@"不必了" sure:@"是的,解除绑定" cancelAction:nil sureAction:^{
            [wself requestAliPayUnAuth];
        }];
    }else{
        //未绑定
          BindAlipayViewController* vc = [[BindAlipayViewController alloc]init];
          vc.hidesBottomBarWhenPushed = YES;
          [self.navigationController pushViewController:vc animated:YES];
    }
}

//清理缓存
- (IBAction)clearBtnAction:(id)sender {
    __weak CenterSettingViewController* wself = self;
    [self loadingMessage:@"正在清理缓存"];
    float seconds = (self.cacheFileSizeStr.floatValue/100);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[SDImageCache sharedImageCache]clearDiskOnCompletion:^{
            [wself stopLoading];
            NSString* str = [NSString stringWithFormat:@"共清理了%lu个文件,共%@MB缓存",wself.cacheFileCounter,wself.cacheFileSizeStr];
                           [[LLHudHelper sharedInstance]tipMessage:str delay:2.0];
            wself.cacheFileCounter = 0;
            wself.cacheFileSizeStr = @"0";
            [wself.cacheBtn setTitle:@"0MB" forState:UIControlStateNormal];
        }];
        
    });
}

//我的上级

- (IBAction)supperBtnAction:(id)sender {
    if(self.superiorUserInfo == nil){
        [self requestMyParentCodeInfo];
    } else {
        LLWindowTipView* view = [[LLWindowTipView alloc]initWithType:WindowTipViewTypeSuperiorUser];
        view.superiorUserInfo = self.superiorUserInfo;
        [view show];
    }
}


- (IBAction)logoutBtnAction:(id)sender {
    
    LLUser* currentUser = [LLUserManager shareManager].currentUser;
    currentUser.isLogin = 0;
    [[LLUserManager shareManager]insertOrUpdateCurrentUser:currentUser];
    
    LoginAndRigistMainVc* vc = [[LoginAndRigistMainVc alloc]initWithNoBackItem];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - lcactionsheet delegate
- (void)actionSheet:(LCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1){
        //拍照
        [self takePicture];
    }else if (buttonIndex == 2){
        //相册
        [self takePhoto];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.icon.image = info[UIImagePickerControllerOriginalImage];
    [self requestChangeUserIcon:info[UIImagePickerControllerOriginalImage]];
}

#pragma mark - 通知
//app 变活跃  根据此时逻辑 有已绑定和解除绑定两种状态 所以网络请求一次
-(void)appDidBecomeActiveNofificationAction:(NSNotification*)notification
{
    BOOL islogin = [LLUserManager shareManager].currentUser.isLogin;
    if (islogin) {
        [self requestGetUserInfo];
    }
}
@end
