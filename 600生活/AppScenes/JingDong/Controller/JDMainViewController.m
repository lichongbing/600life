//
//  JDHomeViewController.m
//  600生活
//
//  Created by iOS on 2019/12/31.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "JDMainViewController.h"
#import "LLBaseView.h"
#import "JDCategoryModel.h"
#import "JDHomeController.h"  //京东精选
#import "JDCategorySubViewController.h"  //京东分类
#import "SPPageMenu.h"
#import "JDJiaDianViewController.h"   //京东家电
#import "UINavigationController+TZPopGesture.h" //tz_addPopGestureToView 系统的侧滑返回的scorllView的滑动并存

@interface JDMainViewController ()<UIScrollViewDelegate,SPPageMenuDelegate>

//整体scrollView
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewTopCons;

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *navView;

@property (weak, nonatomic) IBOutlet UIView *redBgView;
@property (weak, nonatomic) IBOutlet UIView *redView;


@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (weak, nonatomic) IBOutlet UIView *spBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spBgViewTopCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spBgViewHeightCons;
@property (weak, nonatomic) IBOutlet UIScrollView *spScrollView;

@property (weak, nonatomic) IBOutlet LLBaseView *layoutBottomLine;

@property(nonatomic,strong)UIView* noNetTipBgView;   //无网络提示背景view
@property (strong, nonatomic)  SPPageMenu *spPageMenu;
@property(nonatomic,strong)NSArray<JDCategoryModel*>* jdCategorys;  //保存京东分类数据
@property(nonatomic,strong)NSArray* childViewControllers;  //子视图控制器

@end


@interface JDMainViewController()

@property(nonatomic,assign)CGFloat redBgViewHeight; //红色背景高度
@property(nonatomic,assign)CGFloat bannerImageViewWide;   //广告图width
@property(nonatomic,assign)CGFloat bannerImageViewHeight;   //广告图height
@property(nonatomic,assign)CGFloat bannerImageViewTop;   //广告图top
@property(nonatomic,assign)CGFloat bannerImageViewLeft;  //广告图left
@property(nonatomic,assign)CGFloat bannerImageViewCenterY; //广告图centerY
@property(nonatomic,strong)UIScrollView* subVcScrollView; //保存精选中的scrollView

@end

@implementation JDMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
    [self tz_addPopGestureToView:self.scrollView];
    //获取京东分类数据
    [self requestJDMenuDatas];
}

//设置状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;  //白色文字
}

#pragma mark - UI

-(void)setupUI
{
    [self reSetupNavView];
    
    _redView.width = kScreenWidth;
    _redView.height = kScreenWidth * 143.5 / 375;
    [Utility addGradualChangingColorWithView:_redView fromColor:[UIColor colorWithHexString:@"#DB2333"] toColor:[UIColor colorWithHexString:@"#FD6E56"] orientation:@[@0,@0,@0,@1]];
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    _scrollViewTopCons.constant = -kStatusBarHeight;
    _scrollView.delegate = (id)self;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    
    _redView.layer.cornerRadius = 10;
    _redView.layer.maskedCorners = kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner;
    
    self.redBgViewHeight = _redView.height;
    self.bannerImageViewCenterY = _redBgViewHeight*0.5 * 2;
    self.bannerImageViewLeft = 10;
    self.bannerImageViewWide = kScreenWidth - self.bannerImageViewLeft*2;
    self.bannerImageViewHeight = self.bannerImageViewWide * 291 / 713 ;
    self.bannerImageViewTop = self.bannerImageViewCenterY - self.bannerImageViewHeight*0.5;
    _bannerImageView.frame = CGRectMake(self.bannerImageViewLeft, self.bannerImageViewTop, self.bannerImageViewWide, self.bannerImageViewHeight);
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bannerTapAction)];
    _bannerImageView.userInteractionEnabled = YES;
    [_bannerImageView addGestureRecognizer:tap];
    
    
    self.contentView.width = kScreenWidth;
    self.contentView.left = 0;
    self.contentView.top = -kStatusBarHeight;
    [self.scrollView addSubview:self.contentView];
    
    _spBgViewTopCons.constant = _bannerImageView.height * 0.5;
    _spBgViewHeightCons.constant = kScreenHeight;
    __weak JDMainViewController* wself = self;
    _layoutBottomLine.viewDidLayoutNewFrameCallBack = ^(CGRect newFrame) {
        wself.contentView.height = newFrame.origin.y + newFrame.size.height;
        wself.scrollView.contentSize = CGSizeMake(kScreenWidth, wself.contentView.bottom);
    };
}

