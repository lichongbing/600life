//
//  ExclusiveViewController.m
//  600生活
//
//  Created by iOS on 2019/11/21.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "ExclusiveViewController.h"
#import "ExcluseveTableViewCell.h"
#import "WelFareGoodModel.h"
#import "GoodDetailViewController.h" //商品详情

@interface ExclusiveViewController ()

@end

@implementation ExclusiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"独家福利购";
    [self setupTableview];
}

#pragma mark - 网络请求
-(void)requestWelfareBuyWithPageIndex:(NSInteger)pageIndex
{
    NSDictionary* param = @{
        @"page" : [NSNumber numberWithInteger:pageIndex],
        @"page_size" : @"6"
    };
    
    __weak ExclusiveViewController* wself = self;
    [self GetWithUrlStr:kFullUrl(kWelfareBuy) param:param showHud:YES resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes){
            [wself handleWelfareBuyWithPageIndex:pageIndex data:res[@"data"]];
        }
    } falsed:^(NSError * _Nullable error) {
        
    }];
}

-(void)handleWelfareBuyWithPageIndex:(NSInteger)pageIndex data:(NSDictionary*)data
{
    NSString* bannerUrlStr = data[@"banner"];
    if(bannerUrlStr){
        __weak ExclusiveViewController* wself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [((UIImageView*)wself.tableview.tableHeaderView) sd_setImageWithURL:[NSURL URLWithString:bannerUrlStr] placeholderImage:[UIImage imageNamed:@"独家福利购_bg"]];
        });
    }
    
    NSArray* goods_list = data[@"goods_list"];
    NSMutableArray* mutArr = [NSMutableArray new];
    
    for(int i = 0; i < goods_list.count; i++){
        NSError* err = nil;
        WelFareGoodModel* welFareGoodModel = [[WelFareGoodModel alloc]initWithDictionary:goods_list[i] error:&err];
        if(welFareGoodModel){
            [mutArr addObject:welFareGoodModel];
        } else {
            
        }
    }
    [self configDataSource:mutArr];
}

-(void)configDataSource:(NSArray*)tempArray
{
    __weak ExclusiveViewController* wself = self;
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

#pragma mark - UI

-(void)setupTableview
{
    UIImageView* imageView = [UIImageView new];
    imageView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth * 245 / 375);
    imageView.image = [UIImage imageNamed:@"独家福利购_bg"];
    self.tableview.tableHeaderView = imageView;
    
    self.tableview.height = kScreenHeight - kNavigationBarHeight - kIPhoneXHomeIndicatorHeight -5;
    self.tableview.top = 5;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = (id)self;
    self.tableview.dataSource = (id)self;
    [self.tableview registerNib:[UINib nibWithNibName:@"ExcluseveTableViewCell" bundle:nil] forCellReuseIdentifier:@"ExcluseveTableViewCell"];
    [self addMJRefresh];
}

#pragma mark - tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray* mutArr = [NSMutableArray new];
    for(int i = 0; i < self.datasource.count; i++){//self.datasource.count/2 是整数
        NSMutableArray* item = [NSMutableArray new];
        if(i%2 == 0) {
            //基数个 左边model
            WelFareGoodModel* modelLeft = nil;
            if(self.datasource.count > i){
                modelLeft = self.datasource[i];
            }else{
                modelLeft = [WelFareGoodModel new];
            }
            
            WelFareGoodModel* modelRight = nil;
            if(self.datasource.count > (i+1)){
                modelRight = self.datasource[i+1];
            }else{
                modelRight = [WelFareGoodModel new];
            }
            
            [item addObject:modelLeft];
            [item addObject:modelRight];
            [mutArr addObject:item];
        }
    }
    return mutArr.count;
}

#pragma mark - 此处有回调
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExcluseveTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ExcluseveTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSMutableArray* mutArr = [NSMutableArray new];
    for(int i = 0; i < self.datasource.count; i++){//self.datasource.count/2 是整数
        NSMutableArray* item = [NSMutableArray new];
        if(i%2 == 0) {
            //基数个
            WelFareGoodModel* modelLeft = nil;
            if(self.datasource.count > i){
                modelLeft = self.datasource[i];
            }else{
                modelLeft = [WelFareGoodModel new];
            }
            
            WelFareGoodModel* modelRight = nil;
            if(self.datasource.count > (i+1)){
                modelRight = self.datasource[i+1];
            }else{
                modelRight = [WelFareGoodModel new];
            }
            
            [item addObject:modelLeft];
            [item addObject:modelRight];
            [mutArr addObject:item];
        }
    }
    
    NSArray* item = mutArr[indexPath.row];
    
    [cell fullDataWithLeftModel:item.firstObject rightModel:item.lastObject];
    
    cell.welFareGoodClickedCallBack = ^(WelFareGoodModel * _Nonnull welFareGoodModel) {
        if(welFareGoodModel.item_id){
            GoodDetailViewController* vc = [[GoodDetailViewController alloc]initWithItem_id:welFareGoodModel.item_id];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [[LLHudHelper sharedInstance]tipMessage:@"商品数据异常"];
        }
    };
    
    return cell;
    
}

#pragma mark - helper

-(void)addMJRefresh
{
    __weak ExclusiveViewController* wself = self;
    self.tableview.mj_header = [LLRefreshGifHeader headerWithRefreshingBlock:^{
        wself.isMJHeaderRefresh = YES; //重要代码
        //获取评论数据
        wself.pageIndex=1;
        [wself requestWelfareBuyWithPageIndex:wself.pageIndex];
        [wself impactLight];
    }];
    
    self.tableview.mj_footer = [LLRefreshAutoGifFooter footerWithRefreshingBlock:^{
         wself.isMJFooterRefresh = YES;
        //获取评论数据
         wself.pageIndex++;
         [wself requestWelfareBuyWithPageIndex:wself.pageIndex];
        [wself impactLight];
    }];
    [self.tableview.mj_header beginRefreshing];
}

@end
