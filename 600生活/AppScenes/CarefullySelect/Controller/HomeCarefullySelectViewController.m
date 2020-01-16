//
//  HomeCarefullySelectViewController.m
//  600生活
//
//  Created by iOS on 2019/11/6.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "HomeCarefullySelectViewController.h"
#import "LLBaseView.h"
#import "SPButton.h"
#import "KHAdView.h"  //图片广告轮播
#import "YMNoticeScrollView.h"  //头条 文字广告轮播

#import "HomePageRushGoodTableViewCell.h" //马上抢 cell
#import "HomePageGoodTableViewCell.h"    //商品 cell

#import "HotRecommendViewController.h"  //爆款推荐
#import "RushGoodsViewController.h"   //限时秒杀
#import "NinePointNineViewController.h" //9块9包邮
#import "SuperGoodViewController.h" //超级大牌
#import "HotRankGoodViewController.h"  //热销榜
#import "GoodDealViewController.h"   //聚划算
#import "WebViewViewController.h"      //浏览器界面
#import "TreasureGoodViewController.h"    //人气宝贝
#import "GaoYongViewController.h"  //高佣优选

#import "GoodDetailViewController.h" //商品详情
#import "ExclusiveViewController.h"  //独家福利购
#import "WanJuanViewController.h"    //万卷齐发
#import "ViewController3.h"  //品牌好店 分类
#import "BestSelectMainViewController.h"  //好货严选
#import "SealCountView.h"  //自定义售出柱状图

#import "LLWindowTipView.h"  //提醒登录  智能搜索优惠券

#import "InviteCodeViewController.h"  //输入邀请码
#import "BackTopView.h"//返回顶部
#import "LoginAndRigistMainVc.h"//登录

#import "JDMainViewController.h"  //京东首页

#define kControlSpaceTop  17.5    //上边
#define kControlSpaceLeft 17.5   //左边
#define kControlSpaceV   20//(kIsiPhoneX_Series ? 26 : 30)       // 竖直 距离
#define kControlSpaceH 20       // 水平 距离
#define kColumns      5         //列数（行数根据列数计算而来）

@interface HomeCarefullySelectViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,YMNoticeScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet LLBaseView *layoutButtomLine;

//图片广告轮播图
@property (weak, nonatomic) IBOutlet UIView *adViewBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adViewBgViewHeightCons; //高度约束

@property(nonatomic,strong) KHAdView* adView;

//活动背景
@property (weak, nonatomic) IBOutlet UIView *activityBgView;

//头条 文字广告轮播
@property (weak, nonatomic) IBOutlet YMNoticeScrollView *topNoticeView;

//独家福利购 btn
@property (weak, nonatomic) IBOutlet UIButton *exclusiveBtn;

//券
@property (weak, nonatomic) IBOutlet UIView *quanBgView;

//严选
@property (weak, nonatomic) IBOutlet UIView *bestGoodBg;

//热销
@property (weak, nonatomic) IBOutlet UIView *hotBgView;

//秒杀
@property (weak, nonatomic) IBOutlet UIView *rushBgView; //秒杀时间段列表
@property (weak, nonatomic) IBOutlet UILabel *rushEndH; //秒杀结束 时
@property (weak, nonatomic) IBOutlet UILabel *rushEndM; //秒杀结束 分
@property (weak, nonatomic) IBOutlet UILabel *rushEndS; //秒杀结束 秒
@property(atomic,strong) NSTimer* timer;  //秒杀倒计时
@property(nonatomic,assign) NSInteger timerCounter; //计数器  触发timer 初始为0
@property(nonatomic,strong) NSCalendar* calendar; //计算剩余时间
@property(nonatomic,strong) BackTopView* backTopView; //返回顶部


/**
 *
 *tag == 10  图片
 *tag == 11 标题
 *tag == 12 新价格    40
 *tag == 13 旧价格    ￥50
 */
@property (weak, nonatomic) IBOutlet UIView *hotCell1;
@property (weak, nonatomic) IBOutlet UIView *hotCell2;
@property (weak, nonatomic) IBOutlet UIView *hotCell3;

//秒杀 三个商品
@property (weak, nonatomic) IBOutlet UIView *rushThreeGoodsBgView;

//马上抢table
@property (weak, nonatomic) IBOutlet UITableView *nowRushTableview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nowRushTableviewHeightConstraint;

@end


@interface HomeCarefullySelectViewController ()

@property(nonatomic,strong)HomePageModel* homePageModel;
@property(nonatomic,assign)CGFloat rushBgViewTop;//抢购背景加载完成后的高度

@end

@implementation HomeCarefullySelectViewController


