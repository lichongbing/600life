//
//  JDGoodDetailViewController.m
//  600生活
//
//  Created by iOS on 2020/1/6.
//  Copyright © 2020 灿男科技. All rights reserved.
//

#import "JDGoodDetailViewController.h"
#import "KHAdView.h"  //图片广告轮播
#import "SPButton.h"
#import "SimilarGoodView.h" //相似商品
#import "JDGood.h" //京东商品模型
#import "JDTwoItemGoodTableViewCell.h" //

#import "LLTabBarController.h"
#import "WebViewViewController.h" //
#import "ShareGoodViewController.h"
#import "LLWindowTipView.h"
#import "ShareGoodViewController.h"
#import "InviteCodeViewController.h"  //邀请码
#import "BackTopView.h"//返回顶部

@interface JDGoodDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *navBackImageView;
@property (weak, nonatomic) IBOutlet UIButton *navBackBtn;
@property (weak, nonatomic) IBOutlet UIView *toolBar;
@property (weak, nonatomic) IBOutlet SPButton *collectBtn; //收藏按钮
@property (weak, nonatomic) IBOutlet SPButton *quanBtn; //领券按钮

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet LLBaseView *layoutBottomLine;//headerView 最后一个line

//下方工具栏 底部
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolBarBottomConstraint;

//广告
@property (weak, nonatomic) IBOutlet KHAdView *adView;

//商品信息
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *newpriceLab;
@property (weak, nonatomic) IBOutlet UILabel *oldpriceLab;
@property (weak, nonatomic) IBOutlet UILabel *sellCountLab;
@property (weak, nonatomic) IBOutlet SPButton *youBtn;
@property (weak, nonatomic) IBOutlet SPButton *yunBtn;
@property (weak, nonatomic) IBOutlet UILabel *incomeLab;

//商家信息
@property (weak, nonatomic) IBOutlet UIImageView *sellerIcon;
@property (weak, nonatomic) IBOutlet UILabel *sellerNameLab;
@property (weak, nonatomic) IBOutlet UIImageView *sellerTypeLab;

@property (weak, nonatomic) IBOutlet SPButton *sellerGoodDesLab; //宝贝描述
@property (weak, nonatomic) IBOutlet SPButton *sellerServerLab;  //商家服务
@property (weak, nonatomic) IBOutlet SPButton *sellerCarServerLab; //商家物流


//相似推荐  smilar_goods
@property (weak, nonatomic) IBOutlet UIView *similarBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *similarBgViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *similarScrollView;

//宝贝详情
@property (weak, nonatomic) IBOutlet UILabel *noGoodTreasureLab; //暂无详情
@property (weak, nonatomic) IBOutlet UIView *goodTreasureBgView;
@property (weak, nonatomic) IBOutlet UIView *imagesBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imagesBgViewHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodTreasureBgViewHeightConstraint;

@property(nonatomic,strong) BackTopView* backTopView; //返回顶部


@property(nonatomic,strong)NSString* item_id;
@property(nonatomic,strong)JDGood* jdGood;//商品模型

@end

@implementation JDGoodDetailViewController

-(void)dealloc
{
    NSLog(@"京东商品详情被释放");
}

-(id)initWithItem_id:(NSString*)item_id
{
    if(self = [super init]){
        self.item_id = item_id;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    __weak JDGoodDetailViewController* wself = self;
       _layoutBottomLine.viewDidLayoutNewFrameCallBack = ^(CGRect newFrame) {
           wself.contentView.height = newFrame.origin.y + newFrame.size.height;
           wself.tableview.tableHeaderView = wself.contentView;
       };
       
       self.tableview.showsVerticalScrollIndicator = NO;
       self.tableview.height = kScreenHeight - kIPhoneXHomeIndicatorHeight - 50;
       self.tableview.tableHeaderView = self.contentView;
       self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
       self.tableview.delegate = (id)self;
       self.tableview.dataSource = (id)self;
       [self.tableview registerNib:[UINib nibWithNibName:@"JDTwoItemGoodTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDTwoItemGoodTableViewCell"];
       
       //下面三个会因tableview的懒加载挡住
       [self.view bringSubviewToFront:self.navBackImageView];
       [self.view bringSubviewToFront:self.navBackBtn];
       [self.view bringSubviewToFront:self.toolBar];
       
       
       [self requestJDGoodDetail];
       
       [self addBackToTopView];
}

#pragma mark - 网络请求
-(void)requestJDGoodDetail
{
    NSString* urlStr = [NSString stringWithFormat:@"%@/%@",kFullUrl(kJDGoodDetail),self.item_id];
  
    __weak JDGoodDetailViewController* wself = self;
    
    [self GetWithUrlStr:urlStr param:nil showHud:YES resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes){
            [wself handleJDGoodDetail:res[@"data"]];
        }
    } falsed:^(NSError * _Nullable error) {
       
    }];
}

-(void)handleJDGoodDetail:(NSDictionary*)data
{
    NSError* err = nil;
//    GoodModel* goodModel = [[GoodModel alloc]initWithDictionary:data error:&err];
//    NSArray* smilar_goods = goodModel.smilar_goods;
//    NSMutableArray* mutArr = [NSMutableArray new];
//
//     //相似商品
//    for(int i = 0; i < smilar_goods.count; i++){
//        err = nil;
//        SmilarGoodModel* smilarGoodModel = [[SmilarGoodModel alloc]initWithDictionary:smilar_goods[i] error:&err];
//        if(smilarGoodModel){
//            [mutArr addObject:smilarGoodModel];
//        }
//    }
//    goodModel.smilar_goods = mutArr;
//
//    //今日热销 TodayHotGoodModel
//    NSArray* today_hot_goods = goodModel.today_hot_goods;
//    mutArr = [NSMutableArray new];
//      for(int i = 0; i < today_hot_goods.count; i++){
//          err = nil;
//          TodayHotGoodModel* todayHotGoodModel = [[TodayHotGoodModel alloc]initWithDictionary:today_hot_goods[i] error:&err];
//          if(todayHotGoodModel){
//              [mutArr addObject:todayHotGoodModel];
//          }
//      }
//    goodModel.today_hot_goods = mutArr;
//    self.goodModel = goodModel;
//    __weak GoodDetailViewController* wself = self;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [wself resetupUI];
//    });
}


#pragma mark - helper
-(void)addBackToTopView
{
    _backTopView = [[BackTopView alloc]init];
    [self.view bringSubviewToFront:_backTopView];
    _backTopView.right = kScreenWidth - 20;
    _backTopView.bottom = kScreenHeight - kIPhoneXHomeIndicatorHeight - self.toolBar.height;
    [self.view addSubview:_backTopView];

    
    __weak JDGoodDetailViewController* wself = self;
    _backTopView.backTopViewClickedCallBack = ^{
        __strong JDGoodDetailViewController* sself = wself;
           [UIView animateWithDuration:0.3 animations:^{
               sself.tableview.contentOffset = CGPointMake(0, 0);
           }];
    };
}

-(void)goTopBtnAction:(UIButton*)btn
{
    __weak JDGoodDetailViewController* wself = self;
    [UIView animateWithDuration:0.3 animations:^{
        wself.tableview.contentOffset = CGPointMake(0, 0);
    }];
}

@end
