//
//  OrderListViewController.m
//  600生活
//
//  Created by iOS on 2019/11/13.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "OrderListViewController.h"
#import "MyOrderTableViewCell.h"
#import "MyOrderModel.h"  //订单模型

@interface OrderListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,assign)int orderStatus;

@end

@implementation OrderListViewController

-(id)initWithOrderStatus:(int)orderStatus;
{
    if(self = [super init]){
        self.orderStatus = orderStatus;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)loadDatasWhenUserDone
{
    [self setupTableview];
}

#pragma mark - UI
-(void)setupTableview
{
    self.tableview.height = kScreenHeight - kNavigationBarHeight - kIPhoneXHomeIndicatorHeight - 50 ;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = (id)self;
    self.tableview.dataSource = (id)self;
    [self.tableview registerNib:[UINib nibWithNibName:@"MyOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyOrderTableViewCell"];
    [self addMJRefresh];
}

#pragma mark - 网络请求

//网络请求  获取订单数据   订单状态 状态 1:所有订单 3:结算 12：付款，13，失效，14，订单成功
-(void)requestMyOrdersWithPageIndex:(NSInteger)pageIndex
{
    NSDictionary* param = @{
           @"page":[NSNumber numberWithInteger:pageIndex],
           @"page_size":@"10",
           @"status":[NSString stringWithFormat:@"%d",self.orderStatus]
     };
    
    [self GetWithUrlStr:kFullUrl(kMyOrders) param:param showHud:YES resCache:^(id  _Nullable cacheData) {
        if(kSuccessCache){
            [self handleMyOrdersWithPageIndex:pageIndex datas:cacheData[@"data"]];
        }
    } success:^(id  _Nullable res) {
        if(kSuccessRes){
             [self handleMyOrdersWithPageIndex:pageIndex datas:res[@"data"]];
        }
    } falsed:^(NSError * _Nullable error) {
        NSLog(@"1");
    }];
}

-(void)handleMyOrdersWithPageIndex:(NSInteger)pageIndex datas:(NSArray*)datas
{
    NSMutableArray* mutArr = [NSMutableArray new];
     for(int i = 0; i < datas.count; i++){
         
         [Utility printModelWithDictionary:datas[0] modelName:@"AA"];
         NSError* err = nil;
         MyOrderModel* myOrderModel = [[MyOrderModel alloc]initWithDictionary:datas[i] error:&err];
         if(myOrderModel){
             [mutArr addObject:myOrderModel];
         } else {
             NSLog(@"订单模型创建失败");
         }
     }
     [self configDataSource:mutArr];
}

-(void)configDataSource:(NSArray*)tempArray
{
    if (tempArray.count > 0) { //有数据
        if(self.pageIndex == 1){//头部刷新
            self.datasource = [[NSMutableArray alloc]initWithArray:tempArray];
        } else if(self.pageIndex > 1){ //尾部加载
            [self.datasource addObjectsFromArray:tempArray];
        }
        __weak OrderListViewController* wself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself.tableview reloadData];
        });
    } else { //无数据
        self.pageIndex--; // 此时的pageIndex 取不到数据 应该-1
        __weak OrderListViewController* wself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself.tableview.mj_footer endRefreshingWithNoMoreData];
        });
    }
    
    __weak OrderListViewController* wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if(wself.datasource.count == 0){
            [Utility showTipViewOn:wself.tableview type:0 iconName:@"tipview无浏览记录" msg:@"无订单"];
        }else{
            [Utility dismissTipViewOn:wself.tableview];
        }
    });
}

#pragma mark - tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyOrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyOrderTableViewCell" forIndexPath:indexPath];
    [cell fullData:self.datasource[indexPath.row]];
    return cell;
}

#pragma mark - helper

-(void)addMJRefresh
{
    __weak OrderListViewController* wself = self;
    self.tableview.mj_header = [LLRefreshGifHeader headerWithRefreshingBlock:^{
        wself.isMJHeaderRefresh = YES; //重要代码
        //获取评论数据
        wself.pageIndex=1;
        [wself requestMyOrdersWithPageIndex:wself.pageIndex];
        [wself impactLight];
    }];
    
    self.tableview.mj_footer = [LLRefreshAutoGifFooter footerWithRefreshingBlock:^{
         wself.isMJFooterRefresh = YES;
        //获取评论数据
        wself.pageIndex++;
        [wself requestMyOrdersWithPageIndex:wself.pageIndex];
        [wself impactLight];
    }];
    [self.tableview.mj_header beginRefreshing];
}

@end
