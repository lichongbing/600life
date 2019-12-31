//
//  MyOrdersViewController.m
//  600生活
//
//  Created by iOS on 2019/11/13.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "MyOrdersMainViewController.h"
#import "SPPageMenu.h"
#import "OrderListViewController.h"

#import "UINavigationController+TZPopGesture.h" //tz_addPopGestureToView 系统的侧滑返回的scorllView的滑动并存

@interface MyOrdersMainViewController ()<SPPageMenuDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *spMenuBgView;
@property (strong, nonatomic)  SPPageMenu *spPageMenu;
@property(nonatomic,strong)NSArray* childViewControllers;  //子视图控制器

@end

@implementation MyOrdersMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的订单";
    [self setupPageMenusAndChildVcs];
    [self tz_addPopGestureToView:self.scrollView];
}

#pragma mark - UI

-(void)setupPageMenusAndChildVcs
{
    //创建临时变量 homePageMenuNames childViewControllers
    NSArray* pageTitles = @[@"  全部  ",@"  已付款  ",@"  已收货  ",@"  已结算  ",@"  已失效  "];
    
    NSMutableArray* childViewControllers = [NSMutableArray new];
    
    for(int i = 0; i < pageTitles.count; i++){
        int orderStatus = [self getOrderStatusWithIndex:i];
        if(orderStatus != 0){
           OrderListViewController* orderListVC = [[OrderListViewController alloc]initWithOrderStatus:orderStatus];
            [childViewControllers addObject:orderListVC];
        }else{
            [[LLHudHelper sharedInstance]tipMessage:@"订单状态异常"];
        }
    }
    
    //创建临时变量pageMenu
          // trackerStyle:跟踪器的样式
    SPPageMenu *pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, 0, kScreenWidth, 50) trackerStyle:SPPageMenuTrackerStyleLine];
          // 传递数组，默认选中第2个
    [pageMenu setItems:pageTitles selectedItemIndex:0];
    pageMenu.trackerFollowingMode = SPPageMenuTrackerFollowingModeAlways;
          // 设置代理
    pageMenu.delegate = (id)self;
    //给pageMenu传递外界的大scrollView，内部监听self.scrollView的滚动，从而实现让跟踪器跟随self.scrollView移动的效果
    pageMenu.bridgeScrollView = self.scrollView;
    self.spPageMenu = pageMenu;
    self.childViewControllers = childViewControllers;
}


#pragma mark - setter
-(void)setSpPageMenu:(SPPageMenu *)spPageMenu
{
    if(_spPageMenu){
        [_spPageMenu removeFromSuperview];
        _spPageMenu = nil;
    }
    _spPageMenu = spPageMenu;
    
     [self.spMenuBgView addSubview:_spPageMenu];
}

-(void)setChildViewControllers:(NSMutableArray *)childViewControllers
{
    if(_childViewControllers == nil) {
        //添加创建子视图控制器
        for(int i = 0; i < childViewControllers.count; i++){
            UIViewController* vc = [childViewControllers objectAtIndex:i];
            [self addChildViewController:vc];
            [self.scrollView addSubview:vc.view];
            vc.view.frame = CGRectMake(i*kScreenWidth, 0, kScreenWidth, self.scrollView.height);
            self.scrollView.contentSize = CGSizeMake(childViewControllers.count * kScreenWidth, _scrollView.height);
            self.scrollView.pagingEnabled = YES;
        }
    }
    _childViewControllers = childViewControllers;
}
#pragma mark - SPPageMenu的代理方法

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index {
   
}

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
   
    //首次加载 此时vc0 可能还没有被加载进来
    if(fromIndex == 0 && toIndex == 0){
        //延时0.2秒后执行,让vc0 加载数据
        //vc0 动态绑定
        __weak MyOrdersMainViewController* wself = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIViewController* vc0 = [wself.childViewControllers objectAtIndex:0];
            objc_getAssociatedObject(vc0, kRunTimeOrderListViewControllerShow);
            [((OrderListViewController*)vc0) loadDatasWhenUserDone];
        });
        return;
    }
    
    //切换vc
    if(self.childViewControllers.count > 0) {
        UIViewController* vc = [self.childViewControllers objectAtIndex:toIndex];
        NSNumber* number = objc_getAssociatedObject(vc, kRunTimeOrderListViewControllerShow);
        if(number == nil){
            //1 vc 加载数据
            //2  vc 动态绑定
            [((OrderListViewController*)vc) loadDatasWhenUserDone];
            objc_setAssociatedObject(vc, kRunTimeOrderListViewControllerShow, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        } else {
            NSLog(@"do nothing");
        }
    }
      
    
    // 如果该代理方法是由拖拽self.scrollView而触发，说明self.scrollView已经在用户手指的拖拽下而发生偏移，此时不需要再用代码去设置偏移量，否则在跟踪模式为SPPageMenuTrackerFollowingModeHalf的情况下，滑到屏幕一半时会有闪跳现象。闪跳是因为外界设置的scrollView偏移和用户拖拽产生冲突
   
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

    
#pragma mark - helper

-(int)getOrderStatusWithIndex:(int)i
{
    switch (i) {
        case 0:
            return 1;  //所有订单
            break;
       
        case 1:
            return 12;  //已付款
            break;
       
        case 2:
            return 14;   //订单成功(已收货)
            break;
          
        case 3:
            return 3;    //结算
                break;
        
        case 4:
                return 13; //失效
                break;
        default:
            return 0;
            break;
    }
}
@end

