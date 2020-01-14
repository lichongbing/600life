//
//  UserCenterVc.m
//  600生活
//
//  Created by iOS on 2019/11/1.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "ViewController4.h"
#import "LLBaseView.h"
#import "CenterSettingViewController.h"  //设置
#import "AboutUsViewController.h"    //关于我们
#import "FootMarkListViewController.h"  //足迹  👣
#import "IncomeViewController.h"  //收益
#import "MyCollectionsViewController.h" //收藏
#import "MyOrdersMainViewController.h"    //我的订单
#import "FAQViewController.h" //常见问题

#import "InviteNewUserViewController.h"  //邀请好友
#import "FansListViewController.h"  //粉丝

//#import "TeachAVPlayerViewController.h" //新手教程
#import "TeachViewController.h"//新手教程"
#import "LLWindowTipView.h"  //专属客服
#import "CheckOrderViewController.h"  //订单查询
#import "WithDrawViewController.h"  //提现
#import "FeedBackViewController.h"   //意见反馈
#import "IncomeRankViewController.h"  //收益排行
#import "InviteCodeViewController.h" //填写邀请码
#import "LoginAndRigistMainVc.h"  //登录
#import "PYSearchViewController.h"

@interface ViewController4 ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet LLBaseView *buttomLine;


@property (weak, nonatomic) IBOutlet UIImageView *headIcon;  //头像
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headIconTopCons;  //头像距离上安全线距离

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;  //名字
@property (weak, nonatomic) IBOutlet UIImageView *levelIcon;  //等级
@property (weak, nonatomic) IBOutlet UILabel *inviteLab;  //邀请码
@property (weak, nonatomic) IBOutlet UIButton *copyedBtn;

@property (weak, nonatomic) IBOutlet UILabel *thisMonthMoneyLab;  //这个月预估收入
@property (weak, nonatomic) IBOutlet UILabel *todayMoneyLab;  //今日收入

@property (weak, nonatomic) IBOutlet UILabel *lastMonthMoneyLab; //上个月收入
@property (weak, nonatomic) IBOutlet UILabel *lastMonthEscMoneyLab; //上个月预估收入
@property (weak, nonatomic) IBOutlet UILabel *remainMoneyLab; //余额


@property (weak, nonatomic) IBOutlet UIButton *incomeRankBtn; //收益排行按钮


@end

@implementation ViewController4

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.fd_prefersNavigationBarHidden = YES;
    [self setupUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if([LLUserManager shareManager].currentUser == nil){
        __weak ViewController4* wself = self;
        [Utility ShowAlert:@"尚未登录" message:@"\n是否登录" buttonName:@[@"好的,去登录",@"不用了,谢谢"] sureAction:^{
            LoginAndRigistMainVc* vc = [LoginAndRigistMainVc new];
            vc.hidesBottomBarWhenPushed = YES;
            [wself.navigationController pushViewController:vc animated:YES];
        } cancleAction:nil];
        return;
    }
    [self requestGetUserInfo];
    
    [Utility shakeToShow:self.incomeRankBtn];
}


-(void)setupUI
{
    
    if(kIsiPhoneX_Series){
        _headIconTopCons.constant = 48;
    }else{
        _headIconTopCons.constant = 38;
    }
    [_contentView setNeedsLayout];
    [_contentView layoutIfNeeded];
    
    _contentView.width = kScreenWidth;
    self.tableview.showsVerticalScrollIndicator = NO;
    self.tableview.tableHeaderView = _contentView;
    self.tableview.top = -kStatusBarHeight -1;
    
    self.copyedBtn.backgroundColor = [[UIColor colorWithHexString:@"9A9A9A"] colorWithAlphaComponent:0.3];
    
    
    __weak ViewController4* wself = self;
    _buttomLine.viewDidLayoutNewFrameCallBack = ^(CGRect newFrame) {
        wself.contentView.height = newFrame.origin.y + newFrame.size.height;
        wself.tableview.tableHeaderView = wself.contentView;
    };
    
     [self addMJRefresh];
}

