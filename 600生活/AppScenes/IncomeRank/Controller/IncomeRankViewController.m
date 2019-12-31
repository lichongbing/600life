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

@end

@implementation IncomeRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"收益排行";
    
    [self.contentView addSubview:self.tableHeaderView];
    self.tableHeaderView.layer.cornerRadius = 5;
    self.tableHeaderView.clipsToBounds = YES;
    self.tableHeaderView.width = kScreenWidth - 15 * 2;
    self.tableHeaderView.top = self.scrollView.height * 0.4;
    self.tableHeaderView.left = 15;
    
    [self.tableview removeFromSuperview];
    [self.contentView addSubview:self.tableview];
    self.tableview.showsVerticalScrollIndicator = NO;
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.layer.cornerRadius = 5;
    self.tableview.clipsToBounds = YES;
    self.tableview.width = kScreenWidth - 15 * 2;
    self.tableview.left = 15;
    self.tableview.top = self.tableHeaderView.bottom - 5;
    self.tableview.height = kScreenHeight - kNavigationBarHeight - kIPhoneXHomeIndicatorHeight - self.tableview.top - 15;
    
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

#pragma mark - 网络请求
-(void)requestIncomeRankListWithPageIndex:(NSInteger)pageIndex
{
    NSDictionary* param = @{
        @"page" : [NSNumber numberWithInteger:pageIndex],
        @"page_size" : @"10",
        @"activity_type" : @"bestsales"
      };
      
      [self PostWithUrlStr:kFullUrl(kGetActivityGoods) param:param showHud:YES resCache:nil success:^(id  _Nullable res) {
          if(kSuccessRes){
              [self handleIncomeRankListWithPageIndex: pageIndex data:res[@"data"]];
          }
      } falsed:^(NSError * _Nullable error) {
          
      }];
}

-(void)handleIncomeRankListWithPageIndex:(NSInteger)pageIndex data:(NSDictionary*)data
{
//    NSString* bannerUrlStr = data[@"banner"];
//    __weak TreasureGoodViewController* wself = self;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [wself.bgImageView sd_setImageWithURL:[NSURL URLWithString:bannerUrlStr] placeholderImage:[UIImage imageNamed:@"人气宝贝_bg"]];
//    });
//
//    NSArray* goods_list = data[@"goods_list"];
//    NSMutableArray* mutArr = [NSMutableArray new];
//    for(int i = 0; i < goods_list.count; i++){
//        NSError* err = nil;
//        TreasureGood* treasureGood = [[TreasureGood alloc]initWithDictionary:goods_list[i] error:&err];
//        if(treasureGood){
//            [mutArr addObject:treasureGood];
//        } else {
//
//        }
//    }
    [self configDataSource:nil];
}

-(void)configDataSource:(NSArray*)tempArray
{
    __weak IncomeRankViewController* wself = self;
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
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IncomeRankTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"IncomeRankTableViewCell" forIndexPath:indexPath];
    [cell fullData:nil indexPath:indexPath];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    TreasureGood* treasureGood = [self.datasource objectAtIndex:indexPath.row];
//    if(treasureGood.item_id){
//        GoodDetailViewController* vc = [[GoodDetailViewController alloc]initWithItem_id:treasureGood.item_id];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
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
        //获取评论数据
        wself.pageIndex=1;
//        [wself requestActivityGoods_BestSalesWithPageIndex:wself.pageIndex];
        [wself impactLight];
    }];
    
    self.tableview.mj_footer = [LLRefreshAutoGifFooter footerWithRefreshingBlock:^{
         wself.isMJFooterRefresh = YES;
        //获取评论数据
        wself.pageIndex++;
//        [wself requestActivityGoods_BestSalesWithPageIndex:wself.pageIndex];
        [wself impactLight];
    }];
    
    [self.tableview.mj_header beginRefreshing];
}
@end