-(id)init
{
    if(self = [super init]){
        self.homePageModel = [[HomePageModel alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupUI];
    //请求精选(首页)数据
    [self requestGoodSelectDatas];
    
    [self addBackToTopView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(self.tableview.mj_header.isRefreshing){
        [self.tableview.mj_header endRefreshing];
    }
}

#pragma mark - UI
-(void)setupUI
{
    self.contentView.width = kScreenWidth;
    self.tableview.showsVerticalScrollIndicator = NO;
    self.tableview.height = kScreenHeight - kNavigationBarHeight - kTabbarHeight -40;
    self.tableview.tableHeaderView = self.contentView;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = (id)self;
    self.tableview.dataSource = (id)self;
    [self.tableview registerNib:[UINib nibWithNibName:@"HomePageGoodTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomePageGoodTableViewCell"];
    
    __weak HomeCarefullySelectViewController* wself = self;
    _layoutButtomLine.viewDidLayoutNewFrameCallBack = ^(CGRect newFrame) {
        wself.contentView.height = newFrame.origin.y + newFrame.size.height + 10;
        wself.tableview.tableHeaderView = wself.contentView;
        wself.rushBgViewTop = wself.rushBgView.top;
    };
    
    _adView.width = kScreenWidth;
    _activityBgView.width = kScreenWidth;
    
    _hotBgView.width = kScreenWidth - 12 * 2;
    _hotBgView.layer.cornerRadius = 8;
    
    UIView* layerView = [_hotBgView viewWithTag:100];
    layerView.layer.cornerRadius = 8;
    layerView.backgroundColor  = [UIColor clearColor];
    layerView.width = _hotBgView.width;
    layerView.height = _hotBgView.height;
    [Utility addGradualChangingColorWithView:layerView fromColor:[UIColor colorWithHexString:@"#F54556"] toColor:[UIColor colorWithHexString:@"#FBEBE8"] orientation:@[@0,@0,@0,@1]];
    
    //马上抢
    _nowRushTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _nowRushTableview.scrollEnabled = NO;
    _nowRushTableview.delegate = (id)self;
    _nowRushTableview.dataSource = (id)self;
    [_nowRushTableview registerNib:[UINib nibWithNibName:@"HomePageRushGoodTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomePageRushGoodTableViewCell"];
    
     [self addMJRefresh];
}

#pragma mark - 此处有回调
-(void)addBackToTopView
{
    _backTopView = [[BackTopView alloc]init];
    [self.view bringSubviewToFront:_backTopView];
    _backTopView.right = kScreenWidth - 20 ;
    _backTopView.bottom = kScreenHeight - kNavigationBarHeight - kTabbarHeight - 50;
    [self.view addSubview:_backTopView];

    
    __weak HomeCarefullySelectViewController* wself = self;
    _backTopView.backTopViewClickedCallBack = ^{
        __strong HomeCarefullySelectViewController* sself = wself;
           [UIView animateWithDuration:0.3 animations:^{
               sself.tableview.contentOffset = CGPointMake(0, 0);
           }];
    };
}


#pragma mark - 网络请求
//获取主页数据
//获取精选(首页)数据
-(void)requestGoodSelectDatas
{
    [self GetWithUrlStr:kFullUrl(kHomePageMain) param:nil showHud:NO resCache:^(id  _Nullable cacheData) {
        if(kSuccessCache){
            [self handleGoodSelectDatas:cacheData[@"data"]];
        }
    } success:^(id  _Nullable res) {
        if(kSuccessRes){
            [self handleGoodSelectDatas: res[@"data"]];
        }
    } falsed:^(NSError * _Nullable error) {
        NSLog(@"%@",error);
    }];
}

-(void)handleGoodSelectDatas:(NSDictionary*)data
{
    __weak HomeCarefullySelectViewController* wself = self;
    
    //处理广告图
    NSArray* banner_list = data[@"banner_list"];
    NSMutableArray* mutArr = [NSMutableArray new];
    for(int i = 0; i <banner_list.count; i++){
        NSError* err = nil;
        HomePageBannerModel* homePageBannerModel = [[HomePageBannerModel alloc]initWithDictionary:banner_list[i] error:&err];
        if(homePageBannerModel){
            [mutArr addObject:homePageBannerModel];
        } else {
            NSLog(@"HomePageBannerModel转换失败");
        }
    }
 
    if(mutArr.count > 0){
        self.homePageModel.banner_list = mutArr;
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself resetupAdView];
        });
    }
    
    //处理活动
    NSArray* activity_list = data[@"activity_list"];
    mutArr = [NSMutableArray new];
    
    for(int i = 0; i <activity_list.count; i++){
        NSError* err = nil;
        HomePageActivityModel* homePageActivityModel = [[HomePageActivityModel alloc]initWithDictionary:activity_list[i] error:&err];
        if(homePageActivityModel){
            [mutArr addObject:homePageActivityModel];
        } else {
            NSLog(@"HomePageActivityModel转换失败");
        }
    }
    
    if(mutArr.count > 0){
        wself.homePageModel.activity_list = mutArr;
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself resetupActivityItems];
        });
    }
    
    //处理头条
    NSArray* top_list = data[@"top_list"];
    mutArr = [NSMutableArray new];
    for(int i = 0; i <top_list.count; i++){
        NSError* err = nil;
        HomePageTopModel* homePageTopModel = [[HomePageTopModel alloc]initWithDictionary:top_list[i] error:&err];
        if(homePageTopModel){
            [mutArr addObject:homePageTopModel];
        } else {
            NSLog(@"HomePageTopModel转换失败");
        }
    }
    if(mutArr.count > 0){
        self.homePageModel.top_list = mutArr;
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself resetupTopBgView];
        });
    }
    
    //独家福购数据
    NSError* err = nil;
    HomePageExclusiveModel* homePageExclusiveModel = [[HomePageExclusiveModel alloc]initWithDictionary:data[@"exclusive_list"] error:&err];
    if(homePageExclusiveModel){
        self.homePageModel.exclusive_list = homePageExclusiveModel;
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself resetupExclusiveView];
        });
    }else{
        NSLog(@"HomePageExclusiveModel转换失败");
    }
    
    
    //万卷齐发
    NSArray* juan_store = data[@"juan_store"];
    mutArr = [NSMutableArray new];
    
    for(int i = 0; i <juan_store.count; i++){
        NSError* err = nil;
        HomePageJuanModel* homePageJuanModel = [[HomePageJuanModel alloc]initWithDictionary:juan_store[i] error:&err];
        if(homePageJuanModel){
            [mutArr addObject:homePageJuanModel];
        } else {
            NSLog(@"HomePageJuanModel转换失败");
        }
    }
    if(mutArr.count > 0){
        self.homePageModel.juan_store = mutArr;
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself resetupJuanView];
        });
    }
    
    
    //严选好货
    NSArray* best_goods = data[@"best_goods"];
    mutArr = [NSMutableArray new];
    
    for(int i = 0; i <best_goods.count; i++){
        NSError* err = nil;
        HomePageBestGoodModel* homePageBestGoodModel = [[HomePageBestGoodModel alloc]initWithDictionary:best_goods[i] error:&err];
        if(homePageBestGoodModel){
            [mutArr addObject:homePageBestGoodModel];
        } else {
            NSLog(@"HomePageBestGoodModel转换失败");
        }
    }
    
    if(mutArr.count > 0){
        self.homePageModel.best_goods = mutArr;
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself resetuBestGoods];
        });
    }
    
    //处理热销榜单排行
    NSArray* hot_goods = data[@"hot_goods"];
    mutArr = [NSMutableArray new];
    for(int i = 0; i <hot_goods.count; i++){
        NSError* err = nil;
        HomePageHotGoodModel* homePageHotGoodModel = [[HomePageHotGoodModel alloc]initWithDictionary:hot_goods[i] error:&err];
        if(homePageHotGoodModel){
            [mutArr addObject:homePageHotGoodModel];
        } else {
            NSLog(@"HomePageHotGoodModel转换失败");
        }
    }
    
    if(mutArr.count > 0){
        self.homePageModel.hot_goods = mutArr;
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself resetupHotView];
        });
    }
    
    //限时秒杀商品
    NSDictionary* rush_goods = data[@"rush_goods"];
    err = nil;
    self.homePageModel.rush_goods = [[HomePageRushGoodsModel alloc]initWithDictionary:rush_goods error:&err];
    if(!self.homePageModel.rush_goods) {
        NSLog(@"HomePageRushGoodsModel转换失败");
    }
    
    if(self.homePageModel.rush_goods){
        //添加list
        NSArray* list = rush_goods[@"list"];
        NSMutableArray* mutArr = [NSMutableArray new];
        for(int i = 0; i < list.count; i++){
            NSError* err = nil;
            HomePageRushGoodsListItem* homePageRushGoodsListItem = [[HomePageRushGoodsListItem alloc]initWithDictionary:list[i] error:&err];
            if (homePageRushGoodsListItem) {
                [mutArr addObject:homePageRushGoodsListItem];
            } else {
                NSLog(@"HomePageRushGoodsListItem转换失败");
            }
        }
        if(mutArr.count > 0){
            self.homePageModel.rush_goods.list = mutArr;
        }
        
        //添加timelist
        NSArray* timeList = rush_goods[@"time_list"];
        mutArr = [NSMutableArray new];
        for(int i = 0; i < timeList.count; i++){
            NSError* err = nil;
            HomePageRushGoodsTimeListItem* homePageRushGoodsTimeListItem = [[HomePageRushGoodsTimeListItem alloc]initWithDictionary:timeList[i] error:&err];
            if (homePageRushGoodsTimeListItem) {
                [mutArr addObject:homePageRushGoodsTimeListItem];
            } else {
                NSLog(@"HomePageRushGoodsTimeListItem转换失败");
            }
        }
        
        if(mutArr.count > 0){
            self.homePageModel.rush_goods.time_list = mutArr;
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [wself resetupTimelyRushView];
    });
    
    
    //处理马上抢
    NSArray* rush_goods_2 = data[@"rush_goods_2"];
    mutArr = [NSMutableArray new];
    for(int i = 0; i < rush_goods_2.count; i++){
        NSError* err = nil;
        HomePageRushGoods2ItemModel* homePageRushGoods2ItemModel = [[HomePageRushGoods2ItemModel alloc]initWithDictionary:rush_goods_2[i] error:&err];
        if(homePageRushGoods2ItemModel){
            [mutArr addObject:homePageRushGoods2ItemModel];
        } else {
            NSLog(@"HomePageRushGoods2ItemModel转换失败");
        }
    }
    
    if(mutArr.count > 0){
        self.homePageModel.rush_goods_2 = mutArr;
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself.nowRushTableview reloadData];
        });
    }
}