-(void)reSetupNavView
{
    _navView.height = kNavigationBarHeight;
//    _navView.top = kStatusBarHeight;
}
//创建分类菜单以及分类子控制器
-(void)setupPageMenusAndChildVcs
{
    //创建临时变量 homePageMenuNames childViewControllers
    NSMutableArray* homePageMenuNames = [NSMutableArray new];
    NSMutableArray* childViewControllers = [NSMutableArray new];
    
    for(int i = 0; i < self.jdCategorys.count; i++){
        JDCategoryModel* jdCategoryModel = [self.jdCategorys objectAtIndex:i];
        [homePageMenuNames addObject:jdCategoryModel.name];
        if(jdCategoryModel.id.integerValue == 1){//京东精选
            JDHomeController* vc = [[JDHomeController alloc]init];
            self.subVcScrollView = (UIScrollView*)vc.tableview;
            self.subVcScrollView.delegate = self;
            vc.tableview.scrollEnabled = NO;//初始状态下让tableview不能滑动
            [childViewControllers addObject:vc];
        } else {//京东其它
            JDCategorySubViewController* vc = [[JDCategorySubViewController alloc]initWithJDCategoryModel:jdCategoryModel];
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
    pageMenu.bridgeScrollView = self.spScrollView;
          
    [pageMenu setUnSelectedItemTitleColor:[UIColor colorWithHexString:@"666666"]];
    self.spPageMenu = pageMenu;
    self.childViewControllers = childViewControllers;
}

#pragma mark - setter

-(void)setSpPageMenu:(SPPageMenu *)spPageMenu
{
    if(_spPageMenu){
        __weak JDMainViewController* wself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself.spPageMenu removeFromSuperview];
            wself.spPageMenu = nil;
        });
    }
    
    _spPageMenu = spPageMenu;
    
    __weak JDMainViewController* wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [wself.spBgView addSubview:wself.spPageMenu];
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
        __weak JDMainViewController* wself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself addChildViewController:vc];
            [wself.spScrollView addSubview:vc.view];
            vc.view.frame = CGRectMake(i*kScreenWidth, 0, kScreenWidth, wself.spScrollView.height);
            wself.spScrollView.contentSize = CGSizeMake(childViewControllers.count * kScreenWidth, self.scrollView.height);
            wself.spScrollView.pagingEnabled = YES;
        });
    }
}

#pragma mark - 网络请求
-(void)requestJDMenuDatas
{
      [self GetWithUrlStr:kFullUrl(kJDCategory) param:nil showHud:YES resCache:nil success:^(id  _Nullable res) {
          if(kSuccessRes){
//               [self dismissNoNetView];//清空无网络
              [self handleJDMenuDatas:res[@"data"]];
          }else{
//              [self showNoNetView];//展示无网络
          }
      } falsed:^(NSError * _Nullable error) {
//          [self showNoNetView];//展示无网络
      }];
}

