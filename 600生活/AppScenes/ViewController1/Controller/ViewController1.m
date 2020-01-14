//
//  ViewController1.m
//  600生活
//
//  Created by iOS on 2019/11/4.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "ViewController1.h"

#import "LoginAndRigistMainVc.h"
#import "SPPageMenu.h"

#import "MsgViewController.h"  //消息
#import "LLWindowTipView.h"    //专属客服  发现新版本
#import <Photos/Photos.h>  //保存图片到相册
#import "HomeCarefullySelectViewController.h"   //精选
#import "GuessLikeViewController.h"       //猜你喜欢
#import "CategoryTypeViewController.h"     //分类


#import "CategoryMainController.h"    //全部分类
#import "SearchHistoryViewController.h"  //搜索历史
#import "SearchResultListController.h"  //用户复制文字到粘贴板跳转到搜索结果页
#import "UIImage+ext.h"

#import "SearchedGoodModel.h"  //搜索出的商品模型
#import "GoodDetailViewController.h"


@interface ViewController1 ()<SPPageMenuDelegate>

//菜单数据
@property (nonatomic,strong) NSArray<HomePageMenuModel*>* homePageMenuList;

@property(nonatomic,strong)NSArray* childViewControllers;  //子视图控制器
@end

@interface ViewController1 ()
@property (weak, nonatomic) IBOutlet UILabel *msgLab;
@property(nonatomic,strong)NSDictionary* unreadMsgData;//未读消息数据

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navViewTopConstraint;

@property (weak, nonatomic) IBOutlet UIView *spPageMenuBgView;
@property (strong, nonatomic)  SPPageMenu *spPageMenu;

@property(nonatomic,strong)UIView* noNetTipBgView;   //无网络提示背景view

@end

@implementation ViewController1

-(id)init{
    if(self = [super init]){
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
 
    self.fd_prefersNavigationBarHidden = YES;
    
    _navViewHeightConstraint.constant = kNavigationBarHeight;
    _navViewTopConstraint.constant = -kStatusBarHeight;
    
    //lhf - 暂时隐藏
    [self requestCheckVersion];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack]; //黑色状态栏
    
    if(self.homePageMenuList == nil){
         [self requestHomePageMenuDatas];
    }
    
    //如果没有用户数据 提示用户登录注册
    if([LLUserManager shareManager].currentUser == nil){
        LLWindowTipView* view = [[LLWindowTipView alloc]initWithType:WindowTipViewTypeGoSigin];
        __weak ViewController1* wself = self;
        view.goSiginBtnAction = ^{
            LoginAndRigistMainVc* vc = [LoginAndRigistMainVc new];
            vc.hidesBottomBarWhenPushed = YES;
            [wself.navigationController pushViewController:vc animated:YES];
        };
        [view show];
    }
    
    //如果有用户数据 且已登录 获取消息
    if([LLUserManager shareManager].currentUser.isLogin){
        [self requestAllMessages];
    }
}


//设置状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;  //白色文字  黑色背景
}


#pragma mark - 网络请求

//获取分类菜单数据
-(void)requestHomePageMenuDatas
{
    [self GetWithUrlStr:kFullUrl(kHomePageMenu) param:nil showHud:YES resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes){
            [self dismissNoNetView];//清空无网络
            [self handleHomePageMenuDatas: res[@"data"]];
        }else{
            [self showNoNetView];//展示无网络
        }
    } falsed:^(NSError * _Nullable error) {
        [self showNoNetView];//展示无网络
    }];
}

//请求分类菜单数据
-(void)handleHomePageMenuDatas:(NSArray*)dataList
{
    NSMutableArray* mutArr = [NSMutableArray new];
    for(int i = 0; i < dataList.count; i++){
        NSError* err = nil;
        HomePageMenuModel* homePageMenuModel = [[HomePageMenuModel alloc]initWithDictionary:dataList[i] error:&err];
        //创建homePageMenuModel的child数组
        NSDictionary* data = dataList[i];
        NSArray* child = data[@"child"];
        NSMutableArray* mutChild = [NSMutableArray new];
        for(int j = 0; j < child.count; j++){
            err = nil;
            HomePageMenuCategoryChild* homePageMenuCategoryChild = [[HomePageMenuCategoryChild alloc]initWithDictionary:child[j] error:&err];
            if(homePageMenuCategoryChild){
                [mutChild addObject:homePageMenuCategoryChild];
            }
        }

        if(mutChild.count > 0){
            homePageMenuModel.child = mutChild;
        }


        if( homePageMenuModel ){
            [mutArr addObject:homePageMenuModel];
        } else {
            NSLog(@"转换菜单模型失败");
        }
    }

    if(mutArr.count > 0){
        self.homePageMenuList = mutArr;
        __weak ViewController1* wself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            if(wself.homePageMenuList.count > 0){
                 [wself setupPageMenusAndChildVcs]; //创建分类菜单以及分类子控制器
            }
        });
    }else{
        [[LLHudHelper sharedInstance]tipMessage:@"获取数据失败"];
        return;
    }
}


