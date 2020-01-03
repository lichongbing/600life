//
//  BestSelectMainViewController.m
//  600生活
//
//  Created by iOS on 2019/11/22.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "BestSelectMainViewController.h"
#import "BestGoodTableViewCell.h"
#import "BestSelectGoodModel.h"
#import "GoodDetailViewController.h"

@interface BestSelectMainViewController ()
@property (weak, nonatomic) IBOutlet UIView *tracker;

@property(nonatomic,assign)BOOL isLive; //是否是明日预告

@end

@implementation BestSelectMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"好货严选";
    self.tracker.centerX = kScreenWidth * 0.25;
    
    [self setupTableview];
}

#pragma mark - UI

-(void)setupTableview
{
    self.tableview.height = kScreenHeight - kNavigationBarHeight - kIPhoneXHomeIndicatorHeight - 41;
    self.tableview.top = 41;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = (id)self;
    self.tableview.dataSource = (id)self;
    [self.tableview registerNib:[UINib nibWithNibName:@"BestGoodTableViewCell" bundle:nil] forCellReuseIdentifier:@"BestGoodTableViewCell"];
    [self addMJRefresh];
}

#pragma mark - 网络请求

-(void)requestBestGoodsWithPageIndex:(NSInteger)pageIndex isLive:(BOOL)isLive
{
    NSDictionary* param1 = @{
        @"page" : [NSNumber numberWithInteger:pageIndex],
        @"page_size" : @"10"
    };
    
    NSDictionary* param2 = @{
           @"page" : [NSNumber numberWithInteger:pageIndex],
           @"page_size" : @"10",
           @"live" : @"2"
       };
    
    NSDictionary* param = isLive ? param2 : param1;
    
    __weak BestSelectMainViewController* wself = self;
    [self GetWithUrlStr:kFullUrl(kBestGoods) param:param showHud:YES resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes){
            [wself handleBestGoodsWithPageIndex:pageIndex data:res[@"data"]];
        }
    } falsed:^(NSError * _Nullable error) {

    }];
}

-(void)handleBestGoodsWithPageIndex:(NSInteger)pageIndex data:(NSArray*)datas
{
    NSArray* goods_list = datas;
    NSMutableArray* mutArr = [NSMutableArray new];
    for(int i = 0; i < goods_list.count; i++){
        NSError* err = nil;
        BestSelectGoodModel* bestSelectGoodModel = [[BestSelectGoodModel alloc]initWithDictionary:goods_list[i] error:&err];
        if(bestSelectGoodModel){
            [mutArr addObject:bestSelectGoodModel];
        } else {

        }
    }
    [self configDataSource:mutArr];
}

-(void)configDataSource:(NSArray*)tempArray
{
    __weak BestSelectMainViewController* wself = self;
    
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
    return self.datasource.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BestGoodTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BestGoodTableViewCell" forIndexPath:indexPath];
    [cell fullData:self.datasource[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BestSelectGoodModel* bestSelectGoodModel = [self.datasource objectAtIndex:indexPath.row];
    if(bestSelectGoodModel.item_id){
        GoodDetailViewController* vc = [[GoodDetailViewController alloc]initWithItem_id:bestSelectGoodModel.item_id];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - control action

- (IBAction)todayBtnAction:(id)sender {
    __weak BestSelectMainViewController* wself = self;
    [UIView animateWithDuration:0.4 animations:^{
        wself.tracker.centerX = kScreenWidth * 0.25;
    }];
    
    [self.datasource removeAllObjects];
    [self.tableview reloadData];
    
    self.isLive = 0;
    self.pageIndex = 1;
    [self requestBestGoodsWithPageIndex:self.pageIndex isLive:self.isLive];
}

- (IBAction)nextdayBtnAction:(id)sender {
    __weak BestSelectMainViewController* wself = self;
    [UIView animateWithDuration:0.4 animations:^{
        wself.tracker.centerX = kScreenWidth * 0.75;
    }];
    
    [self.datasource removeAllObjects];
    [self.tableview reloadData];
    
    self.isLive = 1;
    self.pageIndex = 1;
    [self requestBestGoodsWithPageIndex:self.pageIndex isLive:self.isLive];
}


#pragma mark - helper

-(void)addMJRefresh
{
    __weak BestSelectMainViewController* wself = self;
    self.tableview.mj_header = [LLRefreshGifHeader headerWithRefreshingBlock:^{
        wself.isMJHeaderRefresh = YES; //重要代码
        //获取评论数据
        wself.pageIndex=1;
        [wself requestBestGoodsWithPageIndex:wself.pageIndex isLive:self.isLive];
        [wself impactLight];
    }];
    
    self.tableview.mj_footer = [LLRefreshAutoGifFooter footerWithRefreshingBlock:^{
         wself.isMJFooterRefresh = YES;
        //获取评论数据
        wself.pageIndex++;
        [wself requestBestGoodsWithPageIndex:wself.pageIndex isLive:self.isLive];
        [wself impactLight];
    }];
    [self.tableview.mj_header beginRefreshing];
}


@end
