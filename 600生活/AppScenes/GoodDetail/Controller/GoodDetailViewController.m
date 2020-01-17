//
//  GoodDetailViewController.m
//  600生活
//
//  Created by iOS on 2019/11/11.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "GoodDetailViewController.h"
#import "KHAdView.h"  //图片广告轮播
#import "SPButton.h"

#import "GoodModel.h"
#import "SimilarGoodView.h" //相似商品

#import "GoodDetailHotGoodCell.h" //今日热销 使用了首页猜你喜欢的cell
#import "GuessLikeGoodModel.h" //使用了首页猜你喜欢的模型

#import "LLTabBarController.h"

#import "WebViewViewController.h" //

#import <AlibcTradeSDK/AlibcTradeSDK.h>

#import "LLWindowTipView.h"
#import "ShareGoodViewController.h"
#import "InviteCodeViewController.h"  //邀请码
#import "BackTopView.h"//返回顶部

@interface GoodDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>


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
@property(nonatomic,strong)GoodModel* goodModel;//商品模型

@end

@implementation GoodDetailViewController


-(void)dealloc
{
    NSLog(@"商品详情被释放");
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
    
    self.fd_prefersNavigationBarHidden = YES;
    
    // Do any additional setup after loading the view from its nib.
    
    __weak GoodDetailViewController* wself = self;
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
    [self.tableview registerNib:[UINib nibWithNibName:@"GoodDetailHotGoodCell" bundle:nil] forCellReuseIdentifier:@"GoodDetailHotGoodCell"];
    
    //下面三个会因tableview的懒加载挡住
    [self.view bringSubviewToFront:self.navBackImageView];
    [self.view bringSubviewToFront:self.navBackBtn];
    [self.view bringSubviewToFront:self.toolBar];
    
    
    [self requestGoodDetail];
    
    [self addBackToTopView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //检查是app否变活跃 绑定淘宝之后回调
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appDidBecomeActiveNofificationAction:) name:kAppDidBecomeActiveNofification object:nil];
}


-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    if(kIsIOS13()){
         return UIStatusBarStyleDarkContent;
    }else{
        return UIStatusBarStyleDefault; //黑色文字
    }
}

-(void)addBackToTopView
{
    _backTopView = [[BackTopView alloc]init];
    [self.view bringSubviewToFront:_backTopView];
    _backTopView.right = kScreenWidth - 20;
    _backTopView.bottom = kScreenHeight - kIPhoneXHomeIndicatorHeight - self.toolBar.height;
    [self.view addSubview:_backTopView];

    
    __weak GoodDetailViewController* wself = self;
    _backTopView.backTopViewClickedCallBack = ^{
        __strong GoodDetailViewController* sself = wself;
           [UIView animateWithDuration:0.3 animations:^{
               sself.tableview.contentOffset = CGPointMake(0, 0);
           }];
    };
}

-(void)goTopBtnAction:(UIButton*)btn
{
    __weak GoodDetailViewController* wself = self;
    [UIView animateWithDuration:0.3 animations:^{
        wself.tableview.contentOffset = CGPointMake(0, 0);
    }];
}

#pragma mark - 网络请求
-(void)requestGoodDetail
{
    NSString* urlStr = [NSString stringWithFormat:@"%@/%@",kFullUrl(kGetGoodDetail),self.item_id];
  
    __weak GoodDetailViewController* wself = self;
    
    [self GetWithUrlStr:urlStr param:nil showHud:YES resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes){
            [wself handleGoodDetail:res[@"data"]];
        }
    } falsed:^(NSError * _Nullable error) {
       
    }];
}