//获取未读消息
-(void)requestAllMessages
{
    __weak ViewController1* wself = self;
    [self GetWithUrlStr:kFullUrl(kGetUserAllUnreadMessages) param:nil showHud:YES resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes){
            [self handleAllMessages: res[@"data"]];
        }
    } falsed:^(NSError * _Nullable error) {
     
    }];
}

/**
 {
     "earnings_message_count" = 2;
     "earnings_message_title" = "\U60a8\U7684\U63d0\U73b0\U5df2\U5230\U5e10!";
     "system_message_count" = 4;
     "system_message_title" = "\U7cfb\U7edf\U901a\U77e504";
 }
 */
-(void)handleAllMessages:(NSDictionary*)data
{
    self.unreadMsgData = data;
    
    int system_message_count = [data[@"system_message_count"] intValue];
    int earnings_message_count = [data[@"earnings_message_count"] intValue];
    int allCount = system_message_count + earnings_message_count;
    
    __weak ViewController1* wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if(allCount > 0){
            wself.msgLab.hidden = NO;
            wself.msgLab.text = [NSString stringWithFormat:@"%d",allCount];
        }else{
            wself.msgLab.hidden = YES;
        }
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
    __weak ViewController1* wself = self;
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
        
        __strong ViewController1* sself = wself;
        view.customerServiceRightBtnAction = ^(UIImage * image) {
            UIImageWriteToSavedPhotosAlbum(image, sself, @selector(image: didFinishSavingWithError: contextInfo:), (__bridge void*)sself);
        };
    });
}

-(void)requestCheckVersion
{
    NSDictionary* param = @{
        @"current_version" : @"1.0"
    };

    [[LLNetWorking sharedWorking]helper];
    __weak ViewController1* wself = self;
    [self GetWithUrlStr:kFullUrl(kCHeckVersion) param:param showHud:NO resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes){
            [wself handleCheckVersion:res[@"data"]];
        }
    } falsed:^(NSError * _Nullable error) {
    }];
}

-(void)handleCheckVersion:(NSDictionary*)data
{
    NSString* maxVersion = data[@"version"];
    NSString* currentVersion = kAppBuildVersion;
    [self checkWithMaxVersion:maxVersion currentVersion:currentVersion];
}

-(void)checkWithMaxVersion:(NSString*)maxVersion currentVersion:(NSString*)currentVersion
{
    NSArray* maxVersionArr = [maxVersion componentsSeparatedByString:@"."];
    NSArray* currentVersionArr = [currentVersion componentsSeparatedByString:@"."];
    
    NSString* item0Max = maxVersionArr.firstObject;
    NSString* item0 = currentVersionArr.firstObject;
    
    if(item0Max.intValue > item0.intValue){
        //需要更新
        [self updateVersion];
    }else{
        NSString* item1Max = maxVersionArr[1];
        NSString* item1 = currentVersionArr[1];
        if(item1Max.intValue > item1.intValue){
            //需要更新
            [self updateVersion];
        }else{
            NSString* item2Max = maxVersionArr[2];
            NSString* item2 = currentVersionArr[2];
            if(item2Max.intValue > item2.intValue){
                //需要更新
                [self updateVersion];
            }else{
                NSString* item3Max = maxVersionArr[3];
                NSString* item3 = currentVersionArr[3];
                if(item3Max.intValue > item3.intValue){
                    //需要更新
                    [self updateVersion];
                } else {
                    NSLog(@"全部通过");
                }
            }
        }
    }
}

-(void)updateVersion
{
    dispatch_async(dispatch_get_main_queue(), ^{
        LLWindowTipView* view = [[LLWindowTipView alloc]initWithType:WindowTipViewTypeNewVersion];
        __weak LLWindowTipView* wview = view;
        view.findNewVersionBtnAction = ^{
            NSURL* url = [NSURL URLWithString:kAppStoreLink];
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            [wview dismiss];
        };
        [view show];
    });
}



#pragma mark - UI