//获取底部数据
-(void)requestHomePageButtomListWithPageIndex:(NSInteger)pageIndex
{
    NSDictionary* param = @{
        @"page":[NSNumber numberWithInteger:self.pageIndex],
        @"page_size":@"10"
    };
    
    __weak HomeCarefullySelectViewController* wself = self;
    
    [self GetWithUrlStr:kFullUrl(kHomePageList) param:param showHud:NO resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes){
            [wself handleHomePageButtomListWithPageIndex:pageIndex data:res];
        }
    } falsed:^(NSError * _Nullable error) {
        NSLog(@"%@",error.description);
    }];
}

-(void)handleHomePageButtomListWithPageIndex:(NSInteger)pageIndex data:(NSDictionary*)data
{
    //处理主页分页数据
    NSArray* goods_list = data[@"data"];
    NSMutableArray* mutArr = [NSMutableArray new];
    for(int i = 0; i < goods_list.count; i++){
        NSError* err = nil;
        HomePageGoodsListItemModel* homePageGoodsListItemModel = [[HomePageGoodsListItemModel alloc]initWithDictionary:goods_list[i] error:&err];
        if(homePageGoodsListItemModel){
            [mutArr addObject:homePageGoodsListItemModel];
        } else {
            
        }
    }
    
    [self configDataSource:mutArr];
}

-(void)configDataSource:(NSArray*)tempArray
{
    __weak HomeCarefullySelectViewController* wself = self;
    if (tempArray.count > 0) { //有数据
        if(self.pageIndex == 1){//头部刷新
            self.datasource = [[NSMutableArray alloc]initWithArray:tempArray];
        } else if(self.pageIndex > 1){ //尾部加载
            [self.datasource addObjectsFromArray:tempArray];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself.tableview reloadData];
        });
    } else { //无数据
        self.pageIndex--; // 此时的pageIndex 取不到数据 应该-1
        dispatch_async(dispatch_get_main_queue(), ^{
            if(wself.datasource.count > 0){
                 [wself.tableview.mj_footer endRefreshingWithNoMoreData];
            }
        });
    }
}


#pragma mark - UI

//图片广告
-(void)resetupAdView
{
    NSMutableArray* mutArr = [NSMutableArray new];
    for (int i = 0; i < self.homePageModel.banner_list.count; i++){
        HomePageBannerModel* homePageBannerModel = self.homePageModel.banner_list[i];
        NSString* imageUrl = homePageBannerModel.image;
        if(imageUrl){
            [mutArr addObject:imageUrl];
        }
    }
    
    if(mutArr.count == 0){
        return;
    }
    
    if(self.adView){
        [self.adView removeFromSuperview];
        self.adView = nil;
    }
    self.adView = [[KHAdView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * 150 / 375)];
    [self.adViewBgView addSubview:self.adView];
    self.adView.pageIndicatorTintColor = kAppBackGroundColor;
    self.adView.currentPageIndicatorTintColor = [UIColor whiteColor];
    [self.adView setUpOnlineImagesWithSource:mutArr PlaceHolder:kPlaceHolderImg ClickHandler:^(NSInteger index, NSString *imgSrc, UIImage *img) {
    }];
    self.adView.bottomViewColor = [UIColor clearColor];
    [self.adView startTimer];
}

