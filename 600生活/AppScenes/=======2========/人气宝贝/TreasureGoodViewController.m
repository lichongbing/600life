//
//  BabyGoodViewController.m
//  600生活
//
//  Created by iOS on 2019/11/21.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "TreasureGoodViewController.h"
#import "TreasureGoodTableViewCell.h"
#import "TreasureGood.h"
#import "GoodDetailViewController.h"

@interface TreasureGoodViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@end

@implementation TreasureGoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"人气宝贝";
    self.contentView.width = kScreenWidth;
    
    self.bgImageView.width = self.contentView.width;
    self.bgImageView.height = self.bgImageView.width * 175 / 375 ;
    
    [self.tableview removeFromSuperview];
    [self.contentView addSubview:self.tableview];
    self.tableview.width = self.contentView.width;
    self.tableview.top = self.bgImageView.bottom;
    self.tableview.height = kScreenHeight - kNavigationBarHeight - kIPhoneXHomeIndicatorHeight;
    self.contentView.height = self.tableview.bottom;
    
    self.scrollView.delegate = (id)self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.scrollView addSubview:self.contentView];
    self.tableview.scrollEnabled = NO;  //初始状态下，先让scrollView可以滑动，tableview无法滑动
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, self.contentView.height );
    [self setupBottomTableView];
}

#pragma mark - UI

-(void)setupBottomTableView
{
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = (id)self;
    self.tableview.dataSource = (id)self;
    [self.tableview registerNib:[UINib nibWithNibName:@"TreasureGoodTableViewCell" bundle:nil] forCellReuseIdentifier:@"TreasureGoodTableViewCell"];
    [self addMJRefresh];
}

#pragma mark - 网络请求
-(void)requestActivityGoods_BestSalesWithPageIndex:(NSInteger)pageIndex
{
    NSDictionary* param = @{
        @"page" : [NSNumber numberWithInteger:pageIndex],
        @"page_size" : @"10",
        @"activity_type" : @"bestsales"
      };
      
      [self PostWithUrlStr:kFullUrl(kGetActivityGoods) param:param showHud:YES resCache:nil success:^(id  _Nullable res) {
          if(kSuccessRes){
              [self handleActivityGoods_BestSalesWithPageIndex: pageIndex data:res[@"data"]];
          }
      } falsed:^(NSError * _Nullable error) {
          
      }];
}

-(void)handleActivityGoods_BestSalesWithPageIndex:(NSInteger)pageIndex data:(NSDictionary*)data
{
    NSString* bannerUrlStr = data[@"banner"];
    __weak TreasureGoodViewController* wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [wself.bgImageView sd_setImageWithURL:[NSURL URLWithString:bannerUrlStr] placeholderImage:[UIImage imageNamed:@"人气宝贝_bg"]];
    });
    
    NSArray* goods_list = data[@"goods_list"];
    NSMutableArray* mutArr = [NSMutableArray new];
    for(int i = 0; i < goods_list.count; i++){
        NSError* err = nil;
        TreasureGood* treasureGood = [[TreasureGood alloc]initWithDictionary:goods_list[i] error:&err];
        if(treasureGood){
            [mutArr addObject:treasureGood];
        } else {
            
        }
    }
    [self configDataSource:mutArr];
}


-(void)configDataSource:(NSArray*)tempArray
{
    __weak TreasureGoodViewController* wself = self;
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
    TreasureGoodTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TreasureGoodTableViewCell" forIndexPath:indexPath];
    [cell fullData:self.datasource[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TreasureGood* treasureGood = [self.datasource objectAtIndex:indexPath.row];
    if(treasureGood.item_id){
        GoodDetailViewController* vc = [[GoodDetailViewController alloc]initWithItem_id:treasureGood.item_id];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == self.scrollView){
        CGFloat constTop = self.tableview.top;
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

#pragma mark - helper

-(void)addMJRefresh
{
    __weak TreasureGoodViewController* wself = self;
    
    self.tableview.mj_header = [LLRefreshGifHeader headerWithRefreshingBlock:^{
        wself.isMJHeaderRefresh = YES; //重要代码
        //获取评论数据
        wself.pageIndex=1;
        [wself requestActivityGoods_BestSalesWithPageIndex:wself.pageIndex];
        [wself impactLight];
    }];
    
    self.tableview.mj_footer = [LLRefreshAutoGifFooter footerWithRefreshingBlock:^{
         wself.isMJFooterRefresh = YES;
        //获取评论数据
        wself.pageIndex++;
        [wself requestActivityGoods_BestSalesWithPageIndex:wself.pageIndex];
        [wself impactLight];
    }];
    
    [self.tableview.mj_header beginRefreshing];
}

@end