-(void)handleGoodDetail:(NSDictionary*)data
{
    NSError* err = nil;
    GoodModel* goodModel = [[GoodModel alloc]initWithDictionary:data error:&err];
    NSArray* smilar_goods = goodModel.smilar_goods;
    NSMutableArray* mutArr = [NSMutableArray new];
    
     //相似商品
    for(int i = 0; i < smilar_goods.count; i++){
        err = nil;
        SmilarGoodModel* smilarGoodModel = [[SmilarGoodModel alloc]initWithDictionary:smilar_goods[i] error:&err];
        if(smilarGoodModel){
            [mutArr addObject:smilarGoodModel];
        }
    }
    goodModel.smilar_goods = mutArr;
    
    //今日热销 TodayHotGoodModel
    NSArray* today_hot_goods = goodModel.today_hot_goods;
    mutArr = [NSMutableArray new];
      for(int i = 0; i < today_hot_goods.count; i++){
          err = nil;
          TodayHotGoodModel* todayHotGoodModel = [[TodayHotGoodModel alloc]initWithDictionary:today_hot_goods[i] error:&err];
          if(todayHotGoodModel){
              [mutArr addObject:todayHotGoodModel];
          }
      }
    goodModel.today_hot_goods = mutArr;
    self.goodModel = goodModel;
    __weak GoodDetailViewController* wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [wself resetupUI];
    });
}


//收藏商品
-(void)requestWillCollectGood:(NSString*)goodId
{
    NSDictionary* param = @{
        @"id":goodId
    };
  
    __weak GoodDetailViewController* wself = self;
    
    [self PostWithUrlStr:kFullUrl(kWillCollectGood) param:param showHud:YES resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes){
            [wself handleWillCollectGood:res[@"data"]];
        }
    } falsed:^(NSError * _Nullable error) {
       
    }];
}


-(void)handleWillCollectGood:(NSDictionary*)data
{
    self.goodModel.is_collect = [NSNumber numberWithInt:1];
    [[LLHudHelper sharedInstance]tipMessage:@"收藏成功"];
    __weak GoodDetailViewController* wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [wself.collectBtn setTitle:@"已收藏" forState:UIControlStateNormal];
        [wself.collectBtn setImage:[UIImage imageNamed:@"已收藏"] forState:UIControlStateNormal];
    });
}