//活动
-(void)resetupActivityItems
{
    //控件宽度
    CGFloat controlWidth = (self.activityBgView.width - kControlSpaceLeft*2 - kControlSpaceH*(kColumns-1)) / kColumns;
    
    //控件高度
    CGFloat controlHeight = controlWidth ;
    
    //保存图片背景高度
    CGFloat imagesBgViewHeight = 0;
    for (int i = 0; i < self.homePageModel.activity_list.count; i++) {
        int row = i / kColumns;      //当前行数
        int col = i % kColumns;      //当前列数
        
        //控件left
        CGFloat controlLeft = kControlSpaceLeft + col*controlWidth + col*kControlSpaceH;
        
        //控件top
        CGFloat controlTop = kControlSpaceTop + row*controlHeight + row*kControlSpaceV;
        
        SPButton* spButton = [self.activityBgView viewWithTag:(10+i)];
        spButton.frame = CGRectMake(controlLeft, controlTop, controlWidth, controlHeight);
        spButton.imagePosition = SPButtonImagePositionTop;
        spButton.imageTitleSpace = 10;
        spButton.hidden = NO;

        HomePageActivityModel* homePageActivityModel = self.homePageModel.activity_list[i];
        [spButton setTitle:homePageActivityModel.name forState:UIControlStateNormal];
        
        [spButton addTarget:self action:@selector(activityItemsBtnsAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [spButton sd_setImageWithURL:[NSURL URLWithString:homePageActivityModel.icon] forState:UIControlStateNormal placeholderImage:kPlaceHolderImg];
        
        spButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        if(imagesBgViewHeight < spButton.bottom){
            imagesBgViewHeight = spButton.bottom;
        }
        
        _adViewBgViewHeightCons.constant = imagesBgViewHeight + 12;
    }
}

//头条 文字轮播
-(void)resetupTopBgView
{
    NSMutableArray* mutArr = [NSMutableArray new];
    for (int i = 0; i < self.homePageModel.top_list.count; i++){
        HomePageTopModel* homePageTopModel = self.homePageModel.top_list[i];
        if(homePageTopModel.title){
            [mutArr addObject:homePageTopModel.title];
        }
    }
    if(mutArr.count > 0){
        _topNoticeView.contents = mutArr;
        _topNoticeView.delegate = (id)self;
    }
}

//独家福利购
-(void)resetupExclusiveView
{
     [_exclusiveBtn sd_setImageWithURL:[NSURL URLWithString:self.homePageModel.exclusive_list.image] forState:UIControlStateNormal placeholderImage:kPlaceHolderImg];
}

//券数据
-(void)resetupJuanView
{
    for(int i = 0; i < self.homePageModel.juan_store.count; i++){
        HomePageJuanModel* homePageJuanModel = self.homePageModel.juan_store[i];
        
        UIButton* btn = [_quanBgView viewWithTag:(10+i)];
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:homePageJuanModel.image] forState:UIControlStateNormal placeholderImage:kPlaceHolderImg];
        
        if(i == 1){return;} //只处理前两个元素
    }
}

//好货严选
-(void)resetuBestGoods
{
    for(int i = 0; i < self.homePageModel.best_goods.count; i++){
         HomePageBestGoodModel* homePageBestGoodModel = self.homePageModel.best_goods[i];
        
        //cell
        UIView* cell = [_bestGoodBg viewWithTag:(20+i)];
        //图片
        UIImageView* icon = [cell viewWithTag:(200+i)];
        [icon sd_setImageWithURL:[NSURL URLWithString:homePageBestGoodModel.pict_url] placeholderImage:kPlaceHolderImg];
        
        //tip Lab
        
        BOOL isCat = [homePageBestGoodModel.type isEqualToString:@"1"];
        UILabel* tipLab = [cell viewWithTag:(210+i)];
        tipLab.layer.borderWidth = 1;
        tipLab.layer.borderColor = [UIColor colorWithHexString:@"#F54556"].CGColor;
        if(isCat){
            
            tipLab.text = @"天猫";
        }else {
            tipLab.text = @"淘宝";
        }
        
        //content Lab  10个空格
        UILabel* contentLab = [cell viewWithTag:(220+i)];
        contentLab.text = [NSString stringWithFormat:@"\t  %@",homePageBestGoodModel.title];
        
        //newPriceLab
        UILabel* priceLab = [cell viewWithTag:(230+i)];
        priceLab.text = homePageBestGoodModel.quanhou_price;
        
        //旧价格
        UILabel* oldPriceLab = [cell viewWithTag:(240+i)];
        oldPriceLab.text = [NSString stringWithFormat:@"￥%@",homePageBestGoodModel.price];
        
        //已售数量
        UILabel* sellCountLab = [cell viewWithTag:(250+i)];
        sellCountLab.text = [NSString stringWithFormat:@"已售 %@",homePageBestGoodModel.volume];
        
        //券价值//8个空格+1个空格
        UIButton* btn = [cell viewWithTag:(260+i)];
        [btn setTitle:[NSString stringWithFormat:@"        ￥%@ ",homePageBestGoodModel.coupon_money] forState:UIControlStateNormal];
        
        //预计收益
        UILabel* incomeLab = [cell viewWithTag:(270+i)];
        incomeLab.text = [NSString stringWithFormat:@" 预计收益￥%@ ",homePageBestGoodModel.earnings];
        
        if(i == 3){return;} //只处理前4个元素
    }
}


//热销榜单
-(void)resetupHotView
{
    for(int i = 0; i < self.homePageModel.hot_goods.count;i++){
       HomePageHotGoodModel* homePageHotGoodModel = [self.homePageModel.hot_goods objectAtIndex:i];
        
        if(i == 0){
            [((UIImageView*)[_hotCell1 viewWithTag:10]) sd_setImageWithURL:[NSURL URLWithString:homePageHotGoodModel.pict_url] placeholderImage:kPlaceHolderImg];
            ((UILabel*)[_hotCell1 viewWithTag:11]).text = homePageHotGoodModel.title;
            ((UILabel*)[_hotCell1 viewWithTag:12]).text = homePageHotGoodModel.quanhou_price;
            ((UILabel*)[_hotCell1 viewWithTag:13]).text = homePageHotGoodModel.price;
        } else if (i == 1) {
            [((UIImageView*)[_hotCell2 viewWithTag:10]) sd_setImageWithURL:[NSURL URLWithString:homePageHotGoodModel.pict_url] placeholderImage:kPlaceHolderImg];
            ((UILabel*)[_hotCell2 viewWithTag:11]).text = homePageHotGoodModel.title;
            ((UILabel*)[_hotCell2 viewWithTag:12]).text = homePageHotGoodModel.quanhou_price;
            ((UILabel*)[_hotCell2 viewWithTag:13]).text = homePageHotGoodModel.price;
        } else if (i==2) {
            [((UIImageView*)[_hotCell3 viewWithTag:10]) sd_setImageWithURL:[NSURL URLWithString:homePageHotGoodModel.pict_url] placeholderImage:kPlaceHolderImg];
            ((UILabel*)[_hotCell3 viewWithTag:11]).text = homePageHotGoodModel.title;
            ((UILabel*)[_hotCell3 viewWithTag:12]).text = homePageHotGoodModel.quanhou_price;
            ((UILabel*)[_hotCell3 viewWithTag:13]).text = homePageHotGoodModel.price;
        }
        if(i == 2){return;}//只处理前三个元素
    }
}

