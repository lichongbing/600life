//
//  NineOpintNineViewController.m
//  600生活
//
//  Created by iOS on 2019/11/20.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "NinePointNineViewController.h"
#import "SPPageMenu.h"

#import "NinePointNineSubViewController.h"
#import "UINavigationController+TZPopGesture.h" //tz_addPopGestureToView 系统的侧滑返回的scorllView的滑动并存


@interface NinePointNineViewController ()

@property(nonatomic,strong)NSArray* categorys ;

@property (weak, nonatomic) IBOutlet UIView *spPageMenuBgView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic)  SPPageMenu *spPageMenu;
@property(nonatomic,strong)NSArray* childViewControllers;  //子视图控制器

@end

@implementation NinePointNineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"9块9包邮";
    [self requestGoodsCategorys];
    [self tz_addPopGestureToView:self.scrollView];
}

#pragma mark - 网络请求

-(void)requestGoodsCategorys
{
    __weak NinePointNineViewController* wself = self;
    [self GetWithUrlStr:kFullUrl(kGetGoodsCategorys) param:nil showHud:YES resCache:^(id  _Nullable cacheData) {
        if(kSuccessCache){
            [wself handleGoodsCategorys:cacheData[@"data"]];
        }
    } success:^(id  _Nullable res) {
        if(kSuccessRes){
            [wself handleGoodsCategorys:res[@"data"]];
        }
    } falsed:^(NSError * _Nullable error) {
        
    }];
}

-(void)handleGoodsCategorys:(NSArray*)datas
{
    if(datas.count > 0){
        self.categorys = datas;
    }
}

/**
 commission_category : 高佣分类 (仅高佣活动传)- 人气热销(0),高额佣金(1),大牌推荐(2),今日上架(3),默认0
 */
-(void)requestActivityGoods_9_9
{
    NSDictionary* param = @{
        @"activity_type" : @"nine",
        @"commission_category" : @"0"
    };
    
    [self PostWithUrlStr:kFullUrl(kGetActivityGoods) param:param showHud:YES resCache:^(id  _Nullable cacheData) {
        if(kSuccessCache){
            [self handleActivityGoods_9_9: cacheData[@"data"]];
        }
    } success:^(id  _Nullable res) {
        if(kSuccessRes){
            [self handleActivityGoods_9_9: res[@"data"]];
        }
    } falsed:^(NSError * _Nullable error) {
        
    }];
}


-(void)handleActivityGoods_9_9:(NSArray*)datas
{
    
}

#pragma mark - UI

-(void)setupPageMenusAndChildVcs:(NSArray*)categorys
{
    NSMutableArray* childViewControllers = [NSMutableArray new];
    NSMutableArray* names = [NSMutableArray new];
    for(int i = 0; i < categorys.count; i++){
        NSInteger cid = [categorys[i][@"id"] integerValue];
        NSString* cidStr = [NSString stringWithFormat:@"%lu",cid];
        NinePointNineSubViewController* vc = [[NinePointNineSubViewController alloc]initWithCid:cidStr];
        [childViewControllers addObject:vc];
        
        NSString* name = categorys[i][@"name"];
        if(name.length > 0){
            [names addObject:name];
        }
    }
    
     SPPageMenu *pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, 0, kScreenWidth, 40) trackerStyle:SPPageMenuTrackerStyleLine];
    
    [pageMenu setItems:names selectedItemIndex:0];
    pageMenu.trackerFollowingMode = SPPageMenuTrackerFollowingModeAlways;
    pageMenu.delegate = (id)self;
    pageMenu.bridgeScrollView = self.scrollView;
    pageMenu.showFuntionButton = NO;
    
    self.spPageMenu = pageMenu;
    self.childViewControllers = childViewControllers;
}

#pragma mark - SPPageMenu的代理方法

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index {
   
}

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    //切换vc
    if(self.childViewControllers.count > 0) {
        NinePointNineSubViewController* vc = [self.childViewControllers objectAtIndex:toIndex];
        
        //是否是spPageMenu的子vc
        BOOL isspMeneSubVC = [vc isKindOfClass:[SPMenuSubViewController class]];
        
        //是否加载过了 (number为空 则未加载过)
        NSNumber* number = objc_getAssociatedObject(vc, kRunTimeNinePointNineViewControllerSubVcShow);
        if(isspMeneSubVC && (number == nil)){
            //1 vc 加载数据
            //2  vc 动态绑定
            [((SPMenuSubViewController*)vc) loadDatasWhenUserDone];
            objc_setAssociatedObject(vc, kRunTimeNinePointNineViewControllerSubVcShow, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
        __weak NinePointNineViewController* wself = self;
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
        UIViewController* vc = [childViewControllers objectAtIndex:i];
        [self addChildViewController:vc];
        [self.scrollView addSubview:vc.view];
        vc.view.frame = CGRectMake(i*kScreenWidth, 0, kScreenWidth, self.scrollView.height);
        self.scrollView.contentSize = CGSizeMake(childViewControllers.count * kScreenWidth, self.scrollView.height);
        self.scrollView.pagingEnabled = YES;
    }
}



@end
