//
//  HotRecommendViewController.m
//  600生活
//
//  Created by iOS on 2019/11/20.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "HotRecommendViewController.h"
#import "HotRecommendTableViewCell.h"
#import "HotRecommendGood.h"
#import "GoodDetailViewController.h"

@interface HotRecommendViewController ()

@end

@implementation HotRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"爆款推荐";
    
    [self setupTableview];
}

#pragma mark - UI

-(void)setupTableview
{
    UIImageView* imageView = [UIImageView new];
    imageView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth * 297 / 375);
    imageView.image = [UIImage imageNamed:@"全网超级爆款单品推荐"];
    self.tableview.tableHeaderView = imageView;
    
    self.tableview.height = kScreenHeight - kNavigationBarHeight - kIPhoneXHomeIndicatorHeight -5;
    self.tableview.top = 5;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = (id)self;
    self.tableview.dataSource = (id)self;
    [self.tableview registerNib:[UINib nibWithNibName:@"HotRecommendTableViewCell" bundle:nil] forCellReuseIdentifier:@"HotRecommendTableViewCell"];
    [self addMJRefresh];
}

#pragma mark - 网络请求
-(void)requestActivityGoods_BaoKuanWithPageIndex:(NSInteger)pageIndex
{
    NSDictionary* param = @{
        @"page" : [NSNumber numberWithInteger:pageIndex],
        @"page_size" : @"6",
        @"activity_type" : @"baokun"
      };
      
      [self PostWithUrlStr:kFullUrl(kGetActivityGoods) param:param showHud:YES resCache:nil success:^(id  _Nullable res) {
          if(kSuccessRes){
              [self handleActivityGoods_BaoKuanWithPageIndex: pageIndex data:res[@"data"]];
          }
      } falsed:^(NSError * _Nullable error) {
          
      }];
}

-(void)handleActivityGoods_BaoKuanWithPageIndex:(NSInteger)pageIndex data:(NSDictionary*)data
{
    NSString* bannerUrlStr = data[@"banner"];
    __weak HotRecommendViewController* wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [((UIImageView*)wself.tableview.tableHeaderView) sd_setImageWithURL:[NSURL URLWithString:bannerUrlStr] placeholderImage:[UIImage imageNamed:@"全网超级爆款单品推荐"]];
    });
    
    NSArray* goods_list = data[@"goods_list"];
    NSMutableArray* mutArr = [NSMutableArray new];
    for(int i = 0; i < goods_list.count; i++){
        NSError* err = nil;
        HotRecommendGood* hotRecommendGood = [[HotRecommendGood alloc]initWithDictionary:goods_list[i] error:&err];
        if(hotRecommendGood){
            [mutArr addObject:hotRecommendGood];
        } else {
            
        }
    }
    [self configDataSource:mutArr];
}

-(void)configDataSource:(NSArray*)tempArray
{
    
    __weak HotRecommendViewController* wself = self;
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
            [wself.tableview.mj_footer endRefreshingWithNoMoreData];
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
               HotRecommendGood* modelLeft = self.datasource[i];
               HotRecommendGood* modelRight = self.datasource[i+1];
               [item addObject:modelLeft];
               [item addObject:modelRight];
               [mutArr addObject:item];
           }
       }
       return mutArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HotRecommendTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HotRecommendTableViewCell" forIndexPath:indexPath];
    
    NSMutableArray* mutArr = [NSMutableArray new];
    for(int i = 0; i < self.datasource.count; i++){//self.datasource.count/2 是整数
        NSMutableArray* item = [NSMutableArray new];
        if(i%2 == 0) {
            //基数个 左边model
            HotRecommendGood* modelLeft = self.datasource[i];
            HotRecommendGood* modelRight = self.datasource[i+1];
            [item addObject:modelLeft];
            [item addObject:modelRight];
            [mutArr addObject:item];
        }
    }
    
    NSArray* item = mutArr[indexPath.row];
    
    [cell fullDataWithLeftModel:item.firstObject rightModel:item.lastObject];
    
    __weak HotRecommendViewController* wself = self;
    cell.hotRecommendGoodClickedCallback = ^(HotRecommendGood * _Nonnull hotRecommendGood) {
        if(hotRecommendGood.item_id){
            GoodDetailViewController* vc = [[GoodDetailViewController alloc]initWithItem_id:hotRecommendGood.item_id];
            vc.hidesBottomBarWhenPushed = YES;
            [wself.navigationController pushViewController:vc animated:YES];
        }
    };
    
    return cell;
}

#pragma mark - helper

-(void)addMJRefresh
{
    __weak HotRecommendViewController* wself = self;
    self.tableview.mj_header = [LLRefreshGifHeader headerWithRefreshingBlock:^{
        wself.isMJHeaderRefresh = YES; //重要代码
        //获取评论数据
        wself.pageIndex=1;
        [wself requestActivityGoods_BaoKuanWithPageIndex:wself.pageIndex];
        [wself impactLight];
    }];
    
    self.tableview.mj_footer = [LLRefreshAutoGifFooter footerWithRefreshingBlock:^{
        wself.isMJFooterRefresh = YES;
        //获取评论数据
        wself.pageIndex++;
        [wself requestActivityGoods_BaoKuanWithPageIndex:wself.pageIndex];
        [wself impactLight];
    }];
    [self.tableview.mj_header beginRefreshing];
}

@end
