//
//  FansListViewController.m
//  600生活
//
//  Created by iOS on 2019/11/18.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "FansListViewController.h"
#import "FanTableViewCell.h"
#import "FansModel.h"

@interface FansListViewController ()

@property(nonatomic,strong)NSString*type;

@property(nonatomic,strong)NSString* lastFanId;//保存最后一个粉丝的id

@property(nonatomic,assign)NSInteger fansCount; //粉丝数
@property(nonatomic,strong)UILabel* showFansCountLab; //展示粉丝数

@end

@implementation FansListViewController

-(id)initWithType:(NSString*)type
{
    if(self = [super init]){
        self.type = type;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的粉丝";
    [self setupTableview];
    [self setupBottomView];
    [self requestAllFansCount]; //请求全部粉丝数
}

#pragma mark - UI

-(void)setupTableview
{
    self.tableview.height = kScreenHeight - kNavigationBarHeight - kIPhoneXHomeIndicatorHeight - 50;
    self.tableview.top = 0;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = (id)self;
    self.tableview.dataSource = (id)self;
    [self.tableview registerNib:[UINib nibWithNibName:@"FanTableViewCell" bundle:nil] forCellReuseIdentifier:@"FanTableViewCell"];
    [self addMJRefresh];
}

-(void)setupBottomView
{
    _showFansCountLab = [UILabel new];
    [self.view addSubview:_showFansCountLab];
    _showFansCountLab.frame = CGRectMake(0, 0, kScreenWidth - 20, 50);
    _showFansCountLab.left = 10;
    _showFansCountLab.top = self.tableview.bottom;
    _showFansCountLab.backgroundColor = [UIColor redColor];
    _showFansCountLab.textColor = [UIColor whiteColor];
    _showFansCountLab.font = [UIFont systemFontOfSize:15];
    _showFansCountLab.textAlignment = NSTextAlignmentCenter;
    _showFansCountLab.hidden = NO;
}

#pragma mark setter
-(void)setFansCount:(NSInteger)fansCount
{
    _fansCount = fansCount;
    __weak FansListViewController* wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if(fansCount > 0){
              wself.showFansCountLab.hidden = NO;
            wself.showFansCountLab.text = [NSString stringWithFormat:@"粉丝数:%lu位",fansCount];
          }else{
              wself.showFansCountLab.hidden = YES;
          }
    });
}

#pragma mark - 网络请求

//获取全部粉丝数
-(void)requestAllFansCount
{
    __weak FansListViewController* wself = self;
    [self GetWithUrlStr:kFullUrl(kGetFansCount) param:nil showHud:YES resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes){
            NSInteger fansCount = [res[@"data"] integerValue];
            wself.fansCount = fansCount;
        }
    } falsed:^(NSError * _Nullable error) {
    }];
}

//用最后一个粉丝的id分页 如果希望获取pid的下一级粉丝 就需要传递pid
-(void)requestFansWithLastFanId:(NSString*)fanId
{
    NSMutableDictionary* param = [NSMutableDictionary new];
    if(fanId){
        [param setValue:fanId forKey:@"k"];
    }else{
        [param setValue:@"" forKey:@"k"];
    }
    [param setValue:@"20" forKey:@"page_size"];
    
    
    [self GetWithUrlStr:kFullUrl(kGetFans) param:param showHud:YES resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes){
            [self handleFans:res[@"data"] fanId:fanId];
        }
    } falsed:^(NSError * _Nullable error) {
        NSLog(@"%@,%@,%@",self.type,param,kFullUrl(kGetFans));
    }];
}

-(void)handleFans:(NSArray*)datas fanId:(NSString*)fanId
{
    NSArray* list = datas;
    NSMutableArray* mutArr = [NSMutableArray new];
    for(int i = 0; i < list.count; i++){
        NSError* err = nil;
        [Utility printModelWithDictionary:list[0] modelName:@"A"];
        FansModel* fansModel = [[FansModel alloc]initWithDictionary:list[i] error:&err];
        if(fansModel){
            [mutArr addObject:fansModel];
        } else {
            NSLog(@"粉丝模型创建失败");
        }
    }
    [self configDataSource:mutArr fanId:fanId];
}

-(void)configDataSource:(NSArray*)tempArray fanId:(NSString*)fanId
{
    
    __weak FansListViewController* wself = self;
    if (tempArray.count > 0) { //有数据
        if(!fanId){//头部刷新
            self.datasource = [[NSMutableArray alloc]initWithArray:tempArray];
        } else { //尾部加载
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(wself.datasource.count == 0){
            [Utility showTipViewOn:wself.tableview type:0 iconName:@"tipview无收藏" msg:@"暂无粉丝"];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FanTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FanTableViewCell" forIndexPath:indexPath];
    [cell fullData:self.datasource[indexPath.row]];
    return cell;
}

#pragma mark - helper

-(void)addMJRefresh
{
    __weak FansListViewController* wself = self;
    self.tableview.mj_header = [LLRefreshGifHeader headerWithRefreshingBlock:^{
        wself.isMJHeaderRefresh = YES; //重要代码
//        wself.pageIndex=1;
        wself.lastFanId = nil;
        [wself requestFansWithLastFanId:wself.lastFanId];
        [wself impactLight];
    }];
    
    self.tableview.mj_footer = [LLRefreshAutoGifFooter footerWithRefreshingBlock:^{
         wself.isMJFooterRefresh = YES;
//         wself.pageIndex++;
        if(wself.datasource.count > 0){
            FansModel* fansModel = wself.datasource.lastObject;
            if(fansModel.id.toString){
                wself.lastFanId = fansModel.id.toString;
                [wself requestFansWithLastFanId:wself.lastFanId];
                [wself impactLight];
            }
        }
    }];
    [self.tableview.mj_header beginRefreshing];
}

@end