-(void)handleJDMenuDatas:(NSArray*)datas
{
    NSMutableArray* mutArr = [NSMutableArray new];
    for(int i = 0; i < datas.count; i++){
        NSError* err = nil;
        JDCategoryModel* jdCategoryModel = [[JDCategoryModel alloc]initWithDictionary:datas[i] error:&err];
        
        NSMutableArray* mutChilds = [NSMutableArray new];
        for(int j = 0; j < jdCategoryModel.child.count; j++ ){
            err = nil;
            JDCategoryChild* jdCategoryChild = [[JDCategoryChild alloc]initWithDictionary:jdCategoryModel.child[j] error:&err];
            if(jdCategoryChild){
                [mutChilds addObject:jdCategoryChild];
            }
        }
        if(mutChilds.count > 0){
            jdCategoryModel.child = mutChilds;
        }
        
        if( jdCategoryModel ){
            [mutArr addObject:jdCategoryModel];
        } else {
            NSLog(@"转换京东分类模型失败");
        }
    }
    
    if(mutArr.count > 0){
        self.jdCategorys = mutArr;
        __weak JDMainViewController* wself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            if(wself.jdCategorys.count > 0){
                [wself setupPageMenusAndChildVcs]; //创建分类菜单以及分类子控制器
            }
        });
    }else{
        [[LLHudHelper sharedInstance]tipMessage:@"获取数据失败"];
        return;
    }
}

#pragma mark - control action

- (IBAction)backItemAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)searchBtnAction:(id)sender {
}

