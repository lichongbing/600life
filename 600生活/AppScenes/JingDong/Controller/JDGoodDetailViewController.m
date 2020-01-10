//
//  GoodDetailViewController.m
//  600生活
//
//  Created by iOS on 2019/11/11.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "JDGoodDetailViewController.h"
#import "KHAdView.h"  //图片广告轮播
#import "SPButton.h"

#import "JDGoodDetailModel.h" //京东商品详情
#import "SimilarGoodView.h" //相似商品

#import "JDTwoItemGoodTableViewCell.h"

#import "LLTabBarController.h"

#import "WebViewViewController.h" //

#import <AlibcTradeSDK/AlibcTradeSDK.h>

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
@property (weak, nonatomic) IBOutlet UILabel *incomeLab;


//券信息
@property (weak, nonatomic) IBOutlet UILabel *quanLab;//优惠券价值
@property (weak, nonatomic) IBOutlet UILabel *quanDateLab; //日期


//商品详情
@property (weak, nonatomic) IBOutlet UIView *goodTreasureBgView;
@property (weak, nonatomic) IBOutlet UIView *imagesBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imagesBgViewHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodTreasureBgViewHeightConstraint;

@property(nonatomic,strong) BackTopView* backTopView; //返回顶部

@property(nonatomic,strong)NSString* item_id;
@property(nonatomic,strong)JDGoodDetailModel* jdGoodDetailModel;//商品模型

@end

@implementation JDGoodDetailViewController


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
    // Do any additional setup after loading the view from its nib.
    
    self.fd_prefersNavigationBarHidden = YES;
    
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

#pragma mark - 网络请求
-(void)requestJDGoodDetail
{
    NSDictionary*param = @{
        @"id":self.item_id
    };
    
    __weak JDGoodDetailViewController* wself = self;
    
    [self GetWithUrlStr:kFullUrl(kJDGoodDetail) param:param showHud:YES resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes){
            [wself handleJDGoodDetail:res[@"data"]];
        }
    } falsed:^(NSError * _Nullable error) {
       
    }];
}


-(void)handleJDGoodDetail:(NSDictionary*)data
{
    NSError* err = nil;
    JDGoodDetailModel* jdGoodDetailModel = [[JDGoodDetailModel alloc]initWithDictionary:data error:&err];
    NSArray* recommend_list = jdGoodDetailModel.recommend_list;
    NSMutableArray* mutArr = [NSMutableArray new];
    
     //推荐商品
    for(int i = 0; i < recommend_list.count; i++){
        err = nil;
        JDGood* jdGood = [[JDGood alloc]initWithDictionary:recommend_list[i] error:&err];
        if(jdGood){
            [mutArr addObject:jdGood];
        }
    }
    jdGoodDetailModel.recommend_list = mutArr;
    
 
    self.jdGoodDetailModel = jdGoodDetailModel;
    __weak JDGoodDetailViewController* wself = self;
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
  
    __weak JDGoodDetailViewController* wself = self;
    
    [self PostWithUrlStr:kFullUrl(kWillCollectGood) param:param showHud:YES resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes){
            [wself handleWillCollectGood:res[@"data"]];
        }
    } falsed:^(NSError * _Nullable error) {
       
    }];
}


-(void)handleWillCollectGood:(NSDictionary*)data
{
//    self.jdGoodDetailModel.is_collect = [NSNumber numberWithInt:1];
//    [[LLHudHelper sharedInstance]tipMessage:@"收藏成功"];
//    __weak JDGoodDetailViewController* wself = self;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [wself.collectBtn setTitle:@"已收藏" forState:UIControlStateNormal];
//        [wself.collectBtn setImage:[UIImage imageNamed:@"已收藏"] forState:UIControlStateNormal];
//    });
}

