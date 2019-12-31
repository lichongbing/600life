//
//  WithDrawHistoryViewController.m
//  600生活
//
//  Created by iOS on 2019/11/19.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "WithDrawHistoryViewController.h"
#import "WithDrawHistoryTableViewCell.h"

#import "CashoutModel.h"

@interface WithDrawHistoryViewController ()

@end

@implementation WithDrawHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"提现记录";
    [self setupTableview];
}



#pragma mark - UI

-(void)setupTableview
{
    self.tableview.height = kScreenHeight - kNavigationBarHeight - kIPhoneXHomeIndicatorHeight -5;
    self.tableview.top = 5;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = (id)self;
    self.tableview.dataSource = (id)self;
    [self.tableview registerNib:[UINib nibWithNibName:@"WithDrawHistoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"WithDrawHistoryTableViewCell"];
    [self addMJRefresh];
}

//kCashoutLog
#pragma mark - 网络请求
-(void)requestCashoutLog:(NSInteger)pageIndex
{
     NSDictionary* param = @{
           @"page":[NSNumber numberWithInteger:pageIndex],
           @"page_size":@"10"
         };
    [self GetWithUrlStr:kFullUrl(kCashoutLog) param:param showHud:YES resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes){
            [self handleCashoutLogWithPageIndex:pageIndex datas:res[@"data"]];
        }
    } falsed:^(NSError * _Nullable error) {
        
    }];
}

-(void)handleCashoutLogWithPageIndex:(NSInteger)pageIndex datas:(NSArray*)datas
{
    //处理主页数据
    NSArray* list = datas;
    NSMutableArray* mutArr = [NSMutableArray new];
    for(int i = 0; i < list.count; i++){
        NSError* err = nil;
        CashoutModel* cashoutModel = [[CashoutModel alloc]initWithDictionary:list[i] error:&err];
        if(cashoutModel){
            [mutArr addObject:cashoutModel];
        } else {
            NSLog(@"提现模型创建失败");
        }
    }
    [self configDataSource:mutArr];
}

-(void)configDataSource:(NSArray*)tempArray
{
    
    __weak WithDrawHistoryViewController* wself = self;
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(wself.datasource.count == 0){
            [Utility showTipViewOn:wself.tableview type:0 iconName:@"tipview无商品" msg:@"无提现记录"];
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
    WithDrawHistoryTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WithDrawHistoryTableViewCell" forIndexPath:indexPath];
    [cell fullData:self.datasource[indexPath.row]];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    __weak WithDrawHistoryViewController* wself = self;
    cell.cellClickedCallback = ^(CashoutModel * _Nonnull cashoutModel) {
       NSInteger index = [wself.datasource indexOfObject:cashoutModel];
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    };
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CashoutModel* cashoutModel = [self.datasource objectAtIndex:indexPath.row];
    if(!cashoutModel.isShowDetailInfo){
        return 50;
    }else{
        return UITableViewAutomaticDimension;
    }
}

#pragma mark - helper

-(void)addMJRefresh
{
    __weak WithDrawHistoryViewController* wself = self;
    self.tableview.mj_header = [LLRefreshGifHeader headerWithRefreshingBlock:^{
        wself.isMJHeaderRefresh = YES; //重要代码
        //获取评论数据
        wself.pageIndex=1;
        [wself requestCashoutLog:wself.pageIndex];
        [wself impactLight];
    }];
    
    self.tableview.mj_footer = [LLRefreshAutoGifFooter footerWithRefreshingBlock:^{
         wself.isMJFooterRefresh = YES;
        //获取评论数据
        wself.pageIndex++;
        [wself requestCashoutLog:wself.pageIndex];
        [wself impactLight];
    }];
    [self.tableview.mj_header beginRefreshing];
}


@end