#pragma mark - 网络请求
//获取用户数据
-(void)requestGetUserInfo
{
    __weak ViewController4* wself = self;
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
    
    __weak ViewController4* wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //头像
        NSString* avtor = kFullUrl([LLUserManager shareManager].currentUser.avatar);
        [wself.headIcon sd_setImageWithURL:[NSURL URLWithString:avtor] placeholderImage:kPlaceHolderUser];
        //名字
        wself.nameLab.text = [LLUserManager shareManager].currentUser.user_nickname;
        //等级
        int level = [LLUserManager shareManager].currentUser.level.intValue;
        if(level == 3){
            wself.levelIcon.image = [UIImage imageNamed:@"等级青铜"];
        }else if(level == 2){
            wself.levelIcon.image = [UIImage imageNamed:@"等级白银"];
        }else if(level == 1){
            wself.levelIcon.image = [UIImage imageNamed:@"等级黄金"];
        }
        
        //邀请码
        if([LLUserManager shareManager].currentUser.invite_code.length > 0){
            wself.inviteLab.text = [NSString stringWithFormat:@"邀请码:%@",[LLUserManager shareManager].currentUser.invite_code];
        }else{
            wself.inviteLab.text = @"未填写邀请码";
        }
        
        //这个月预估收入
        wself.thisMonthMoneyLab.text = [NSString stringWithFormat:@"￥%@",[LLUserManager shareManager].currentUser.month_forecast];
        //今日收入
        wself.todayMoneyLab.text = [NSString stringWithFormat:@"￥%@",[LLUserManager shareManager].currentUser.today_earnings];
        
        //上个月收入
        wself.lastMonthMoneyLab.text = [NSString stringWithFormat:@"￥%@",[LLUserManager shareManager].currentUser.last_month_settlement];
        //上个月预估收入
        wself.lastMonthEscMoneyLab.text = [NSString stringWithFormat:@"￥%@",[LLUserManager shareManager].currentUser.last_month_forecast];
        //余额 balance
        wself.remainMoneyLab.text = [NSString stringWithFormat:@"可用余额￥%@",[LLUserManager shareManager].currentUser.balance];
    });
}

//获取专属客服二维码和微信号
-(void)requestClientQRCode
{
    
    [self GetWithUrlStr:kFullUrl(kServiceQrcode) param:nil showHud:YES resCache:^(id  _Nullable cacheData) {
        if(kSuccessCache){
            [self handleClientQRCode:cacheData[@"data"]];
        }
    } success:^(id  _Nullable res) {
        if(kSuccessRes){
            [self handleClientQRCode:res[@"data"]];
        }
    } falsed:^(NSError * _Nullable error) {
       
    }];
}

#pragma mark - 此处有回调
-(void)handleClientQRCode:(NSDictionary*)data
{
    __weak ViewController4* wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        LLWindowTipView* view = [[LLWindowTipView alloc]initWithType:WindowTipViewTypeCustomerService];
        [view show];
        view.customerServiceData = data;
        view.customerServiceLeftBtnAction = ^(NSString * wxId) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = data[@"wx"];
            [[NSUserDefaults standardUserDefaults]setValue:data[@"wx"] forKey:kAppInnerCopyStr];
            [[LLHudHelper sharedInstance]tipMessage:@"复制成功"];
        };
        
        __strong ViewController4* sself = wself;
        view.customerServiceRightBtnAction = ^(UIImage * image) {
            UIImageWriteToSavedPhotosAlbum(image, sself, @selector(image: didFinishSavingWithError: contextInfo:), (__bridge void*)sself);
        };
    });
}


#pragma mark - control action

//复制按钮
- (IBAction)copyInviteCodeAction:(id)sender {
    if([LLUserManager shareManager].currentUser.invite_code.length > 0){
        UIPasteboard *board = [UIPasteboard generalPasteboard];
        board.string = [LLUserManager shareManager].currentUser.invite_code;
        [[NSUserDefaults standardUserDefaults]setValue:[LLUserManager shareManager].currentUser.invite_code forKey:kAppInnerCopyStr];
        [[LLHudHelper sharedInstance]tipMessage:@"复制成功"];
    }
}

