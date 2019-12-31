//
//  GoodStoreMainViewController.m
//  600生活
//
//  Created by iOS on 2019/11/21.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "ViewController3.h"
#import "SPPageMenu.h"

#import "GoodStoresSubViewController.h"

@interface ViewController3 ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navBarTopCons;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIView *spPageMenuBgView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property(nonatomic,strong)NSArray* categorys ;        //保存品牌好店菜单数据
@property (strong, nonatomic)  SPPageMenu *spPageMenu;
@property(nonatomic,strong)NSArray* childViewControllers;  //子视图控制器

@end

@implementation ViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    _navBarTopCons.constant = kStatusBarHeight;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenNavigationBarWithAnimation:animated];
    if(self.navigationController.viewControllers.count == 1){
        self.backBtn.hidden = YES;
    }
    
    if(!self.categorys){
        [self requestBrandCategorys];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self showNavigationBarWithAnimation:animated];
}



#pragma mark - 网络请求
-(void)shouldReloadData
{
    [self requestBrandCategorys];
}

//获取品牌好店分类
-(void)requestBrandCategorys
{
    [self GetWithUrlStr:kFullUrl(kBrandCategory) param:nil showHud:YES resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes){
            [self handleBrandCategorys: res[@"data"]];
        }
    } falsed:^(NSError * _Nullable error) {
        
    }];
}


/**
 元素结构
 {
     "cid":"0",
     "name":"精选"
 },
 */
-(void)handleBrandCategorys:(NSArray*)datas
{
   if(datas.count > 0){
        self.categorys = datas;
    }
}

#pragma mark - UI

-(void)setupPageMenusAndChildVcs:(NSArray*)categorys
{
    NSMutableArray* childViewControllers = [NSMutableArray new];
    NSMutableArray* names = [NSMutableArray new];
    for(int i = 0; i < categorys.count; i++){
        NSString* cid = [[categorys objectAtIndex:i] valueForKey:@"cid"];
        if(cid){
            GoodStoresSubViewController* vc = [[GoodStoresSubViewController alloc]initWithCid:cid];
            [childViewControllers addObject:vc];
        }else{
            [[LLHudHelper sharedInstance]tipMessage:@"商店id异常"];
        }
        
        NSString* name = categorys[i][@"name"];
        if(name.length > 0){
            [names addObject:name];
        }else{
            [[LLHudHelper sharedInstance]tipMessage:@"商店id异常"];
        }
    }
    
     SPPageMenu *pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, 0, kScreenWidth, 40) trackerStyle:SPPageMenuTrackerStyleLine];
    
    [pageMenu setItems:names selectedItemIndex:0];
    pageMenu.trackerFollowingMode = SPPageMenuTrackerFollowingModeAlways;
    pageMenu.delegate = (id)self;
    pageMenu.bridgeScrollView = self.scrollView;
    pageMenu.showFuntionButton = NO;
    
    self.spPageMenu = pageMenu;
    self.spPageMenu.backgroundColor = [UIColor clearColor];
    self.spPageMenu.unSelectedItemTitleColor = [UIColor colorWithHexString:@"#E5CDFE"];
    self.spPageMenu.selectedItemTitleColor = [UIColor whiteColor];
    self.spPageMenu.unSelectedItemTitleFont = [UIFont systemFontOfSize:15];
    self.spPageMenu.selectedItemTitleFont = [UIFont systemFontOfSize:17];
    self.spPageMenu.tracker.backgroundColor = [UIColor whiteColor];
    self.spPageMenu.dividingLine.hidden = YES;
    self.childViewControllers = childViewControllers;
}


#pragma mark - SPPageMenu的代理方法

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index {
   
}

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    //切换vc
    if(self.childViewControllers.count > 0) {
        UIViewController* vc = [self.childViewControllers objectAtIndex:toIndex];
        
        //是否是spPageMenu的子vc
        BOOL isspMeneSubVC = [vc isKindOfClass:[GoodStoresSubViewController class]];
        
        //是否加载过了 (number为空 则未加载过)
        NSNumber* number = objc_getAssociatedObject(vc, kRunTimeGoodStoreMainViewControllerSubVcShow);
        if(isspMeneSubVC && (number == nil)){
            //1 vc 加载数据
            //2  vc 动态绑定
            [((GoodStoresSubViewController*)vc) loadDatasWhenUserDone];
            objc_setAssociatedObject(vc, kRunTimeGoodStoreMainViewControllerSubVcShow, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
    [self.scrollView addSubview:targetViewController.view];

}

- (void)pageMenu:(SPPageMenu *)pageMenu functionButtonClicked:(UIButton *)functionButton
{
    
}


#pragma mark - setter

-(void)setCategorys:(NSArray *)categorys
{
    _categorys = categorys;
    
    if(categorys.count > 0){
        __weak ViewController3* wself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself setupPageMenusAndChildVcs:categorys];
        });
    }
}

-(void)setSpPageMenu:(SPPageMenu *)spPageMenu
{
    if(_spPageMenu){
        [_spPageMenu removeFromSuperview];
        _spPageMenu = nil;
    }
    
    _spPageMenu = spPageMenu;
    
     [self.spPageMenuBgView addSubview:spPageMenu];
}

-(void)setChildViewControllers:(NSArray *)childViewControllers
{
    if(_childViewControllers.count > 0){
        for(UIViewController* subVc in _childViewControllers){
            [subVc.view removeFromSuperview];
            [subVc removeFromParentViewController];
        }
    }
    
    _childViewControllers = childViewControllers;
    
    //添加创建子视图控制器
    for(int i = 0; i < childViewControllers.count; i++){
        GoodStoresSubViewController* vc = [childViewControllers objectAtIndex:i];
        [self addChildViewController:vc];
        [self.scrollView addSubview:vc.view];
        vc.view.frame = CGRectMake(i*kScreenWidth, 0, kScreenWidth, self.scrollView.height);
        self.scrollView.contentSize = CGSizeMake(childViewControllers.count * kScreenWidth, self.scrollView.height);
        self.scrollView.pagingEnabled = YES;
    }
}
- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