//创建分类菜单以及分类子控制器
-(void)setupPageMenusAndChildVcs
{
    //创建临时变量 homePageMenuNames childViewControllers
    NSMutableArray* homePageMenuNames = [NSMutableArray new];
    
    NSMutableArray* childViewControllers = [NSMutableArray new];
    
    for(int i = 0; i < self.homePageMenuList.count; i++){
        HomePageMenuModel* homePageMenuModel = [self.homePageMenuList objectAtIndex:i];
        [homePageMenuNames addObject:homePageMenuModel.name];
        if(homePageMenuModel.id.integerValue == -2){//精选
            HomeCarefullySelectViewController* vc = [[HomeCarefullySelectViewController alloc]init];
            [childViewControllers addObject:vc];
        } else if (homePageMenuModel.id.integerValue == -1){//猜你喜欢
            GuessLikeViewController* vc = [GuessLikeViewController new];
            [childViewControllers addObject:vc];
        } else if(homePageMenuModel.id.integerValue > 0) { //其他分类
            CategoryTypeViewController* vc = [[CategoryTypeViewController alloc]initWithCid:homePageMenuModel.cid categoryName:homePageMenuModel.name childArray:homePageMenuModel.child];
            [childViewControllers addObject:vc];
        }
    }
    
    //创建临时变量pageMenu
          // trackerStyle:跟踪器的样式
    SPPageMenu *pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, 0, kScreenWidth, 40) trackerStyle:SPPageMenuTrackerStyleLine];
          // 传递数组，默认选中第2个
    [pageMenu setItems:homePageMenuNames selectedItemIndex:0];
    pageMenu.trackerFollowingMode = SPPageMenuTrackerFollowingModeAlways;
          // 设置代理
    pageMenu.delegate = self;
    //给pageMenu传递外界的大scrollView，内部监听self.scrollView的滚动，从而实现让跟踪器跟随self.scrollView移动的效果
    pageMenu.bridgeScrollView = self.scrollView;
          
          //开启添加按钮
    pageMenu.showFuntionButton = YES;
          //设置FuntionButton图片
    [pageMenu setFunctionButtonContent:[UIImage imageNamed:@"HomePage分类"] forState:UIControlStateNormal];
    [pageMenu setFunctionButtonContent:@"" forState:UIControlStateNormal];
    [pageMenu setUnSelectedItemTitleColor:[UIColor colorWithHexString:@"666666"]];
    self.spPageMenu = pageMenu;
    self.childViewControllers = childViewControllers;
}


#pragma mark - setter
-(void)setSpPageMenu:(SPPageMenu *)spPageMenu
{
    if(_spPageMenu){
        __weak ViewController1* wself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself.spPageMenu removeFromSuperview];
            wself.spPageMenu = nil;
        });
    }
    
    _spPageMenu = spPageMenu;
    
    __weak ViewController1* wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [wself.spPageMenuBgView addSubview:wself.spPageMenu];
    });
     
}

-(void)setChildViewControllers:(NSMutableArray *)childViewControllers
{

    if(_childViewControllers.count > 0){
        for(int i = 0; i < _childViewControllers.count; i++){
            UIViewController* vc = _childViewControllers[i];
            dispatch_async(dispatch_get_main_queue(), ^{
                [vc.view removeFromSuperview];
                [vc removeFromParentViewController];
            });
        }
    }
    
    _childViewControllers = childViewControllers;
    
    //添加创建子视图控制器
    for(int i = 0; i < childViewControllers.count; i++){
        UIViewController* vc = [childViewControllers objectAtIndex:i];
        __weak ViewController1* wself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself addChildViewController:vc];
            [wself.scrollView addSubview:vc.view];
            vc.view.frame = CGRectMake(i*kScreenWidth, 0, kScreenWidth, wself.scrollView.height);
            wself.scrollView.contentSize = CGSizeMake(childViewControllers.count * kScreenWidth, self.scrollView.height);
            wself.scrollView.pagingEnabled = YES;
        });
    }
}

#pragma mark - control action

