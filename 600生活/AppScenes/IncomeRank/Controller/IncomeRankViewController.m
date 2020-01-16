//
//  IncomeRankViewController.m
//  600生活
//
//  Created by iOS on 2019/12/26.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "IncomeRankViewController.h"
#import "IncomeRankModel.h"
#import "IncomeRankTableViewCell.h"
#import "LLBaseView.h"
@interface IncomeRankViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet LLBaseView *contentViewlayoutBottomLine;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@end

@implementation IncomeRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"收益排行";
    
    self.tableHeaderView.width = kScreenWidth - 15 * 2;
    
    [self.tableview removeFromSuperview];
    [self.contentView addSubview:self.tableview];
    self.tableview.tableHeaderView = self.tableHeaderView;
    self.tableview.showsVerticalScrollIndicator = NO;
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.width = kScreenWidth - 15 * 2;
    self.tableview.left = 15;
    self.tableview.top = self.timeLab.bottom + 40;
    self.tableview.height = kScreenHeight - kNavigationBarHeight - kIPhoneXHomeIndicatorHeight - self.tableview.top - 15;
    
    UIView* footer = [UIView new];
    footer.width = self.tableview.width;
    footer.height = 10;
    footer.backgroundColor = [UIColor whiteColor];
    footer.layer.cornerRadius = 5;
    footer.layer.maskedCorners = kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner;
    footer.clipsToBounds = YES;
    self.tableview.tableFooterView = footer;
    
    self.tableview.layer.cornerRadius = 5;
    self.tableview.clipsToBounds = YES;
    
    self.contentView.width = kScreenWidth;
    self.contentView.left = self.contentView.top = 0;
    __weak IncomeRankViewController* wself = self;
    self.contentViewlayoutBottomLine.viewDidLayoutNewFrameCallBack = ^(CGRect newFrame) {
        wself.contentView.height = newFrame.origin.y + newFrame.size.height;
    };
    
    self.scrollView.delegate = (id)self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.scrollView addSubview:self.contentView];
    [self setupBottomTableView];
    
    [self requestTeamRankList];
}

#pragma mark - UI

-(void)setupBottomTableView
{
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = (id)self;
    self.tableview.dataSource = (id)self;
    [self.tableview registerNib:[UINib nibWithNibName:@"IncomeRankTableViewCell" bundle:nil] forCellReuseIdentifier:@"IncomeRankTableViewCell"];
//    [self addMJRefresh];
}

#pragma mark - 网络请求 kTeamTop

-(void)requestTeamRankList
{
      [self GetWithUrlStr:kFullUrl(kTeamTop) param:nil showHud:YES resCache:nil success:^(id  _Nullable res) {
          if(kSuccessRes){
              [self handleIncomeRankList:res[@"data"]];
          }
      } falsed:^(NSError * _Nullable error) {
          
      }];
}

-(void)handleIncomeRankList:(NSDictionary*)data
{
    NSString* timeStr = data[@"time"];
    
    __weak IncomeRankViewController* wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
       wself.timeLab.text = timeStr;
    });
    
    
    NSMutableArray* mutArr = [NSMutableArray new];
    NSArray* list = [[NSArray alloc]initWithArray:data[@"data"]];
    for(int i = 0; i < list.count; i++){
        NSError* err = nil;
        IncomeRankModel* incomeRankModel = [[IncomeRankModel alloc]initWithDictionary:list[i] error:&err];
        if(incomeRankModel){
            [mutArr addObject:incomeRankModel];
        }
    }
    [self configDataSource:mutArr];
}

-(void)configDataSource:(NSArray*)tempArray
{
    __weak IncomeRankViewController* wself = self;
    if (tempArray.count > 0) { //有数据
        self.datasource = [[NSMutableArray alloc]initWithArray:tempArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself.tableview reloadData];
        });
    } else { //无数据
        dispatch_async(dispatch_get_main_queue(), ^{
            if(wself.datasource.count > 0){
                 [wself.tableview.mj_footer endRefreshingWithNoMoreData];
            }
        });
    }
    
    if(self.datasource.count > 0){
        [Utility dismissTipViewOn:self.tableview];
    }else{
        [Utility dismissTipViewOn:self.tableview];
        [Utility showTipViewOn:self.tableview type:0 iconName:@"tipview未查到订单" msg:@"暂无排行数据"];
    }
}

#pragma mark - tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IncomeRankTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"IncomeRankTableViewCell" forIndexPath:indexPath];
    [cell fullData:self.datasource[indexPath.row] indexPath:indexPath];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


#pragma mark - helper

-(void)addMJRefresh
{
    __weak IncomeRankViewController* wself = self;
    
    self.tableview.mj_header = [LLRefreshGifHeader headerWithRefreshingBlock:^{
        wself.isMJHeaderRefresh = YES; //重要代码
        [wself requestTeamRankList];
        [wself impactLight];
    }];
    
    [self.tableview.mj_header beginRefreshing];
}
@end
