//
//  IncomeDetailSubViewController.m
//  600生活
//
//  Created by iOS on 2020/1/6.
//  Copyright © 2020 灿男科技. All rights reserved.
//

#import "IncomeDetailSubViewController.h"
#import "IncomeDetailTableViewCell.h"


@interface IncomeDetailSubViewController ()

@property(nonatomic,assign)int type;//0 个人收益明细    1 推广收益明细

@end

@implementation IncomeDetailSubViewController

-(id)initWithType:(int)type
{
    if(self = [super init]){
        self.type = type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
    [self setupTableView];
}

#pragma mark - UI
-(void)setupTableView
{
    self.tableview.delegate = (id)self;
    self.tableview.dataSource = (id)self;
    self.tableview.estimatedRowHeight = 100;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableview registerNib:[UINib nibWithNibName:@"IncomeDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"IncomeDetailTableViewCell"];
    self.tableview.backgroundColor = [UIColor whiteColor];
    [self addMJRefresh];
}

#pragma mark - 网络请求

//获取收益明细 time: 2019-11
-(void)requestEarningList:(NSInteger)pageIndex time:(NSString*)time
{
    NSMutableDictionary* param = [NSMutableDictionary new];
    [param setValue:[NSNumber numberWithInteger:pageIndex] forKey:@"page"];
    [param setValue:[NSNumber numberWithInteger:10] forKey:@"page_size"];
    [param setValue:[NSString stringWithFormat:@"%d",self.type] forKey:@"is_spread"];
    
    if(time){
        [param setValue:time forKey:@"time"];
    }
     
    [self GetWithUrlStr:kFullUrl(kEarningList) param:param showHud:YES resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes){
            [self handleEarningList:pageIndex datas:res[@"data"]];
        }
    } falsed:^(NSError * _Nullable error) {
        
    }];
}

-(void)handleEarningList:(NSInteger)pageIndex datas:(NSArray*)list
{
    NSMutableArray* mutArr = [NSMutableArray new];
    for(int i = 0; i < list.count; i++){
        NSError* err = nil;
        IncomeItemModel* incomeItemModel = [[IncomeItemModel alloc]initWithDictionary:list[i] error:&err];
        if(incomeItemModel){
            [mutArr addObject:incomeItemModel];
        } else {
            NSLog(@"收益模型创建失败");
        }
    }
    [self configDataSource:mutArr];
}

-(void)configDataSource:(NSArray*)tempArray
{
    __weak IncomeDetailSubViewController* wself = self;
    if (tempArray.count > 0) { //有数据
        if(self.pageIndex == 1){//头部刷新
            self.datasource = [[NSMutableArray alloc]initWithArray:tempArray];
        } else if(self.pageIndex > 1){ //尾部加载
            [self.datasource addObjectsFromArray:tempArray];
        }
    } else { //无数据
        self.pageIndex--; // 此时的pageIndex 取不到数据 应该-1
        dispatch_async(dispatch_get_main_queue(), ^{
            if(wself.datasource.count > 0){
                 [wself.tableview.mj_footer endRefreshingWithNoMoreData];
            }
        });
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
       [wself.tableview reloadData];
    });
    
    if(self.datasource.count > 0){
        [Utility dismissTipViewOn:self.tableview];
    }else{
        [Utility dismissTipViewOn:self.tableview];
        NSString* str = self.type == 0 ? @"没有个人收益明细哟!" : @"没有推广收益明细哟!";
        [Utility showTipViewOn:self.tableview type:0 iconName:@"tipview无浏览记录" msg:str];
    }
}

-(void)setTime:(NSString *)time
{
    _time = time;
    self.datasource = [NSMutableArray new];
    self.pageIndex = 1;
    [self requestEarningList:self.pageIndex time:time];
}

#pragma mark - tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IncomeDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"IncomeDetailTableViewCell" forIndexPath:indexPath];
    if(self.datasource.count > 0){
        [cell fullData:self.datasource[indexPath.row]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - helper

-(void)addMJRefresh
{
    __weak IncomeDetailSubViewController* wself = self;
    self.tableview.mj_header = [LLRefreshGifHeader headerWithRefreshingBlock:^{
        wself.isMJHeaderRefresh = YES; //重要代码
        wself.pageIndex=1;
        [wself requestEarningList:wself.pageIndex time:wself.time];
        [wself impactLight];
    }];
    
    self.tableview.mj_footer = [LLRefreshAutoGifFooter footerWithRefreshingBlock:^{
        wself.isMJFooterRefresh = YES;
        wself.pageIndex++;
        [wself requestEarningList:wself.pageIndex time:wself.time];
        [wself impactLight];
    }];
    
    [self.tableview.mj_header beginRefreshing];
}

@end