//消息
- (IBAction)systemMsgBtnAction:(id)sender {
    
    if([LLUserManager shareManager].currentUser == nil){
        __weak ViewController1* wself = self;
        [Utility ShowAlert:@"尚未登录" message:@"\n是否登录" buttonName:@[@"好的,去登录",@"不用了,谢谢"] sureAction:^{
            LoginAndRigistMainVc* vc = [LoginAndRigistMainVc new];
            vc.hidesBottomBarWhenPushed = YES;
            [wself.navigationController pushViewController:vc animated:YES];
        } cancleAction:nil];
        return;
    }
    
    MsgViewController* vc = [[MsgViewController alloc]initWithUnreadData:self.unreadMsgData];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//客服
- (IBAction)clientBtnAction:(id)sender {
    
    if([LLUserManager shareManager].currentUser == nil){
        __weak ViewController1* wself = self;
        [Utility ShowAlert:@"尚未登录" message:@"\n是否登录" buttonName:@[@"好的,去登录",@"不用了,谢谢"] sureAction:^{
            LoginAndRigistMainVc* vc = [LoginAndRigistMainVc new];
            vc.hidesBottomBarWhenPushed = YES;
            [wself.navigationController pushViewController:vc animated:YES];
        } cancleAction:nil];
        return;
    }
    
    [self requestClientQRCode];
}

//
- (IBAction)searchBtnAction:(id)sender {
    
    if([LLUserManager shareManager].currentUser == nil){
           __weak ViewController1* wself = self;
           [Utility ShowAlert:@"尚未登录" message:@"\n是否登录" buttonName:@[@"好的,去登录",@"不用了,谢谢"] sureAction:^{
               LoginAndRigistMainVc* vc = [LoginAndRigistMainVc new];
               vc.hidesBottomBarWhenPushed = YES;
               [wself.navigationController pushViewController:vc animated:YES];
           } cancleAction:nil];
           return;
       }
    
    SearchHistoryViewController* vc = [SearchHistoryViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}




#pragma mark - SPPageMenu的代理方法

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index {
   
}

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    //切换vc
    if(self.childViewControllers.count > 0) {
        UIViewController* vc = [self.childViewControllers objectAtIndex:toIndex];
        
        //是否是spPageMenu的子vc
        BOOL isspMeneSubVC = [vc isKindOfClass:[SPMenuSubViewController class]];
        
        //是否加载过了 (number为空 则未加载过)
        NSNumber* number = objc_getAssociatedObject(vc, kRunTimeViewController1SubVcShow);
        if(isspMeneSubVC && (number == nil)){
            //1 vc 加载数据
            //2  vc 动态绑定
            [((SPMenuSubViewController*)vc) loadDatasWhenUserDone];
            objc_setAssociatedObject(vc, kRunTimeViewController1SubVcShow, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        } else {
            NSLog(@"do nothing");
        }
    }
    
 //如果该代理方法是由拖拽self.scrollView而触发，说明self.scrollView已经在用户手指的拖拽下而发生偏移，此时不需要再用代码去设置偏移量，否则在跟踪模式为SPPageMenuTrackerFollowingModeHalf的情况下，滑到屏幕一半时会有闪跳现象。闪跳是因为外界设置的scrollView偏移和用户拖拽产生冲突
    if (!self.scrollView.isDragging) { // 判断用户是否在拖拽scrollView
        // 如果fromIndex与toIndex之差大于等于2,说明跨界面移动了,此时不动画.
        if (labs(toIndex - fromIndex) >= 2) {
            [self.scrollView setContentOffset:CGPointMake(kScreenWidth * toIndex, 0) animated:NO];
        } else {
            [self.scrollView setContentOffset:CGPointMake(kScreenWidth * toIndex, 0) animated:YES];
        }
    }
    
    if (self.childViewControllers.count <= toIndex) {return;}
    
    UIViewController *targetViewController = self.childViewControllers[toIndex];
    // 如果已经加载过，就不再加载
    if ([targetViewController isViewLoaded]) return;
    
    targetViewController.view.frame = CGRectMake(kScreenWidth * toIndex, 0, kScreenWidth, self.scrollView.height);
    [_scrollView addSubview:targetViewController.view];

}

- (void)pageMenu:(SPPageMenu *)pageMenu functionButtonClicked:(UIButton *)functionButton {

    CategoryMainController* categoryMainController = [[CategoryMainController alloc]init];
    categoryMainController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:categoryMainController animated:YES];
}

#pragma mark - 无网络刷新

-(UIView*)noNetTipBgView
{
    if(_noNetTipBgView == nil){
        _noNetTipBgView = [[UIView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight - kNavigationBarHeight - kTabbarHeight )];
        _noNetTipBgView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_noNetTipBgView];
        [self.view bringSubviewToFront:_noNetTipBgView];
    }
    return _noNetTipBgView;
}


-(void)showNoNetView
{
    __weak ViewController1* wself = self;
     dispatch_async(dispatch_get_main_queue(), ^{
         LLTipView* oldTipView =  [self.noNetTipBgView viewWithTag:kTipViewTag];
         if (!oldTipView) {  //没有
             LLTipView* newTipView = [[LLTipView alloc] initWithType:LLTipViewTypeNoNet iconName:@"tipview网络异常" msg:@"加载数据异常" superView:self.noNetTipBgView];
             [wself.noNetTipBgView addSubview:newTipView];
             
             __strong ViewController1* sself = wself;
             newTipView.refreshBtnCallback = ^{
                 [sself requestHomePageMenuDatas];
             };
         }
     });
}

-(void)dismissNoNetView
{
    __weak ViewController1* wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView* tipView = [wself.noNetTipBgView viewWithTag:kTipViewTag];
        if(tipView){
            [tipView removeFromSuperview];
            tipView = nil;
        }
        
        [wself.noNetTipBgView removeFromSuperview];
        wself.noNetTipBgView = nil;
    });
}


@end