//获取用户数据 主要是为了拿到relationId
-(void)requestGetUserInfo
{
    __weak GoodDetailViewController* wself = self;
    [self GetWithUrlStr:kFullUrl(kGetUserInfo) param:nil showHud:YES resCache:^(id  _Nullable cacheData) {
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
    LLUser* tempUser = [[LLUser alloc]initWithDictionary:data error:nil];
    if(tempUser.relation_id.length > 0){
        [LLUserManager shareManager].currentUser.relation_id = tempUser.relation_id;
    }
}

//取消收藏商品罗海方
//kWillUnCollectGood
-(void)requestWillCancelCollectGood:(NSString*)goodId
{
    NSDictionary* param = @{
        @"id":goodId
    };
  
    __weak GoodDetailViewController* wself = self;
    
    [[LLNetWorking sharedWorking]Delete:kFullUrl(kWillUnCollectGood) param:param success:^(id  _Nonnull res) {
        if(kSuccessRes){
            [wself handleWillCancelCollectGood:res[@"data"]];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

-(void)handleWillCancelCollectGood:(NSDictionary*)data
{
    self.goodModel.is_collect = [NSNumber numberWithInt:0];
    [[LLHudHelper sharedInstance]tipMessage:@"已取消收藏"];
    __weak GoodDetailViewController* wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [wself.collectBtn setTitle:@"未收藏" forState:UIControlStateNormal];
        [wself.collectBtn setImage:[UIImage imageNamed:@"未收藏"] forState:UIControlStateNormal];
    });
}

#pragma mark - UI

-(void)resetupUI
{
    [self loading];
    
    //广告
    if(self.goodModel.small_images){
        [self resetupAdView];
    }
    
    //商品信息
    [self resetupGoodInfo];
    
    //商家详情
    [self resetupSellerInfo];
    
    //相似推荐
    if(self.goodModel.smilar_goods.count > 0){
        [self resetupSmilarGoods];
    }else{
         _similarBgViewHeightConstraint.constant = 0;
        [_similarBgView setNeedsLayout];
    }
    
    //宝贝详情
    if(self.goodModel.pcDescContent.count > 0){
        self.noGoodTreasureLab.hidden = YES;
        [self resetupGoodTreasure];
    }else{
        self.noGoodTreasureLab.hidden = NO;
        _goodTreasureBgViewHeightConstraint = 0;
        [_goodTreasureBgView setNeedsLayout];
    }
    
    //是否已收藏
    BOOL isCollect = self.goodModel.is_collect.intValue == 1;
    if(isCollect){
        [self.collectBtn setTitle:@"已收藏" forState:UIControlStateNormal];
        [self.collectBtn setImage:[UIImage imageNamed:@"已收藏"] forState:UIControlStateNormal];
    }else{
        [self.collectBtn setTitle:@"未收藏" forState:UIControlStateNormal];
        [self.collectBtn setImage:[UIImage imageNamed:@"未收藏"] forState:UIControlStateNormal];
    }
    
    //领券
    BOOL hasCoupon = self.goodModel.coupon_money.floatValue > 0;
    if(hasCoupon){
        [self.quanBtn setTitle:[NSString stringWithFormat:@" 领券￥%@",self.goodModel.coupon_money] forState:UIControlStateNormal];
    }else{
        [self.quanBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    }
    
    [self.view layoutIfNeeded];
    
    //热门商品
    for(int i = 0; i < self.goodModel.today_hot_goods.count; i++){
        self.datasource = self.goodModel.today_hot_goods;
        [self.tableview reloadData];
    }
    
    [self stopLoading];
}


//广告
-(void)resetupAdView
{
    [self.adView setUpOnlineImagesWithSource:self.goodModel.small_images PlaceHolder:kPlaceHolderImg ClickHandler:^(NSInteger index, NSString *imgSrc, UIImage *img) {
    }];
}

//商品信息
-(void)resetupGoodInfo
{
    self.typeLab.layer.borderWidth = 1;
       self.typeLab.layer.borderColor = self.typeLab.textColor.CGColor;
    
    self.typeLab.text = [self.goodModel.user_type isEqualToString:@"0"] ? @" 淘宝 " : @" 天猫 ";
    
    self.titleLab.text = self.goodModel.title;
    self.newpriceLab.text = self.goodModel.quanhou_price;
    self.oldpriceLab.text = [NSString stringWithFormat:@"原价%@",self.goodModel.price];
    self.incomeLab.text = [NSString stringWithFormat:@" 预计收益%.2f元 ",self.goodModel.earnings.floatValue];
    self.sellCountLab.text = [NSString stringWithFormat:@"已售%@件",self.goodModel.all_sell_count];
    self.yunBtn.hidden = ![self.goodModel.yunfeixian isEqualToString:@"1"];
}

//商家信息
-(void)resetupSellerInfo
{
    NSString* sellerIconUrlStr = self.goodModel.shop_icon;
    NSURL * url = [NSURL URLWithString:sellerIconUrlStr];
    [self.sellerIcon sd_setImageWithURL:url placeholderImage:kPlaceHolderImg];
   
    self.sellerNameLab.text = self.goodModel.shop_title;
    
    if([self.typeLab.text isEqualToString:@" 天猫 "]){
        self.sellerTypeLab.image = [UIImage imageNamed:@"good_icon_tm"];
    }else{
        self.sellerTypeLab.image = [UIImage imageNamed:@"good_icon_tb"];
    }
    
    
    
    NSString* score1 = [NSString stringWithFormat:@"商品描述:%@ ",self.goodModel.score1];
    NSString* const1 = [self getConstStoreDesWithScore:self.goodModel.score1];
    NSString* str1 = [NSString stringWithFormat:@"%@%@",score1,const1];
    NSRange range1 = [str1 rangeOfString:const1];
    NSMutableAttributedString* mutStr1 = [[NSMutableAttributedString alloc]initWithString:str1];
    [mutStr1 addAttribute:NSBackgroundColorAttributeName value:[self getColorWithScroe:self.goodModel.score1] range:range1];
    [mutStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:range1];
    [mutStr1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:range1];
    [self.sellerGoodDesLab setAttributedTitle:mutStr1 forState:UIControlStateNormal];
    
    NSString* score2 = [NSString stringWithFormat:@"卖家服务:%@ ",self.goodModel.score2];
    NSString* const2 = [self getConstStoreDesWithScore:self.goodModel.score2];
    NSString* str2 = [NSString stringWithFormat:@"%@%@",score2,const2];
    NSRange range2 = [str2 rangeOfString:const2];
    NSMutableAttributedString* mutStr2 = [[NSMutableAttributedString alloc]initWithString:str2];
    [mutStr2 addAttribute:NSBackgroundColorAttributeName value:[self getColorWithScroe:self.goodModel.score2] range:range2];
    [mutStr2 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:range2];
    [mutStr2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:range2];
    [self.sellerServerLab setAttributedTitle:mutStr2 forState:UIControlStateNormal];
    
    NSString* score3 = [NSString stringWithFormat:@"物流服务:%@ ",self.goodModel.score3];
    NSString* const3 = [self getConstStoreDesWithScore:self.goodModel.score3];
    NSString* str3 = [NSString stringWithFormat:@"%@%@",score3,const3];
    NSRange range3 = [str3 rangeOfString:const3];
    NSMutableAttributedString* mutStr3 = [[NSMutableAttributedString alloc]initWithString:str3];
    [mutStr3 addAttribute:NSBackgroundColorAttributeName value:[self getColorWithScroe:self.goodModel.score3] range:range3];
    [mutStr3 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:range3];
    [mutStr3 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:range3];
    [self.sellerCarServerLab setAttributedTitle:mutStr3 forState:UIControlStateNormal];
}

-(NSString*)getConstStoreDesWithScore:(NSString*)score
{
    if(score.doubleValue > 4.80){
        return @" 高 ";
    } else if (score.doubleValue == 4.80){
        return @" 中 ";
    } else if (score.doubleValue < 4.80){
        return @" 低 ";
    }
    return nil;
}

-(UIColor*)getColorWithScroe:(NSString*)score
{
    if(score.doubleValue > 4.8){
        return [UIColor colorWithHexString:@"#F54556"];
    } else if (score.doubleValue == 4.8){
        return [UIColor colorWithHexString:@"#666666"];
    } else if (score.doubleValue < 4.8){
        return [UIColor colorWithHexString:@"#6AB45E"];
    }
    return nil;
}

//相似推荐
-(void)resetupSmilarGoods
{
    _similarScrollView.showsHorizontalScrollIndicator = NO;
    CGFloat controlLeft = 10;
    CGFloat controlSpace = 10;
    
    //删除旧图
    for(int i = 0; i < self.similarScrollView.subviews.count; i++){
        UIView* subView = [self.similarScrollView.subviews objectAtIndex:i];
        if(subView){
            [subView removeFromSuperview];
            subView = nil;
        }
    }
    
    for(int i = 0; i < self.goodModel.smilar_goods.count; i++){
        SmilarGoodModel* smilarGoodModel = self.goodModel.smilar_goods[i];
        SimilarGoodView* similarGoodView = [[SimilarGoodView alloc]init];
        similarGoodView.top = 0;
        similarGoodView.left = controlLeft;
        [similarGoodView fullData:smilarGoodModel];
        controlLeft = similarGoodView.right + controlSpace;
        [_similarScrollView addSubview:similarGoodView];
        
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [similarGoodView addSubview:btn];
        btn.frame = CGRectMake(0, 0, similarGoodView.width, similarGoodView.height);
        [btn addTarget:self action:@selector(similarGoodBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 10+i;
        
        
        if(i == self.goodModel.smilar_goods.count - 1){
            _similarScrollView.contentSize = CGSizeMake(similarGoodView.right + controlSpace, _similarScrollView.height);
        }
    }
}

-(void)resetupGoodTreasure
{
    __block CGFloat b_imagesBgViewContentHeight = 0;//图片背景高度
    
    for(int i = 0; i < self.goodModel.pcDescContent.count; i++){
        
        
        NSString* halfStr = self.goodModel.pcDescContent[i];
        NSString* fullStr = [NSString stringWithFormat:@"https:%@",halfStr];
        UIImageView* imageView = [[UIImageView alloc]init];
        [_imagesBgView addSubview:imageView];
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        imageView.tag = 100 + i;
        
        //width
         __block NSLayoutConstraint* b_widthCon = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kScreenWidth];
         [imageView addConstraint:b_widthCon];
         
         //height 是0
         __block NSLayoutConstraint* b_heightCon = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
         [imageView addConstraint:b_heightCon];
         
         //top 根据父视图(i==0)或者兄弟视图(i>0)计算
         NSLayoutConstraint* topCon = nil;
         if(i == 0){
             //父子视图
             topCon = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.imagesBgView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
             [self.imagesBgView addConstraint:topCon];
         } else {
             //兄弟视图
             UIView* previousView = [self.imagesBgView viewWithTag:(100+i-1)];
             topCon = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
             [self.imagesBgView addConstraint:topCon];
         }
        
         //left是0
         NSLayoutConstraint* leftCon = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.imagesBgView attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
         [self.imagesBgView addConstraint:leftCon];
         
         __weak GoodDetailViewController* wself = self;
         [imageView sd_setImageWithURL:[NSURL URLWithString:fullStr] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
             
             if(image == nil) {
                 return;
             }
             
             CGFloat imageViewNewHeight = b_widthCon.constant * image.size.height / image.size.width;
             
             NSLayoutConstraint* new_heightCon = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:imageViewNewHeight];
             [imageView removeConstraint:b_heightCon];
             [imageView addConstraint:new_heightCon];
             
             b_imagesBgViewContentHeight = b_imagesBgViewContentHeight + imageViewNewHeight;
             //替换imageBg高度约束
             if(wself){ //wself 可能为nil
                 NSLayoutConstraint* newImageBgViewHeightCons = [NSLayoutConstraint constraintWithItem:wself.imagesBgView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:b_imagesBgViewContentHeight];
                 [wself.imagesBgView removeConstraint:wself.imagesBgViewHeightCons];
                 [wself.imagesBgView addConstraint:newImageBgViewHeightCons];
                 wself.goodTreasureBgViewHeightConstraint.constant = 50 + b_imagesBgViewContentHeight;
                 
                 [wself.layoutBottomLine setNeedsLayout];
             }
         }];
    }
}

#pragma mark - control action

//leftItem被点击
- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//商家被点击
- (IBAction)sellerBtnAction:(id)sender {
    NSString* relationId = [LLUserManager shareManager].currentUser.relation_id;
    if(!(relationId.length > 0)){
        [Utility ShowAlert:@"未绑定淘宝" message:@"\n淘宝授权后可领取优惠券" buttonName:@[@"好的,马上绑定",@"不用了,谢谢"] sureAction:^{
            [self requestTaobaoAuth];
        } cancleAction:^{
        }];
        return;
    }
    
     NSString* fullUrlStr = [NSString stringWithFormat:@"%@&relationId=%@",self.goodModel.shop_url,relationId];
    NSURL* url = [NSURL URLWithString:fullUrlStr];
    
    if(url){
        WebViewViewController* vc = [[WebViewViewController alloc]initWithUrl:self.goodModel.shop_url title:@"店铺详情"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [[LLHudHelper sharedInstance]tipMessage:@"数据异常"];
    }
}


//返回首页
- (IBAction)homeBtnAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        LLTabBarController* tabbar = [LLTabBarController sharedController];
        if(tabbar.selectedIndex != 0){
            tabbar.selectedIndex = 0;
        }
    });
}


//相似商品点击
-(void)similarGoodBtnAction:(UIButton*)similarGoodBtn
{
    int index = (int)similarGoodBtn.tag - 10;
    SmilarGoodModel* smilarGoodModel = self.goodModel.smilar_goods[index];
    if(smilarGoodModel.item_id){
        GoodDetailViewController* vc = [[GoodDetailViewController alloc]initWithItem_id:smilarGoodModel.item_id];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//用户收藏/取消收藏商品
- (IBAction)collectBtnAction:(UIButton*)sender {
    BOOL isCollect = self.goodModel.is_collect.intValue == 1;
    if(isCollect){
        //取消收藏
        [self requestWillCancelCollectGood:self.goodModel.item_id];
    }else{
        //收藏
        if(self.goodModel.item_id){
            [self requestWillCollectGood:self.goodModel.item_id];
        }else{
            [[LLHudHelper sharedInstance]tipMessage:@"数据异常"];
        }
    }
}


//分享
- (IBAction)shareBtnAction:(id)sender {
    
    NSString* tkl = self.goodModel.tkl;
    NSString* invite_code = [LLUserManager shareManager].currentUser.invite_code;
    
    if(!tkl || tkl.length == 0){
        [[LLHudHelper sharedInstance]tipMessage:@"商品无淘口令,无法分享"];
        return;
    }
    
    if(!invite_code || invite_code.length == 0){
        //无邀请码
        [Utility ShowAlert:@"未填写邀请码" message:@"\n未填写上级邀请码,是否填写" buttonName:@[@"好的,去填写",@"不用了,谢谢"] sureAction:^{
            InviteCodeViewController* vc = [[InviteCodeViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } cancleAction:nil];
        return;
    }
    
    ShareGoodViewController* vc = [[ShareGoodViewController alloc]initWithTKL:self.goodModel.tkl inviteCode:invite_code];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//领券
- (IBAction)quanBtnAction:(id)sender {
    
    NSString* relationId = [LLUserManager shareManager].currentUser.relation_id;
    if(!(relationId.length > 0)){
        [Utility ShowAlert:@"未绑定淘宝" message:@"\n淘宝授权后可领取优惠券" buttonName:@[@"好的,马上绑定",@"不用了,谢谢"] sureAction:^{
            [self requestTaobaoAuth];
        } cancleAction:^{
        }];
        return;
    }
    
    
     __block LLWindowTipView* llwindowTipView = [[LLWindowTipView alloc]initWithType:WindowTipViewTypeTaoBao];
     llwindowTipView.income = self.goodModel.earnings.toString;
     [llwindowTipView show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [llwindowTipView dismiss];
        
        NSString* fullUrlStr = [NSString stringWithFormat:@"%@&relationId=%@",self.goodModel.coupon_share_url,relationId];
        
        //百川sdk方式打开
        AlibcTradeShowParams* showParam = [[AlibcTradeShowParams alloc]init];
           showParam.openType = AlibcOpenTypeAuto;//打开方式自动打开
           showParam.isNeedPush = YES;
           showParam.linkKey = @"taobao"; //优先拉起手机淘宝
        
        [[AlibcTradeSDK sharedInstance].tradeService openByUrl:fullUrlStr identity:@"trade" webView:nil parentController:self.navigationController showParams:showParam taoKeParams:nil trackParam:nil tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
            NSLog(@"%@",result);
        } tradeProcessFailedCallback:^(NSError * _Nullable error) {
            NSLog(@"%@",error);
        }];
    });
}

#pragma mark - tableview delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray* mutArr = [NSMutableArray new];
    for(int i = 0; i < self.datasource.count; i++){//self.datasource.count/2 是整数
        NSMutableArray* item = [NSMutableArray new];
        if(i%2 == 0) {
            //基数个 左边model
            GuessLikeGoodModel* modelLeft = nil;
            if(self.datasource.count > i){
                modelLeft = self.datasource[i];
            }else{
                modelLeft = [GuessLikeGoodModel new];
            }
            
            GuessLikeGoodModel* modelRight = nil;
            if(self.datasource.count > (i+1)){
                modelRight = self.datasource[i+1];
            }else{
                modelRight = [GuessLikeGoodModel new];
            }
            
            [item addObject:modelLeft];
            [item addObject:modelRight];
            [mutArr addObject:item];
        }
    }
    return mutArr.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodDetailHotGoodCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GoodDetailHotGoodCell" forIndexPath:indexPath];
    
    NSMutableArray* mutArr = [NSMutableArray new];
    for(int i = 0; i < self.datasource.count; i++){//self.datasource.count/2 是整数
        NSMutableArray* item = [NSMutableArray new];
        if(i%2 == 0) {
           //基数个
            TodayHotGoodModel* modelLeft = nil;
            if(self.datasource.count > i){
                modelLeft = self.datasource[i];
            }else{
                modelLeft = [TodayHotGoodModel new];
            }
            
            TodayHotGoodModel* modelRight = nil;
            if(self.datasource.count > (i+1)){
                modelRight = self.datasource[i+1];
            }else{
                modelRight = [TodayHotGoodModel new];
            }
            
            [item addObject:modelLeft];
            [item addObject:modelRight];
            [mutArr addObject:item];
        }
    }
    
    NSArray* item = mutArr[indexPath.row];
    
    [cell fullDataWithLeftModel:item.firstObject rightModel:item.lastObject];
    
    __weak GoodDetailViewController* wself = self;
    cell.goodDetailHotGoodClickedCallback = ^(TodayHotGoodModel * _Nonnull todayHotGoodModel) {
        if(todayHotGoodModel.item_id){
            GoodDetailViewController* vc = [[GoodDetailViewController alloc]initWithItem_id:todayHotGoodModel.item_id];
            vc.hidesBottomBarWhenPushed = YES;
            [wself.navigationController pushViewController:vc animated:YES];
        }
    };
    return cell;
}



#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static CGFloat s_lastPosition = 0; //最后停留的位置
    int currentPostion = scrollView.contentOffset.y;
    
    if (currentPostion - s_lastPosition > 20  && currentPostion > 0) {
        s_lastPosition = currentPostion;
        NSLog(@"手指上滑");
        _navBackImageView.hidden = YES;
        _navBackBtn.hidden = YES;
        
    } else if ( (s_lastPosition - currentPostion > 20) && (currentPostion <= scrollView.contentSize.height-scrollView.bounds.size.height-20) ) {
        s_lastPosition = currentPostion;
         NSLog(@"手指下滑");
        _navBackImageView.hidden = NO;
        _navBackBtn.hidden = NO;
    }
    
   if(currentPostion > scrollView.height * 2){
        _backTopView.hidden = NO;
    }else{
        _backTopView.hidden = YES;
    }
}


#pragma mark - helper
//1002授权失败 1-成功
//淘宝授权
-(void)requestTaobaoAuth
{
    __weak GoodDetailViewController* wself = self;
    [self GetWithUrlStr:kFullUrl(kTbAuth) param:nil showHud:YES resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes){
            [wself handleTaobaoAuth:res[@"data"]];
        }
    } falsed:^(NSError * _Nullable error) {
        
    }];
}

-(void)handleTaobaoAuth:(NSString*)urlStr
{
    __weak GoodDetailViewController* wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        WebViewViewController* vc = [[WebViewViewController alloc]initWithUrl:urlStr title:@"淘宝授权"];
        vc.isNeedJS = YES;
        vc.hidesBottomBarWhenPushed = YES;
        [wself.navigationController pushViewController:vc animated:YES];
    });
}

#pragma mark - 通知
//app 变活跃 拿取relationid
-(void)appDidBecomeActiveNofificationAction:(NSNotification*)notification
{
    BOOL islogin = [LLUserManager shareManager].currentUser.isLogin;
    if (islogin) {
          [self requestGetUserInfo];
    }
}

@end