//限时秒杀
-(void)resetupTimelyRushView
{
    NSDate* endDate = [NSDate dateWithTimeIntervalSince1970:self.homePageModel.rush_goods.end_time.doubleValue];
    NSDate* nowDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit type0 = NSCalendarUnitSecond;
    NSDateComponents *cmps0 = [calendar components:type0 fromDate:nowDate toDate:endDate options:0];
    NSInteger newSeconds = cmps0.second; //新的相差的秒数
    if(newSeconds > 0){
        self.timerCounter = newSeconds;
        __weak HomeCarefullySelectViewController* wself = self;
        //当前线程为主线程，timer操作放到子线程中去
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [wself deInitGlobalQueueTimer];
            [wself initTimer];
        });
    }else{
        __weak HomeCarefullySelectViewController* wself = self;
        //当前线程为主线程，timer操作放到子线程中去
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [wself deInitGlobalQueueTimer];
        });
    }

    //时间列表
    for(UIView* subView in self.rushBgView.subviews){
        if(subView){
            [subView removeFromSuperview];
        }
    }
    
    UIScrollView* scrollView = [UIScrollView new];
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.rushBgView addSubview:scrollView];
    scrollView.tag = 288;
    scrollView.backgroundColor = self.rushBgView.backgroundColor;
    scrollView.frame = CGRectMake(0, 0, self.rushBgView.width, self.rushBgView.height);
    
    CGFloat left = 0;
    CGFloat space = ((kScreenWidth - 12 * 2) - 50 * 5) / 4;
    for(int i = 0; i < self.homePageModel.rush_goods.time_list.count; i++) {
        HomePageRushGoodsTimeListItem* homePageRushGoodsTimeListItem = self.homePageModel.rush_goods.time_list[i];
        
        UIView* cell = [UIView new];
        cell.tag = (10+i);
        cell.width = 50;
        cell.height = 60;
        
        //10:00
        UILabel* timeLab = [UILabel new];
        [cell addSubview:timeLab];
        timeLab.tag = 1;
        timeLab.textAlignment = NSTextAlignmentCenter;
        timeLab.font = [UIFont systemFontOfSize:16];
        timeLab.textColor = [UIColor colorWithHexString:@"#333333"];
        timeLab.width = 50;
        timeLab.height = 18;
        timeLab.left =  0;
        timeLab.top = 5;
        timeLab.text = homePageRushGoodsTimeListItem.time;
        
        
        //已开抢
        UILabel* desLab = [UILabel new];
        desLab.tag = 2;
        [cell addSubview:desLab];
        desLab.textAlignment = NSTextAlignmentCenter;
        desLab.font = [UIFont systemFontOfSize:12];
        desLab.textColor = [UIColor colorWithHexString:@"#888888"];
        desLab.width = 50;
        desLab.height = 15;
        desLab.left = 0;
        desLab.bottom = 45;
        desLab.text = homePageRushGoodsTimeListItem.desc;
        
        //下方三角以及背景
        UIView* iconBg = [UIView new];
        iconBg.tag = 3;
        iconBg.hidden = YES;
        [cell addSubview:iconBg];
        iconBg.frame = CGRectMake(0, 50, cell.width, 10);
        iconBg.backgroundColor = kAppBackGroundColor;
        
        UIImageView* icon = [UIImageView new];
        icon.image = [UIImage imageNamed:@"下边三角"];
        [iconBg addSubview:icon];
        icon.frame = CGRectMake(0, 0, 24, 10);
        icon.top = -1;
        icon.centerX = cell.width * 0.5;
        
        
        [scrollView addSubview:cell];
        
        cell.left = left;
        cell.top = 0;
        
        left = cell.right + space;
        
        if(left > scrollView.width){
            scrollView.contentSize = CGSizeMake(left, scrollView.height);
        }
        
        if(homePageRushGoodsTimeListItem.check.intValue == 1){
            [self rushTimeBeginWithCell:cell];
        }else{
            [self unRushTimeBeginWithCell:cell];
        }
        
        //优化代码 如果是最后一个cell 优化当前抢购cell滑动的位置
        if(i == self.homePageModel.rush_goods.time_list.count -1){
            [self scrollRushTimeBeginCell];
        }
    }
    
    
    //三个抢购商品
    for(int i = 0; i < self.homePageModel.rush_goods.list.count; i++){
        HomePageRushGoodsListItem* homePageRushGoodsListItem = self.homePageModel.rush_goods.list[i];
        
        UIView* cell = [_rushThreeGoodsBgView viewWithTag:(10+i)];
        //图片
        UIImageView* icon = [cell viewWithTag:1];
        [icon sd_setImageWithURL:[NSURL URLWithString:homePageRushGoodsListItem.pict_url] placeholderImage:kPlaceHolderImg];
        //标题
        UILabel* titleLab = [cell viewWithTag:2];
        titleLab.text = homePageRushGoodsListItem.title;
        
        //进度 暂未处理
        UIView* sealCountBg = [cell viewWithTag:6];
        if(sealCountBg.subviews.count>0){
            for(UIView* subView in sealCountBg.subviews){
                [subView removeFromSuperview];
            }
        }
        
        SealCountView* sealCountView = [[SealCountView alloc]initWithFrame:CGRectMake(0, 0, cell.width, 20)];
        CGFloat coupon_remain_count = homePageRushGoodsListItem.coupon_remain_count.integerValue;
        CGFloat coupon_total_count = homePageRushGoodsListItem.coupon_total_count.integerValue;
        CGFloat ratio = coupon_remain_count / coupon_total_count;
        sealCountView.ratio = ratio;
        [sealCountBg addSubview:sealCountView];
        
        //新价格
        UILabel* newPriceLab = [cell viewWithTag:4];
        newPriceLab.text = homePageRushGoodsListItem.quanhou_price;
        
        UILabel* oldPriceLab = [cell viewWithTag:5];
        oldPriceLab.text = [NSString stringWithFormat:@"￥%@",homePageRushGoodsListItem.price];
    }
}