-(void)bannerTapAction
{
    for(int i = 0; i < self.jdCategorys.count; i++) {
        JDCategoryModel* jdCategoryModel = [self.jdCategorys objectAtIndex:i];
        if(jdCategoryModel.id.integerValue == 4){//京东家电
            JDJiaDianViewController* vc = [[JDJiaDianViewController alloc]initWithJDCategoryModel:jdCategoryModel];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
    }
}

#pragma mark - SPPageMenu的代理方法

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    //切换vc
    if(self.childViewControllers.count > 0) {
        UIViewController* vc = [self.childViewControllers objectAtIndex:toIndex];
        
        //是否是spPageMenu的子vc
        BOOL isspMeneSubVC = [vc isKindOfClass:[SPMenuSubViewController class]];
        
        //是否加载过了 (number为空 则未加载过)
        NSNumber* number = objc_getAssociatedObject(vc, kRunTimeJDMainViewControllerShow);
        if(isspMeneSubVC && (number == nil)){
            //1 vc 加载数据
            //2  vc 动态绑定
            [((SPMenuSubViewController*)vc) loadDatasWhenUserDone];
            objc_setAssociatedObject(vc, kRunTimeJDMainViewControllerShow, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        } else {
            NSLog(@"do nothing");
        }
    }
    
 //如果该代理方法是由拖拽self.scrollView而触发，说明self.scrollView已经在用户手指的拖拽下而发生偏移，此时不需要再用代码去设置偏移量，否则在跟踪模式为SPPageMenuTrackerFollowingModeHalf的情况下，滑到屏幕一半时会有闪跳现象。闪跳是因为外界设置的scrollView偏移和用户拖拽产生冲突
    if (!self.scrollView.isDragging) { // 判断用户是否在拖拽scrollView
        // 如果fromIndex与toIndex之差大于等于2,说明跨界面移动了,此时不动画.
        if (labs(toIndex - fromIndex) >= 2) {
            [self.spScrollView setContentOffset:CGPointMake(kScreenWidth * toIndex, 0) animated:NO];
        } else {
            [self.spScrollView setContentOffset:CGPointMake(kScreenWidth * toIndex, 0) animated:YES];
        }
    }
    
    if (self.childViewControllers.count <= toIndex) {return;}
    
    UIViewController *targetViewController = self.childViewControllers[toIndex];
    // 如果已经加载过，就不再加载
    if ([targetViewController isViewLoaded]) return;
    
    targetViewController.view.frame = CGRectMake(kScreenWidth * toIndex, 0, kScreenWidth, self.spScrollView.height);
    [_spScrollView addSubview:targetViewController.view];
}



#pragma mark -scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == self.scrollView){
        CGFloat scrollViewOffSetY = self.scrollView.contentOffset.y;
        
        CGFloat oldWidth = self.bannerImageViewWide;     // 图片原始宽度
        CGFloat oldHeight = self.bannerImageViewHeight ; //图片元素高度
        CGFloat oldTop = self.bannerImageViewTop;
        CGFloat oldLeft = self.bannerImageViewLeft;
        
        CGFloat newScrollViewOffSetY = scrollViewOffSetY + kStatusBarHeight;
        
        //---------处理banner frame---------
        if (newScrollViewOffSetY <= 0) {//手指向下
            NSLog(@"手指向下滑动");
            CGFloat totalOffset = oldHeight + ABS(newScrollViewOffSetY);
            CGFloat f = totalOffset / oldHeight; //倍数
            
            CGFloat newLeft = oldLeft - (oldWidth * f - oldWidth) / 2;
            CGFloat newTop = oldTop + newScrollViewOffSetY;
            self.bannerImageView.frame = CGRectMake(newLeft, newTop, oldWidth * f, totalOffset);// 拉伸后的图片的frame应该是同比例缩放
            if(newScrollViewOffSetY == 0){
                NSLog(@"停靠");
            }
        }else{//手指向上
            NSLog(@"手指向上滑动");
        }
        
        //---------处理navView透明度---------
        if(newScrollViewOffSetY <= 0){
            CGFloat maxSpace = 64 * 0.5; //最大移动距离时navView隐藏
                   self.navView.alpha = (1 - ABS(newScrollViewOffSetY)/ maxSpace);
        }
       
        //---------处理navView位置---------
       if (newScrollViewOffSetY < 0) {
           //手指向下
           [self.view addSubview:self.navView];
           self.navView.backgroundColor = [UIColor colorWithHexString:@"#DB2333"];
       } else if (newScrollViewOffSetY == 0) {
           //停靠
           [self.redBgView addSubview:self.navView];
           self.navView.backgroundColor = [UIColor clearColor];
           self.navView.top = 0;
       } else {
           //手指向上
           [self.view addSubview:self.navView];
           self.navView.backgroundColor = [UIColor colorWithHexString:@"#DB2333"];
       }
        
        //---------处理navView是否可滑动---------
        NSLog(@"当前偏移量=%f",newScrollViewOffSetY);
        CGFloat aimY =  _spBgView.top - kNavigationBarHeight;
        NSLog(@"目标=%f",aimY);
        if(newScrollViewOffSetY >= aimY){
            [_scrollView setContentOffset:CGPointMake(0, aimY-40) animated:NO];
            _subVcScrollView.scrollEnabled = YES;
        }else{
            _subVcScrollView.scrollEnabled = NO;
        }
        
    }
    
    //=================================处理子控制器tableview滑动=================================
    
    if(scrollView == self.subVcScrollView){
        CGFloat tableviewOffsetY = self.subVcScrollView.contentOffset.y;
        if(tableviewOffsetY < 0){
            [self.subVcScrollView setContentOffset:CGPointMake(0,0) animated:NO];
            self.subVcScrollView.scrollEnabled = NO;
            self.scrollView.scrollEnabled = YES;
        }
        
        if(tableviewOffsetY > scrollView.height * 2){
            //下面这样写不严谨 可能会发生异常 需要后台不修改
            if(self.childViewControllers.count > 0){
                JDHomeController* vc = self.childViewControllers.firstObject;
                vc.backTopView.hidden = NO;
            }
        }else{
            //下面这样写不严谨 可能会发生异常 需要后台不修改
            if(self.childViewControllers.count > 0){
                JDHomeController* vc = self.childViewControllers.firstObject;
                vc.backTopView.hidden = YES;
            }
        }
    }
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
    __weak JDMainViewController* wself = self;
     dispatch_async(dispatch_get_main_queue(), ^{
         LLTipView* oldTipView =  [self.noNetTipBgView viewWithTag:kTipViewTag];
         if (!oldTipView) {  //没有
             LLTipView* newTipView = [[LLTipView alloc] initWithType:LLTipViewTypeNoNet iconName:@"tipview网络异常" msg:@"加载数据异常" superView:self.noNetTipBgView];
             [wself.noNetTipBgView addSubview:newTipView];
             
             __strong JDMainViewController* sself = wself;
             newTipView.refreshBtnCallback = ^{
                 [sself requestJDMenuDatas];
             };
         }
     });
}

-(void)dismissNoNetView
{
    __weak JDMainViewController* wself = self;
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