//设置按钮
- (IBAction)settingBtnAction:(id)sender {
    
    if([LLUserManager shareManager].currentUser == nil){
        __weak ViewController4* wself = self;
        [Utility ShowAlert:@"尚未登录" message:@"\n是否登录" buttonName:@[@"好的,去登录",@"不用了,谢谢"] sureAction:^{
            LoginAndRigistMainVc* vc = [LoginAndRigistMainVc new];
            vc.hidesBottomBarWhenPushed = YES;
            [wself.navigationController pushViewController:vc animated:YES];
        } cancleAction:nil];
        return;
    }
    
    CenterSettingViewController* vc = [CenterSettingViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//提现
- (IBAction)withDrawBtnAction:(id)sender {
    
    if([LLUserManager shareManager].currentUser == nil){
        __weak ViewController4* wself = self;
        [Utility ShowAlert:@"尚未登录" message:@"\n是否登录" buttonName:@[@"好的,去登录",@"不用了,谢谢"] sureAction:^{
            LoginAndRigistMainVc* vc = [LoginAndRigistMainVc new];
            vc.hidesBottomBarWhenPushed = YES;
            [wself.navigationController pushViewController:vc animated:YES];
        } cancleAction:nil];
        return;
    }
    
    WithDrawViewController* vc= [WithDrawViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//go
- (IBAction)goBtnAction:(id)sender {
    
    if([LLUserManager shareManager].currentUser == nil){
        __weak ViewController4* wself = self;
        [Utility ShowAlert:@"尚未登录" message:@"\n是否登录" buttonName:@[@"好的,去登录",@"不用了,谢谢"] sureAction:^{
            LoginAndRigistMainVc* vc = [LoginAndRigistMainVc new];
            vc.hidesBottomBarWhenPushed = YES;
            [wself.navigationController pushViewController:vc animated:YES];
        } cancleAction:nil];
        return;
    }
    
    InviteNewUserViewController* vc = [InviteNewUserViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


//商品相关
- (IBAction)busnessBtnAction:(UIButton*)btn
{
    
    if([LLUserManager shareManager].currentUser == nil){
        __weak ViewController4* wself = self;
        [Utility ShowAlert:@"尚未登录" message:@"\n是否登录" buttonName:@[@"好的,去登录",@"不用了,谢谢"] sureAction:^{
            LoginAndRigistMainVc* vc = [LoginAndRigistMainVc new];
            vc.hidesBottomBarWhenPushed = YES;
            [wself.navigationController pushViewController:vc animated:YES];
        } cancleAction:nil];
        return;
    }
    
     NSInteger tag = btn.tag;
    if(tag == 10){//收益
        IncomeViewController* vc = [IncomeViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (tag == 11){ //我的订单
        MyOrdersMainViewController* vc = [MyOrdersMainViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (tag == 12) { //我的粉丝
        FansListViewController* vc = [FansListViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (tag == 13) {  //邀请
        
       //有邀请码
        InviteNewUserViewController* vc = [InviteNewUserViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//我的工具
- (IBAction)myToolsBtnAction:(UIButton*)btn
{
    if([LLUserManager shareManager].currentUser == nil){
        __weak ViewController4* wself = self;
        [Utility ShowAlert:@"尚未登录" message:@"\n是否登录" buttonName:@[@"好的,去登录",@"不用了,谢谢"] sureAction:^{
            LoginAndRigistMainVc* vc = [LoginAndRigistMainVc new];
            vc.hidesBottomBarWhenPushed = YES;
            [wself.navigationController pushViewController:vc animated:YES];
        } cancleAction:nil];
        return;
    }
    
    NSInteger tag = btn.tag;
    if(tag == 17){//关于我们
        AboutUsViewController* vc = [AboutUsViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if(tag == 16){//常见问题
        FAQViewController* vc = [FAQViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if(tag == 15){//足迹
        FootMarkListViewController* vc = [FootMarkListViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if(tag == 14){//专属客服
        [self requestClientQRCode];
    }
    
    if(tag == 13){ //收益排行
        IncomeRankViewController* vc = [[IncomeRankViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
//        [[LLHudHelper sharedInstance]tipMessage:@"请联系专属客服"];
//        return;
//        FeedBackViewController* vc = [FeedBackViewController new];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if(tag == 12){//600收藏
           MyCollectionsViewController* vc = [MyCollectionsViewController new];
           vc.hidesBottomBarWhenPushed = YES;
           [self.navigationController pushViewController:vc animated:YES];
    }
    
    if(tag == 11){ //订单查询
        CheckOrderViewController* vc = [CheckOrderViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if(tag == 10){//新手教程
        TeachViewController* vc = [TeachViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
//        NSString *mp4Path = [[NSBundle mainBundle]pathForResource:@"qidong.mp4"ofType:nil];
//        TeachAVPlayerViewController* vc = [[TeachAVPlayerViewController alloc]initWithFilePath:mp4Path];
//        vc.modalPresentationStyle = 0;
//        [self presentViewController:vc animated:YES completion:nil];
//        __weak TeachAVPlayerViewController* wvc = vc;
//        vc.didClickedEnterMainCallBack = ^{
//            [wvc dismissViewControllerAnimated:YES completion:nil];
//        };
    }
}


#pragma mark - helper

-(void)addMJRefresh
{
    __weak ViewController4* wself = self;
   
    self.isMJHeaderRefresh = YES;
    self.tableview.mj_header = [LLRefreshGifHeader headerWithRefreshingBlock:^{
        [wself requestGetUserInfo];
        [wself impactLight];
    }];
}



@end