//传入抢购中cellBg（UIView） 改变背景色
-(void)rushTimeBeginWithCell:(UIView*)cell
{
    cell.backgroundColor = [UIColor colorWithHexString:@"#F54556"];//红色
    UILabel* timeLab = [cell viewWithTag:1];
    timeLab.textColor = [UIColor whiteColor];
    UILabel* desLab = [cell viewWithTag:2];
    desLab.textColor = [UIColor whiteColor];
    UIView* iconBg = [cell viewWithTag:3];
    iconBg.hidden = NO;
    
    //添加tap
    cell.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rushingViewTapAction:)];
    [cell addGestureRecognizer:tap];
}

-(void)unRushTimeBeginWithCell:(UIView*)cell
{
    cell.backgroundColor = [UIColor clearColor];
    UILabel* timeLab = [cell viewWithTag:1];
    timeLab.textColor = [UIColor colorWithHexString:@"#333333"];
    UILabel* desLab = [cell viewWithTag:2];
    desLab.textColor = [UIColor colorWithHexString:@"#888888"];
    UIView* iconBg = [cell viewWithTag:3];
    iconBg.hidden = YES;
    
    for(UIGestureRecognizer* ges in cell.gestureRecognizers){
        [cell removeGestureRecognizer:ges];
    }
}

-(void)scrollRushTimeBeginCell
{
    for(int i = 0; i < self.homePageModel.rush_goods.time_list.count; i++) {
         HomePageRushGoodsTimeListItem* homePageRushGoodsTimeListItem = self.homePageModel.rush_goods.time_list[i];
        if(homePageRushGoodsTimeListItem.check.intValue == 1){
            UIScrollView* scrollView = [self.rushBgView viewWithTag:288];
            UIView* cell = [scrollView viewWithTag:(10+i)];
            UILabel* timeLab = [cell viewWithTag:1];
            if([timeLab.text isEqualToString:@"20:00"] || [timeLab.text isEqualToString:@"17:00"]){
                CGFloat x = scrollView.contentSize.width - scrollView.width;
                scrollView.contentOffset = CGPointMake(x, 0);
            }
        }
    }
}

