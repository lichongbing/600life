//
//  JDCarefulSelectViewController.m
//  600生活
//
//  Created by iOS on 2020/1/2.
//  Copyright © 2020 灿男科技. All rights reserved.
//

#import "JDHomeController.h"
#import "JDHomeModel.h"
#import "JDTwoItemGoodTableViewCell.h"
#import "JDTeSeMainViewController.h"  //特色购
#import "LoginAndRigistMainVc.h"
#import "JDGoodDetailViewController.h"  //商品详情

@interface JDHomeController ()<UIScrollViewDelegate>

@property(nonatomic,strong)JDHomeModel* jdHomeModel;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet LLBaseView *headerViewLayoutBottomLine;


@end

@implementation JDHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
    [self requestActivityGoods_JDHomeDatas];
}

#pragma mark - UI

-(void)setupUI
{
    __weak JDHomeController* wself = self;
    self.headerViewLayoutBottomLine.viewDidLayoutNewFrameCallBack = ^(CGRect newFrame) {
        wself.headerView.height = newFrame.origin.y + newFrame.size.height;
        wself.tableview.tableHeaderView = wself.headerView;
    };
    self.tableview.tableHeaderView = self.headerView;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = (id)self;
    self.tableview.dataSource = (id)self;
    [self.tableview registerNib:[UINib nibWithNibName:@"JDTwoItemGoodTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDTwoItemGoodTableViewCell"];
    
    self.tableview.top = 40;
    self.tableview.left = 0;
    self.tableview.width = kScreenWidth;
    self.tableview.height = kScreenHeight - kNavigationBarHeight - kIPhoneXHomeIndicatorHeight - 40;
    [self addMJRefresh];
}

#pragma mark - control action
//特色购点击
- (IBAction)tesegouBtnAction:(id)sender {
    JDTeSeMainViewController* vc = [[JDTeSeMainViewController alloc]initWithIndex:0];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//好券商品点击
- (IBAction)haoquanBtnAction:(id)sender {
    JDTeSeMainViewController* vc = [[JDTeSeMainViewController alloc]initWithIndex:0];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//9.9包邮
- (IBAction)ninePnineBtnAction:(id)sender {
    JDTeSeMainViewController* vc = [[JDTeSeMainViewController alloc]initWithIndex:1];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//好货
- (IBAction)haohuoBtnAction:(id)sender {
    JDTeSeMainViewController* vc = [[JDTeSeMainViewController alloc]initWithIndex:2];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - 网络请求
//京东精选数据
-(void)requestActivityGoods_JDHomeDatas
{
    NSDictionary* param = @{
        @"activity_type" : @"jd"
    };
    
    [self PostWithUrlStr:kFullUrl(kJDHomePage) param:param showHud:YES resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes){
            [self handleActivityGoods_JDHomeDatas:res[@"data"]];
        }
    } falsed:^(NSError * _Nullable error) {
        
    }];
}

-(void)handleActivityGoods_JDHomeDatas:(NSDictionary*)data
{
    NSError* err = nil;
    self.jdHomeModel = [[JDHomeModel alloc]initWithDictionary:data error:&err];
    
    NSMutableArray* mutArr = [NSMutableArray new];
    for(int i = 0; i < self.jdHomeModel.recommend_goods.count; i++){
        err = nil;
        JDGood* jdHomeRecommendGood = [[JDGood alloc]initWithDictionary:self.jdHomeModel.recommend_goods[i] error:&err];
        if(jdHomeRecommendGood){
            [mutArr addObject:jdHomeRecommendGood];
        }
    }
    
    if(mutArr.count > 0){
        self.jdHomeModel.recommend_goods = mutArr;
    }
}

//为你推荐数据
-(void)requestJDRecommendGoods:(NSInteger)pageIndex
{
    NSDictionary* param = @{
      @"page" : [NSNumber numberWithInteger:pageIndex],
      @"page_size" : @"10",
      @"cid" : @"2"  //商品类型1-好卷商品 2-为你推荐，3-特价9.9 4-品牌好货 （默认为1）
    };
    
    [self GetWithUrlStr:kFullUrl(kJDActivity) param:param showHud:NO resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes){
            [self handleJDRecommendGoodsWithPageIndex:pageIndex datas:res[@"data"]];
        }
    } falsed:^(NSError * _Nullable error) {
        
    }];
}

-(void)handleJDRecommendGoodsWithPageIndex:(NSInteger)pageIndex datas:(NSArray*)datas
{
    NSMutableArray* mutArr = [NSMutableArray new];
       for(int i = 0; i < datas.count; i++){
           NSError* err = nil;
           JDGood* jdGood = [[JDGood alloc]initWithDictionary:datas[i] error:&err];
           if(jdGood){
               [mutArr addObject:jdGood];
           } else {
               NSLog(@"京东商品模型转换失败");
           }
       }
    [self configDataSource:mutArr];
}

-(void)configDataSource:(NSArray*)tempArray
{
    __weak JDHomeController* wself = self;
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
    
    __weak JDHomeController* wself = self;
      cell.jdTwoItemOneGoodClickedCallback = ^(JDGood * _Nonnull jdGood) {
          if(jdGood.item_id){
              
              if([LLUserManager shareManager].currentUser == nil){
                  __strong JDHomeController* sself = wself;
                  [Utility ShowAlert:@"尚未登录" message:@"\n是否登录" buttonName:@[@"好的,去登录",@"不用了,谢谢"] sureAction:^{
                      LoginAndRigistMainVc* vc = [LoginAndRigistMainVc new];
                      vc.hidesBottomBarWhenPushed = YES;
                      [sself.navigationController pushViewController:vc animated:YES];
                  } cancleAction:nil];
                  return;
              }
              
              JDGoodDetailViewController* vc = [[JDGoodDetailViewController alloc]initWithItem_id:jdGood.item_id.toString];
              vc.hidesBottomBarWhenPushed = YES;
              [wself.navigationController pushViewController:vc animated:YES];
          }
      };
    return cell;
}


#pragma mark - uiscrollview delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //代理方法在父视图控制器中处理
}

#pragma mark - helper

#pragma mark - 此处有回调
-(BackTopView*)backTopView
{
    if(_backTopView == nil){
        _backTopView = [[BackTopView alloc]init];
        [self.view addSubview:_backTopView];
        _backTopView.right = kScreenWidth - 20 ;
        _backTopView.bottom = kScreenHeight - kNavigationBarHeight - kTabbarHeight - 50;
        
        __weak JDHomeController* wself = self;
        _backTopView.backTopViewClickedCallBack = ^{
            __strong JDHomeController* sself = wself;
            [UIView animateWithDuration:0.3 animations:^{
                sself.tableview.contentOffset = CGPointMake(0, 0);
            }];
        };
    }
    
    [self.view bringSubviewToFront:_backTopView];
    return _backTopView;
}

-(void)addMJRefresh
{
    __weak JDHomeController* wself = self;
    self.tableview.mj_header = [LLRefreshGifHeader headerWithRefreshingBlock:^{
        wself.isMJHeaderRefresh = YES; //重要代码
        wself.pageIndex=1;
        [wself requestJDRecommendGoods:wself.pageIndex];
        [wself impactLight];
    }];
    
    self.tableview.mj_footer = [LLRefreshAutoGifFooter footerWithRefreshingBlock:^{
         wself.isMJFooterRefresh = YES;
         wself.pageIndex++;
         [wself requestJDRecommendGoods:wself.pageIndex];
        [wself impactLight];
    }];
    
     [self.tableview.mj_header beginRefreshing];
}

@end
