//
//  JDTeSeMainViewController.m
//  600生活
//
//  Created by iOS on 2020/1/3.
//  Copyright © 2020 灿男科技. All rights reserved.
//

#import "JDTeSeMainViewController.h"
#import "SPPageMenu.h"
#import "JDOneGoodListViewController.h"

@interface JDTeSeMainViewController ()

@property(nonatomic,assign)int index;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *spPageMenuBgView;


@property(nonatomic,strong)NSArray* titleNames;
@property (strong, nonatomic)  SPPageMenu *spPageMenu;
@property(nonatomic,strong)NSArray* childViewControllers;  //子视图控制器

@end

@implementation JDTeSeMainViewController

-(id)initWithIndex:(int)index
{
    if(self = [super init]){
        self.index = index;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"特色购";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.titleNames = @[@"     好券商品     ",@"     9.9包邮     ",@"     品牌好货     "];
    [self setupPageMenusAndChildVcs];
}

#pragma mark - UI

-(void)setupPageMenusAndChildVcs
{
   NSMutableArray* childViewControllers = [NSMutableArray new];
    
    for(int i = 0; i < self.titleNames.count; i++){
        NSString* cid = nil;
        if(i == 0){ //好券商品
            cid = @"1";
        } else if (i == 1){//9.9包邮
            cid = @"3";
        } else if (i == 2){//品牌好货
            cid = @"4";
        }
        JDOneGoodListViewController* vc = [[JDOneGoodListViewController alloc]initWithCid:cid];
        [childViewControllers addObject:vc];
    }
    
     SPPageMenu *pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, 0, kScreenWidth, 40) trackerStyle:SPPageMenuTrackerStyleLine];
    
    [pageMenu setItems:_titleNames selectedItemIndex:_index];
    [pageMenu setTrackerWidth:30];
    pageMenu.delegate = (id)self;
    pageMenu.bridgeScrollView = self.scrollView;
    pageMenu.showFuntionButton = NO;
    
    self.spPageMenu = pageMenu;
    self.childViewControllers = childViewControllers;
}


#pragma mark - setter
-(void)setSpPageMenu:(SPPageMenu *)spPageMenu
{
    //固定数据 考虑重复创建问题
    _spPageMenu = spPageMenu;
     [self.spPageMenuBgView addSubview:spPageMenu];
}

-(void)setChildViewControllers:(NSArray *)childViewControllers
{
    //固定数据 考虑重复创建问题
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


#pragma mark - SPPageMenu的代理方法

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    //切换vc
    if(self.childViewControllers.count > 0) {
        JDTeSeMainViewController* vc = [self.childViewControllers objectAtIndex:toIndex];
        
        //是否是spPageMenu的子vc
        BOOL isspMeneSubVC = [vc isKindOfClass:[SPMenuSubViewController class]];
        
        //是否加载过了 (number为空 则未加载过)
        NSNumber* number = objc_getAssociatedObject(vc, kRunTimeJDTeSeGouMainViewControllerShow);
        if(isspMeneSubVC && (number == nil)){
            //1 vc 加载数据
            //2  vc 动态绑定
            [((SPMenuSubViewController*)vc) loadDatasWhenUserDone];
            objc_setAssociatedObject(vc, kRunTimeJDTeSeGouMainViewControllerShow, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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

@end