//马上抢 刷新tableview数据源
#pragma mark - control action
-(void)activityItemsBtnsAction:(UIButton*)btn
{
    if([LLUserManager shareManager].currentUser == nil){
        __weak HomeCarefullySelectViewController* wself = self;
        [Utility ShowAlert:@"尚未登录" message:@"\n是否登录" buttonName:@[@"好的,去登录",@"不用了,谢谢"] sureAction:^{
            LoginAndRigistMainVc* vc = [LoginAndRigistMainVc new];
            vc.hidesBottomBarWhenPushed = YES;
            [wself.navigationController pushViewController:vc animated:YES];
        } cancleAction:nil];
        return;
    }
    
    //UI tag
    NSInteger tag = btn.tag;
    
    //Model
   HomePageActivityModel* homePageActivityModel = [self.homePageModel.activity_list objectAtIndex:((int)tag-10)];
    
    //1 先判断url是否有值，如果有值 直接跳浏览器 不用本地处理了
    if(homePageActivityModel.url.length > 0){
        NSString* relationId = [LLUserManager shareManager].currentUser.relation_id;
        NSString* full_url_str = [NSString stringWithFormat:@"%@&relationId=%@",homePageActivityModel.url,relationId];
        WebViewViewController* vc = [[WebViewViewController alloc]initWithUrl:full_url_str title:homePageActivityModel.name];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        //跳转浏览器
        return;
    }
    
    //2 根据id跳转不同本地界面
    int activityId = homePageActivityModel.id.intValue;
    
    if(activityId == 1){ //爆款推荐
        HotRecommendViewController* vc = [[HotRecommendViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if(activityId == 2){ //9块9包邮
       NinePointNineViewController* vc = [NinePointNineViewController new];
       vc.hidesBottomBarWhenPushed = YES;
       [self.navigationController pushViewController:vc animated:YES];
    }
    if(activityId == 3){ //超级大牌
        SuperGoodViewController* vc = [SuperGoodViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if(activityId == 4){ //热销榜
        HotRankGoodViewController* vc = [[HotRankGoodViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if(activityId == 5){ //聚划算
        GoodDealViewController* vc = [GoodDealViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if(activityId == 6 || activityId == 7){ //天猫超市 天猫国际
        
//        TmallViewController* vc = [TmallViewController new];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
    }
    if(activityId == 8){
        TreasureGoodViewController* vc = [TreasureGoodViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if(activityId == 9){
        GaoYongViewController* vc = [GaoYongViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if(activityId == 12){//京东
//        [[LLHudHelper sharedInstance]tipMessage:@"600生活即将接入拼多多" delay:1.5];
        JDMainViewController* vc = [JDMainViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

//福利购
- (IBAction)fuliGou:(id)sender {
    
    if([LLUserManager shareManager].currentUser == nil){
        __weak HomeCarefullySelectViewController* wself = self;
        [Utility ShowAlert:@"尚未登录" message:@"\n是否登录" buttonName:@[@"好的,去登录",@"不用了,谢谢"] sureAction:^{
            LoginAndRigistMainVc* vc = [LoginAndRigistMainVc new];
            vc.hidesBottomBarWhenPushed = YES;
            [wself.navigationController pushViewController:vc animated:YES];
        } cancleAction:nil];
        return;
    }
    
    ExclusiveViewController* vc = [ExclusiveViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//万券齐发
- (IBAction)quanBtnAction:(id)sender {
    
    if([LLUserManager shareManager].currentUser == nil){
        __weak HomeCarefullySelectViewController* wself = self;
        [Utility ShowAlert:@"尚未登录" message:@"\n是否登录" buttonName:@[@"好的,去登录",@"不用了,谢谢"] sureAction:^{
            LoginAndRigistMainVc* vc = [LoginAndRigistMainVc new];
            vc.hidesBottomBarWhenPushed = YES;
            [wself.navigationController pushViewController:vc animated:YES];
        } cancleAction:nil];
        return;
    }
    
    WanJuanViewController* vc = [WanJuanViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


//品牌好店
- (IBAction)goodStoreBtnAction:(id)sender {
    self.tabBarController.selectedIndex = 2;
}

//好货严选更多
- (IBAction)bestGoodMoreBtnAction:(id)sender {
    
    if([LLUserManager shareManager].currentUser == nil){
        __weak HomeCarefullySelectViewController* wself = self;
        [Utility ShowAlert:@"尚未登录" message:@"\n是否登录" buttonName:@[@"好的,去登录",@"不用了,谢谢"] sureAction:^{
            LoginAndRigistMainVc* vc = [LoginAndRigistMainVc new];
            vc.hidesBottomBarWhenPushed = YES;
            [wself.navigationController pushViewController:vc animated:YES];
        } cancleAction:nil];
        return;
    }
    
    BestSelectMainViewController* vc = [BestSelectMainViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//好货严选，四个cell
- (IBAction)bestGoodItemBtnAction:(UIButton*)sender {
    
    if([LLUserManager shareManager].currentUser == nil){
        __weak HomeCarefullySelectViewController* wself = self;
        [Utility ShowAlert:@"尚未登录" message:@"\n是否登录" buttonName:@[@"好的,去登录",@"不用了,谢谢"] sureAction:^{
            LoginAndRigistMainVc* vc = [LoginAndRigistMainVc new];
            vc.hidesBottomBarWhenPushed = YES;
            [wself.navigationController pushViewController:vc animated:YES];
        } cancleAction:nil];
        return;
    }
    
    NSInteger index = sender.tag - 280;
    if(self.homePageModel.best_goods.count >= 4){
        HomePageBestGoodModel* homePageBestGoodModel = self.homePageModel.best_goods[index];
        NSString* item_id = homePageBestGoodModel.item_id;
        if(item_id){
            GoodDetailViewController* vc = [[GoodDetailViewController alloc]initWithItem_id:item_id];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [[LLHudHelper sharedInstance]tipMessage:@"商品数据异常"];
        }
    }
}

//热销榜排行全部
- (IBAction)allRankBtnAction:(id)sender {
    
    if([LLUserManager shareManager].currentUser == nil){
        __weak HomeCarefullySelectViewController* wself = self;
        [Utility ShowAlert:@"尚未登录" message:@"\n是否登录" buttonName:@[@"好的,去登录",@"不用了,谢谢"] sureAction:^{
            LoginAndRigistMainVc* vc = [LoginAndRigistMainVc new];
            vc.hidesBottomBarWhenPushed = YES;
            [wself.navigationController pushViewController:vc animated:YES];
        } cancleAction:nil];
        return;
    }
    
    HotRankGoodViewController* vc = [[HotRankGoodViewController alloc]initWithIsShowRankDesc:YES];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//热销榜排行前三
- (IBAction)rankBtnAction:(UIButton*)sender {
    
    if([LLUserManager shareManager].currentUser == nil){
        __weak HomeCarefullySelectViewController* wself = self;
        [Utility ShowAlert:@"尚未登录" message:@"\n是否登录" buttonName:@[@"好的,去登录",@"不用了,谢谢"] sureAction:^{
            LoginAndRigistMainVc* vc = [LoginAndRigistMainVc new];
            vc.hidesBottomBarWhenPushed = YES;
            [wself.navigationController pushViewController:vc animated:YES];
        } cancleAction:nil];
        return;
    }
    
    NSInteger index = sender.tag - 15;
    if(self.homePageModel.hot_goods.count >= 3){
        HomePageHotGoodModel* homePageHotGoodModel = [self.homePageModel.hot_goods objectAtIndex:index];
        if(homePageHotGoodModel.item_id){
            GoodDetailViewController* vc = [[GoodDetailViewController alloc]initWithItem_id:homePageHotGoodModel.item_id];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

//限时秒杀 更多
- (IBAction)rushGoodMoreBtnAction:(id)sender {
    
    if([LLUserManager shareManager].currentUser == nil){
        __weak HomeCarefullySelectViewController* wself = self;
        [Utility ShowAlert:@"尚未登录" message:@"\n是否登录" buttonName:@[@"好的,去登录",@"不用了,谢谢"] sureAction:^{
            LoginAndRigistMainVc* vc = [LoginAndRigistMainVc new];
            vc.hidesBottomBarWhenPushed = YES;
            [wself.navigationController pushViewController:vc animated:YES];
        } cancleAction:nil];
        return;
    }
    
    RushGoodsViewController* vc= [RushGoodsViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//限时秒杀 三个
- (IBAction)timelyBuyBtnAction:(UIButton*)sender {
    
    if([LLUserManager shareManager].currentUser == nil){
        __weak HomeCarefullySelectViewController* wself = self;
        [Utility ShowAlert:@"尚未登录" message:@"\n是否登录" buttonName:@[@"好的,去登录",@"不用了,谢谢"] sureAction:^{
            LoginAndRigistMainVc* vc = [LoginAndRigistMainVc new];
            vc.hidesBottomBarWhenPushed = YES;
            [wself.navigationController pushViewController:vc animated:YES];
        } cancleAction:nil];
        return;
    }
    
    NSInteger index = sender.tag - 10;
    if(self.homePageModel.rush_goods.list.count >=3){
        HomePageRushGoodsListItem* homePageRushGoodsListItem = self.homePageModel.rush_goods.list[index];
        if(homePageRushGoodsListItem.item_id){
            GoodDetailViewController* vc = [[GoodDetailViewController alloc]initWithItem_id:homePageRushGoodsListItem.item_id];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

//抢购中 图标
-(void)rushingViewTapAction:(UITapGestureRecognizer*)tap
{
    [self.tableview scrollRectToVisible:self.rushBgView.frame animated:YES];
}



#pragma mark - YMNoticeScrollViewDelegate

- (void)noticeScrollDidClickAtIndex:(NSInteger)index content:(NSString *)content
{
    if([LLUserManager shareManager].currentUser == nil){
        __weak HomeCarefullySelectViewController* wself = self;
        [Utility ShowAlert:@"尚未登录" message:@"\n是否登录" buttonName:@[@"好的,去登录",@"不用了,谢谢"] sureAction:^{
            LoginAndRigistMainVc* vc = [LoginAndRigistMainVc new];
            vc.hidesBottomBarWhenPushed = YES;
            [wself.navigationController pushViewController:vc animated:YES];
        } cancleAction:nil];
        return;
    }
    
    HomePageTopModel* homePageTopModel = self.homePageModel.top_list[index];
    if(homePageTopModel.item_id){
        GoodDetailViewController* vc = [[GoodDetailViewController alloc]initWithItem_id:homePageTopModel.item_id];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [[LLHudHelper sharedInstance]tipMessage:@"头条数据异常"];
    }
}


#pragma mark - tableview delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == _nowRushTableview){ //马上抢
        if(self.homePageModel.rush_goods_2.count >= 3){
            return 3;
        }
    }
    
    if(tableView == self.tableview){ //商品
        if(self.datasource.count > 0){
            return self.datasource.count;
        }
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _nowRushTableview){
        HomePageGoodTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HomePageRushGoodTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(self.homePageModel.rush_goods_2.count > 0){
            [cell fullData:self.homePageModel.rush_goods_2[indexPath.row]];
        }
        return cell;
    }
    
    if(tableView == self.tableview){
        HomePageGoodTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HomePageGoodTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(self.datasource.count > 0){
            [cell fullData:self.datasource[indexPath.row]];
        }
        return cell;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([LLUserManager shareManager].currentUser == nil){
        __weak HomeCarefullySelectViewController* wself = self;
        [Utility ShowAlert:@"尚未登录" message:@"\n是否登录" buttonName:@[@"好的,去登录",@"不用了,谢谢"] sureAction:^{
            LoginAndRigistMainVc* vc = [LoginAndRigistMainVc new];
            vc.hidesBottomBarWhenPushed = YES;
            [wself.navigationController pushViewController:vc animated:YES];
        } cancleAction:nil];
        return;
    }
    
    if(tableView == _nowRushTableview){
        HomePageRushGoods2ItemModel* homePageRushGoods2ItemModel = self.homePageModel.rush_goods_2[indexPath.row];
        if(homePageRushGoods2ItemModel.item_id){
            GoodDetailViewController* vc = [[GoodDetailViewController alloc]initWithItem_id:homePageRushGoods2ItemModel.item_id];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    if(tableView == self.tableview){
        HomePageGoodsListItemModel* homePageGoodsListItemModel = self.datasource[indexPath.row];
        if(homePageGoodsListItemModel.item_id){
            GoodDetailViewController* vc = [[GoodDetailViewController alloc]initWithItem_id:homePageGoodsListItemModel.item_id];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}


#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static CGFloat s_lastPosition = 0; //最后停留的位置
    int currentPostion = scrollView.contentOffset.y;
    
    if (currentPostion - s_lastPosition > 20  && currentPostion > 0) {
        s_lastPosition = currentPostion;
//        NSLog(@"手指上滑");
        if( currentPostion > self.rushBgViewTop ) {//当前位置大于rushBgView的y
            UIScrollView* rushScrollView = [self.rushBgView viewWithTag:288];
            if(![self.view viewWithTag:289]){//如果没有则添加
                [rushScrollView removeFromSuperview];
                [self.view addSubview:rushScrollView];
                rushScrollView.left = self.rushBgView.left;
                rushScrollView.tag = 289;
            }
        }
        
    } else if ((s_lastPosition - currentPostion > 20) && (currentPostion <= scrollView.contentSize.height-scrollView.bounds.size.height-20) ) {
        s_lastPosition = currentPostion;
//        NSLog(@"手指下滑");
 
        if( currentPostion < self.rushBgViewTop ) {//当前位置小于rushBgView的y
           UIScrollView* rushScrollView = [self.view viewWithTag:289];
            if([self.view viewWithTag:289]){ //如果有了则释放
                [rushScrollView removeFromSuperview];
                [self.rushBgView addSubview:rushScrollView];
                rushScrollView.tag = 288;
                rushScrollView.left = 0;
            }
        }
    }
    
    if(currentPostion > scrollView.height * 2){
        _backTopView.hidden = NO;
    }else{
        _backTopView.hidden = YES;
    }
}

#pragma mark - getter setter

-(NSCalendar*)calendar
{
    if(_calendar == nil){
        _calendar = [NSCalendar currentCalendar];
    }
    return _calendar;
}



#pragma mark - timer
-(void)initTimer
{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
        [_timer fire];
    }
}

-(void)deInitGlobalQueueTimer
{
    if(_timer){
        [_timer invalidate];
          _timer = nil;
    }
}

-(void)timerAction:(NSTimer*)timer
{
    //action在子线程中
    if (self.timerCounter > 0) {
        self.timerCounter--;
        __weak HomeCarefullySelectViewController* wself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDate* endDate = [NSDate dateWithTimeIntervalSince1970:wself.homePageModel.rush_goods.end_time.doubleValue];
            NSDate* nowDate = [NSDate date];
            
            //时分秒的格式
            NSCalendarUnit type = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            NSDateComponents *cmps = [wself.calendar components:type fromDate:nowDate toDate:endDate options:0];
//            NSLog(@"%ld小时%ld分钟%ld秒",cmps.hour, cmps.minute, cmps.second);
            
            NSString* hStr = [NSString stringWithFormat:@"%ld",cmps.hour];
            if(hStr.length == 1){
                hStr = [NSString stringWithFormat:@"0%@",hStr];
            }
            
            NSString* mStr = [NSString stringWithFormat:@"%ld",cmps.minute];
            if(mStr.length == 1){
                mStr = [NSString stringWithFormat:@"0%@",mStr];
            }
            
            NSString* sStr = [NSString stringWithFormat:@"%ld",cmps.second];
            if(sStr.length == 1){
                sStr = [NSString stringWithFormat:@"0%@",sStr];
            }
            wself.rushEndH.text = hStr;
            wself.rushEndM.text = mStr;
            wself.rushEndS.text = sStr;
        });
    } else if (self.timerCounter == 0) {
        [self deInitGlobalQueueTimer]; //析构timer
    }
}


#pragma mark - helper
-(void)addMJRefresh
{
    __weak HomeCarefullySelectViewController* wself = self;
    
    self.tableview.mj_header = [LLRefreshGifHeader headerWithRefreshingBlock:^{
        wself.isMJHeaderRefresh = YES; //重要代码
        
        //获取首页(精选)数据
        [wself requestGoodSelectDatas];
        //获取评论数据
        wself.pageIndex=1;
        [wself requestHomePageButtomListWithPageIndex:wself.pageIndex];
        [wself impactLight];
    }];
    
    self.tableview.mj_footer = [LLRefreshAutoGifFooter footerWithRefreshingBlock:^{
         wself.isMJFooterRefresh = YES;
        //获取评论数据
         wself.pageIndex++;
         [wself requestHomePageButtomListWithPageIndex:wself.pageIndex];
        [wself impactLight];
    }];
    [self.tableview.mj_header beginRefreshing];
}

@end