//获取用户数据 主要是为了拿到relationId
-(void)requestGetUserInfo
{
    __weak JDGoodDetailViewController* wself = self;
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
  
    __weak JDGoodDetailViewController* wself = self;
    
    [[LLNetWorking sharedWorking]Delete:kFullUrl(kWillUnCollectGood) param:param success:^(id  _Nonnull res) {
        if(kSuccessRes){
            [wself handleWillCancelCollectGood:res[@"data"]];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

-(void)handleWillCancelCollectGood:(NSDictionary*)data
{
//    self.goodModel.is_collect = [NSNumber numberWithInt:0];
//    [[LLHudHelper sharedInstance]tipMessage:@"已取消收藏"];
//    __weak JDGoodDetailViewController* wself = self;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [wself.collectBtn setTitle:@"未收藏" forState:UIControlStateNormal];
//        [wself.collectBtn setImage:[UIImage imageNamed:@"未收藏"] forState:UIControlStateNormal];
//    });
}

#pragma mark - UI

-(void)resetupUI
{
    [self loading];
    
    //广告
    if(self.jdGoodDetailModel.pict_url){
        [self resetupAdView];
    }
    
    //商品信息
    [self resetupGoodInfo];
    
    //券信息
    [self resetupQuanInfo];
    
    
    
    

    
    //图片信息
    if(self.jdGoodDetailModel.small_images.count > 0){
        [self resetupJDGoodImages];
    }else{
        _goodTreasureBgViewHeightConstraint = 0;
        [_goodTreasureBgView setNeedsLayout];
    }
    
    
    //推荐商品信息
    self.datasource = [[NSMutableArray alloc]initWithArray:self.jdGoodDetailModel.recommend_list];
    [self.tableview reloadData];
    
//    //是否已收藏
//    BOOL isCollect = self.goodModel.is_collect.intValue == 1;
//    if(isCollect){
//        [self.collectBtn setTitle:@"已收藏" forState:UIControlStateNormal];
//        [self.collectBtn setImage:[UIImage imageNamed:@"已收藏"] forState:UIControlStateNormal];
//    }else{
//        [self.collectBtn setTitle:@"未收藏" forState:UIControlStateNormal];
//        [self.collectBtn setImage:[UIImage imageNamed:@"未收藏"] forState:UIControlStateNormal];
//    }
    
    //领券
    BOOL hasCoupon = self.jdGoodDetailModel.coupon_money.floatValue > 0;
    if(hasCoupon){
        [self.quanBtn setTitle:[NSString stringWithFormat:@" 领券￥%@",self.jdGoodDetailModel.coupon_money] forState:UIControlStateNormal];
    }else{
        [self.quanBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    }
    
    [self.view layoutIfNeeded];
    
    [self stopLoading];
}


//广告
-(void)resetupAdView
{
    NSString* adUrl = self.jdGoodDetailModel.pict_url;
    [self.adView setUpOnlineImagesWithSource:@[adUrl] PlaceHolder:kPlaceHolderImg ClickHandler:^(NSInteger index, NSString *imgSrc, UIImage *img) {
    }];
}

//商品信息
-(void)resetupGoodInfo
{
    self.typeLab.layer.borderWidth = 1;
       self.typeLab.layer.borderColor = self.typeLab.textColor.CGColor;
    
    self.typeLab.text = @" 京东 ";
    NSLog(@"%@",self.jdGoodDetailModel.title);
    self.titleLab.text = self.jdGoodDetailModel.title;
    self.newpriceLab.text = self.jdGoodDetailModel.quanhou_price;
    self.oldpriceLab.text = [NSString stringWithFormat:@"原价%@",self.jdGoodDetailModel.price];
    self.incomeLab.text = [NSString stringWithFormat:@" 预计收益￥%.2f ",self.jdGoodDetailModel.earnings.floatValue];
    
    NSString* monthly_sales = self.jdGoodDetailModel.monthly_sales.toString;
    NSString* monthly_sales_all = [NSString stringWithFormat:@"已售%@件",self.jdGoodDetailModel.monthly_sales];
    NSRange range = [monthly_sales_all rangeOfString:monthly_sales];
    NSMutableAttributedString* mutAttrStr = [[NSMutableAttributedString alloc]initWithString:monthly_sales_all];
     [mutAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    self.sellCountLab.attributedText = mutAttrStr;
}

//商家信息
-(void)resetupQuanInfo
{
    
    NSString* empty = @"        ";
    self.quanLab.text = [NSString stringWithFormat:@"%@%@元优惠券",empty, self.jdGoodDetailModel.coupon_money];

    
    NSString* start_time = [Utility getDateStrWithTimesStampNumber:self.jdGoodDetailModel.start_time Format:@"YYYY.MM.dd"];
    NSString* end_time = [Utility getDateStrWithTimesStampNumber:self.jdGoodDetailModel.end_time Format:@"YYYY.MM.dd"];

    NSString* time = [NSString stringWithFormat:@"%@使用期限:%@~%@",empty, start_time,end_time];
    self.quanDateLab.text = time;
}


//推荐商品
-(void)resetupRecommends
{
//    _similarScrollView.showsHorizontalScrollIndicator = NO;
//    CGFloat controlLeft = 10;
//    CGFloat controlSpace = 10;
//
//    //删除旧图
//    for(int i = 0; i < self.similarScrollView.subviews.count; i++){
//        UIView* subView = [self.similarScrollView.subviews objectAtIndex:i];
//        if(subView){
//            [subView removeFromSuperview];
//            subView = nil;
//        }
//    }
//
//    for(int i = 0; i < self.goodModel.smilar_goods.count; i++){
//        SmilarGoodModel* smilarGoodModel = self.goodModel.smilar_goods[i];
//        SimilarGoodView* similarGoodView = [[SimilarGoodView alloc]init];
//        similarGoodView.top = 0;
//        similarGoodView.left = controlLeft;
//        [similarGoodView fullData:smilarGoodModel];
//        controlLeft = similarGoodView.right + controlSpace;
//        [_similarScrollView addSubview:similarGoodView];
//
//
//        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [similarGoodView addSubview:btn];
//        btn.frame = CGRectMake(0, 0, similarGoodView.width, similarGoodView.height);
//        [btn addTarget:self action:@selector(similarGoodBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        btn.tag = 10+i;
//
//
//        if(i == self.goodModel.smilar_goods.count - 1){
//            _similarScrollView.contentSize = CGSizeMake(similarGoodView.right + controlSpace, _similarScrollView.height);
//        }
//    }
}


//商品图片
-(void)resetupJDGoodImages
{
    __block CGFloat b_imagesBgViewContentHeight = 0;//图片背景高度
    
    for(int i = 0; i < self.jdGoodDetailModel.small_images.count; i++){
        
        NSString* fullStr = self.jdGoodDetailModel.small_images[i];
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
         
         __weak JDGoodDetailViewController* wself = self;
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
    
     NSString* fullUrlStr = [NSString stringWithFormat:@"%@&relationId=%@",self.jdGoodDetailModel.shop_url,relationId];
    NSURL* url = [NSURL URLWithString:fullUrlStr];
    
    if(url){
        WebViewViewController* vc = [[WebViewViewController alloc]initWithUrl:self.jdGoodDetailModel.shop_url title:@"店铺详情"];
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



//用户收藏/取消收藏商品
- (IBAction)collectBtnAction:(UIButton*)sender {
//    BOOL isCollect = self.goodModel.is_collect.intValue == 1;
//    if(isCollect){
//        //取消收藏
//        [self requestWillCancelCollectGood:self.goodModel.item_id];
//    }else{
//        //收藏
//        if(self.goodModel.item_id){
//            [self requestWillCollectGood:self.goodModel.item_id];
//        }else{
//            [[LLHudHelper sharedInstance]tipMessage:@"数据异常"];
//        }
//    }
}


//分享
- (IBAction)shareBtnAction:(id)sender {
    
//    NSString* tkl = self.jdGoodDetailModel.tkl;
//    NSString* invite_code = [LLUserManager shareManager].currentUser.invite_code;
//
//    if(!tkl || tkl.length == 0){
//        [[LLHudHelper sharedInstance]tipMessage:@"商品无淘口令,无法分享"];
//        return;
//    }
//
//    if(!invite_code || invite_code.length == 0){
//        //无邀请码
//        [Utility ShowAlert:@"未填写邀请码" message:@"\n未填写上级邀请码,是否填写" buttonName:@[@"好的,去填写",@"不用了,谢谢"] sureAction:^{
//            InviteCodeViewController* vc = [[InviteCodeViewController alloc]init];
//            vc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
//        } cancleAction:nil];
//        return;
//    }
//
//    ShareGoodViewController* vc = [[ShareGoodViewController alloc]initWithTKL:self.goodModel.tkl inviteCode:invite_code];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
}

//领券
- (IBAction)quanBtnAction:(id)sender {
    
//    NSString* relationId = [LLUserManager shareManager].currentUser.relation_id;
//    if(!(relationId.length > 0)){
//        [Utility ShowAlert:@"未绑定淘宝" message:@"\n淘宝授权后可领取优惠券" buttonName:@[@"好的,马上绑定",@"不用了,谢谢"] sureAction:^{
//            [self requestTaobaoAuth];
//        } cancleAction:^{
//        }];
//        return;
//    }
//    
//    
//     __block LLWindowTipView* llwindowTipView = [[LLWindowTipView alloc]initWithType:WindowTipViewTypeTaoBao];
//     llwindowTipView.income = self.goodModel.earnings.toString;
//     [llwindowTipView show];
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        [llwindowTipView dismiss];
//        
//        NSString* fullUrlStr = [NSString stringWithFormat:@"%@&relationId=%@",self.goodModel.coupon_share_url,relationId];
//        
//        //百川sdk方式打开
//        AlibcTradeShowParams* showParam = [[AlibcTradeShowParams alloc]init];
//           showParam.openType = AlibcOpenTypeAuto;//打开方式自动打开
//           showParam.isNeedPush = YES;
//           showParam.linkKey = @"taobao"; //优先拉起手机淘宝
//        
//        [[AlibcTradeSDK sharedInstance].tradeService openByUrl:fullUrlStr identity:@"trade" webView:nil parentController:self.navigationController showParams:showParam taoKeParams:nil trackParam:nil tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
//            NSLog(@"%@",result);
//        } tradeProcessFailedCallback:^(NSError * _Nullable error) {
//            NSLog(@"%@",error);
//        }];
//    });
}

#pragma mark - tableview delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray* mutArr = [NSMutableArray new];
    for(int i = 0; i < self.datasource.count; i++){//self.datasource.count/2 是整数
        NSMutableArray* item = [NSMutableArray new];
        if(i%2 == 0) {
            //基数个 左边model
            JDGood* modelLeft = nil;
            if(self.datasource.count > i){
                modelLeft = self.datasource[i];
            }else{
                modelLeft = [JDGood new];
            }
            
            JDGood* modelRight = nil;
            if(self.datasource.count > (i+1)){
                modelRight = self.datasource[i+1];
            }else{
                modelRight = [JDGood new];
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
    JDTwoItemGoodTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JDTwoItemGoodTableViewCell" forIndexPath:indexPath];
    
    NSMutableArray* mutArr = [NSMutableArray new];
    for(int i = 0; i < self.datasource.count; i++){//self.datasource.count/2 是整数
        NSMutableArray* item = [NSMutableArray new];
        if(i%2 == 0) {
           //基数个
            JDGood* modelLeft = nil;
            if(self.datasource.count > i){
                modelLeft = self.datasource[i];
            }else{
                modelLeft = [JDGood new];
            }
            
            JDGood* modelRight = nil;
            if(self.datasource.count > (i+1)){
                modelRight = self.datasource[i+1];
            }else{
                modelRight = [JDGood new];
            }
            
            [item addObject:modelLeft];
            [item addObject:modelRight];
            [mutArr addObject:item];
        }
    }
    
    NSArray* item = mutArr[indexPath.row];
    
    [cell fullDataWithLeftModel:item.firstObject rightModel:item.lastObject];
    
    __weak JDGoodDetailViewController* wself = self;
    cell.jdTwoItemOneGoodClickedCallback = ^(JDGood * _Nonnull jdGood) {
        if(jdGood.item_id){
            JDGoodDetailViewController* vc = [[JDGoodDetailViewController alloc]initWithItem_id:jdGood.item_id.toString];
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
    __weak JDGoodDetailViewController* wself = self;
    [self GetWithUrlStr:kFullUrl(kTbAuth) param:nil showHud:YES resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes){
            [wself handleTaobaoAuth:res[@"data"]];
        }
    } falsed:^(NSError * _Nullable error) {
        
    }];
}

-(void)handleTaobaoAuth:(NSString*)urlStr
{
    __weak JDGoodDetailViewController* wself = self;
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
