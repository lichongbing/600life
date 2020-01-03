//
//  HightMoneyRandViewController.m
//  600生活
//
//  Created by iOS on 2019/11/21.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "GaoYongViewController.h"
#import "GaoYongTableViewCell.h"
#import "GaoYongGood.h"
#import "GoodDetailViewController.h"

@interface GaoYongViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *toolBar;
//@property (weak, nonatomic) IBOutlet UITableView *tableview;

//commissionCategory: 人气热销(0),高额佣金(1),大牌推荐(2),今日上架(3)
@property(nonatomic,assign)NSInteger commissionCategory;

@end

@implementation GaoYongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"高佣优选";
    self.contentView.width = kScreenWidth;
    
    self.bgImageView.width = self.contentView.width;
    self.bgImageView.height = self.bgImageView.width * 175 / 375 ;
    
    //设置tableview的header
    self.toolBar.width = kScreenWidth;
    self.toolBar.height = 40;
    self.toolBar.left = 0;
    self.toolBar.top = self.bgImageView.bottom;
    
    //设置table
    [self.tableview removeFromSuperview];
    [self.contentView addSubview:self.tableview];
    UIView* tableFooter = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    self.tableview.tableFooterView = tableFooter;
    tableFooter.backgroundColor = [UIColor colorWithHexString:@"#EB745C"];
    self.tableview.width = self.contentView.width;
    self.tableview.top = self.toolBar.bottom;
    self.tableview.height = kScreenHeight - kNavigationBarHeight - kIPhoneXHomeIndicatorHeight - self.toolBar.height;
    self.contentView.height = self.tableview.bottom;
    
    self.scrollView.delegate = (id)self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.scrollView addSubview:self.contentView];
    self.tableview.scrollEnabled = NO;  //初始状态下，先让scrollView可以滑动，tableview无法滑动
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, self.contentView.height );
    [self setupBottomTableView];
    
    //toolbar 第一个按钮默认点选
    UIButton* btn = [self.toolBar viewWithTag:1];
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitleColor:[UIColor colorWithHexString:@"F5290B"] forState:UIControlStateNormal];
}

#pragma mark - UI

-(void)setupBottomTableView
{
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = (id)self;
    self.tableview.dataSource = (id)self;
    [self.tableview registerNib:[UINib nibWithNibName:@"GaoYongTableViewCell" bundle:nil] forCellReuseIdentifier:@"GaoYongTableViewCell"];
    [self addMJRefresh];
}


#pragma mark - 网络请求

//形参2 commissionCategory: 人气热销(0),高额佣金(1),大牌推荐(2),今日上架(3),默认0
-(void)requestActivityGoods_GaoYongWithPageIndex:(NSInteger)pageIndex commissionCategory:(NSInteger)commissionCategory
{
    NSDictionary* param = @{
        @"page" : [NSNumber numberWithInteger:pageIndex],
        @"page_size" : @"10",
        @"activity_type" : @"gaoyong",
        @"commission_category":[NSString stringWithFormat:@"%lu",commissionCategory]
      };
      
      [self PostWithUrlStr:kFullUrl(kGetActivityGoods) param:param showHud:YES resCache:nil success:^(id  _Nullable res) {
          if(kSuccessRes){
              [self handleActivityGoods_GaoYongWithPageIndex: pageIndex data:res[@"data"]];
          }
      } falsed:^(NSError * _Nullable error) {
          
      }];
}

-(void)handleActivityGoods_GaoYongWithPageIndex:(NSInteger)pageIndex data:(NSDictionary*)data
{
    NSString* bannerUrlStr = data[@"banner"];
    __weak GaoYongViewController* wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [wself.bgImageView sd_setImageWithURL:[NSURL URLWithString:bannerUrlStr] placeholderImage:[UIImage imageNamed:@"高佣优选_bg"]];
    });
    
    NSArray* goods_list = data[@"goods_list"];
    NSMutableArray* mutArr = [NSMutableArray new];
    for(int i = 0; i < goods_list.count; i++){
        NSError* err = nil;
        GaoYongGood* gaoYongGood = [[GaoYongGood alloc]initWithDictionary:goods_list[i] error:&err];
        if(gaoYongGood){
            [mutArr addObject:gaoYongGood];
        } else {
            
        }
    }
    [self configDataSource:mutArr];
}


