//
//  FootMarkSimilarGoodsViewController.m
//  600生活
//
//  Created by iOS on 2019/11/13.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "FootMarkSimilarGoodsViewController.h"
#import "FootMarkSimilarGoodTableViewCell.h"  //cell
#import "SimilarGoodModel.h"    //相似商品模型
#import "GoodDetailViewController.h"


@interface FootMarkSimilarGoodsViewController ()
@property(nonatomic,strong)NSNumber* cat;
@end

@implementation FootMarkSimilarGoodsViewController

-(id)initWithCat:(NSNumber*)cat
{
    if(self = [super init]){
        self.cat = cat;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     self.title = @"更多相似商品";
    [self setupTableView];
}

#pragma mark - UI
-(void)setupTableView
{
    self.tableview.height = kScreenHeight - kNavigationBarHeight - kIPhoneXHomeIndicatorHeight;
    self.tableview.delegate = (id)self;
    self.tableview.dataSource = (id)self;
    self.tableview.estimatedRowHeight = 140;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addMJRefresh];
    [self.tableview registerNib:[UINib nibWithNibName:@"FootMarkSimilarGoodTableViewCell" bundle:nil] forCellReuseIdentifier:@"FootMarkSimilarGoodTableViewCell"];
}

#pragma mark - 网络请求
-(void)requestSimilarGoods:(NSInteger)pageIndex
{
     NSDictionary* param = @{
           @"page":[NSNumber numberWithInteger:pageIndex],
           @"page_size":@"10",
           @"cat":self.cat
         };
    [self GetWithUrlStr:kFullUrl(kSimilarGoods) param:param showHud:YES resCache:^(id  _Nullable cacheData) {
        if(kSuccessCache){
            [self handleSimilarGoods:pageIndex datas:cacheData[@"data"]];
        }
    } success:^(id  _Nullable res) {
        if(kSuccessRes){
            [self handleSimilarGoods:pageIndex datas:res[@"data"]];
        }
    } falsed:^(NSError * _Nullable error) {
        
    }];
}

-(void)handleSimilarGoods:(NSInteger)pageIndex datas:(NSArray*)list
{
       NSMutableArray* mutArr = [NSMutableArray new];
       for(int i = 0; i < list.count; i++){
           NSError* err = nil;
           SimilarGoodModel* similarGoodModel = [[SimilarGoodModel alloc]initWithDictionary:list[i] error:&err];
           if(similarGoodModel){
               [mutArr addObject:similarGoodModel];
           } else {
               NSLog(@"相似商品模型创建失败");
           }
       }
    [self configDataSource:mutArr];
}

-(void)configDataSource:(NSArray*)tempArray
{
    __weak FootMarkSimilarGoodsViewController* wself = self;
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
    return self.datasource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FootMarkSimilarGoodTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FootMarkSimilarGoodTableViewCell" forIndexPath:indexPath];
    [cell fullData:self.datasource[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SimilarGoodModel* similarGoodModel = [self.datasource objectAtIndex:indexPath.row];
    if(similarGoodModel.item_id){
        GoodDetailViewController* vc = [[GoodDetailViewController alloc]initWithItem_id:similarGoodModel.item_id];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [[LLHudHelper sharedInstance]tipMessage:@"数据异常"];
    }
}

#pragma mark - helper

-(void)addMJRefresh
{
    __weak FootMarkSimilarGoodsViewController* wself = self;
    self.tableview.mj_header = [LLRefreshGifHeader headerWithRefreshingBlock:^{
        wself.isMJHeaderRefresh = YES; //重要代码
        //获取评论数据
        wself.pageIndex=1;
        [wself requestSimilarGoods:wself.pageIndex];
        [wself impactLight];
    }];
    
    self.tableview.mj_footer = [LLRefreshAutoGifFooter footerWithRefreshingBlock:^{
         wself.isMJFooterRefresh = YES;
        //获取评论数据
        wself.pageIndex++;
        [wself requestSimilarGoods:wself.pageIndex];
        [wself impactLight];
    }];
    
    [self.tableview.mj_header beginRefreshing];
}

@end