-(void)configDataSource:(NSArray*)tempArray
{
    __weak GaoYongViewController* wself = self;
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
    GaoYongTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GaoYongTableViewCell" forIndexPath:indexPath];
    [cell fullData:self.datasource[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GaoYongGood* gaoYongGood = [self.datasource objectAtIndex:indexPath.row];
    if(gaoYongGood.item_id){
        GoodDetailViewController* vc = [[GoodDetailViewController alloc]initWithItem_id:gaoYongGood.item_id];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == self.scrollView){
        CGFloat constTop = self.toolBar.top;
        CGFloat scrollViewOffSetY = self.scrollView.contentOffset.y;
        
        if(scrollViewOffSetY >= constTop){
            self.scrollView.contentOffset = CGPointMake(0, constTop);
            self.scrollView.scrollEnabled = NO;
            self.tableview.scrollEnabled = YES;
        }
        
        
        CGFloat oldWidth = kScreenWidth; // 图片原始宽度
        CGFloat oldHeight = kScreenWidth * 175 / 375 ; // 图片原始高度
        
        if (scrollViewOffSetY < 0) {
//           self.bgImageView.frame = CGRectMake(0, -scrollViewOffSetY, kScreenWidth , yOffset);
            CGFloat totalOffset = oldHeight + ABS(scrollViewOffSetY);
            CGFloat f = totalOffset / oldHeight; //背书
            self.bgImageView.frame = CGRectMake(- (oldWidth * f - oldWidth) / 2, scrollViewOffSetY, oldWidth * f, totalOffset);// 拉伸后的图片的frame应该是同比例缩放
        }
        
    }

    if(scrollView == self.tableview){
        CGFloat tableViewOffSetY = self.tableview.contentOffset.y;
        if(tableViewOffSetY <= 0){
            self.tableview.contentOffset = CGPointMake(0, 0);
            self.tableview.scrollEnabled = NO;
            self.scrollView.scrollEnabled = YES;
        }
    }
}

#pragma mark - control action
- (IBAction)toolBarItemAction:(UIButton*)sender {
    [self clearAllBtns];
    [self SelectBtn:sender];
}


#pragma mark - helper

-(void)clearAllBtns
{
    for(int tag = 1; tag < 5; tag++){
        UIButton* btn = [self.toolBar viewWithTag:tag];
        btn.backgroundColor = [UIColor clearColor];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

-(void)SelectBtn:(UIButton*)btn
{
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitleColor:[UIColor colorWithHexString:@"F5290B"] forState:UIControlStateNormal];
    self.commissionCategory = btn.tag - 1;
    
    self.pageIndex = 1;
    [self requestActivityGoods_GaoYongWithPageIndex:self.pageIndex commissionCategory:self.commissionCategory];
}

#pragma mark - helper

-(void)addMJRefresh
{
    __weak GaoYongViewController* wself = self;
    
    self.tableview.mj_header = [LLRefreshGifHeader headerWithRefreshingBlock:^{
        wself.isMJHeaderRefresh = YES; //重要代码
        //获取评论数据
        wself.pageIndex=1;
        [wself requestActivityGoods_GaoYongWithPageIndex:wself.pageIndex commissionCategory:self.commissionCategory];
        [wself impactLight];
    }];
    
    self.tableview.mj_footer = [LLRefreshAutoGifFooter footerWithRefreshingBlock:^{
         wself.isMJFooterRefresh = YES;
        //获取评论数据
         wself.pageIndex++;
         [wself requestActivityGoods_GaoYongWithPageIndex:wself.pageIndex commissionCategory:self.commissionCategory];
        [wself impactLight];
    }];
    
    [self.tableview.mj_header beginRefreshing];
}

@end
