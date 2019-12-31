//
//  GuessLikeViewController.m
//  600生活
//
//  Created by iOS on 2019/11/7.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "GuessLikeViewController.h"
#import "TwoGoodItemsTableViewCell.h"
#import "GuessLikeGoodModel.h"
#import "GoodDetailViewController.h"
#import "LoginAndRigistMainVc.h"

@interface GuessLikeViewController ()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation GuessLikeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupTableview];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)loadDatasWhenUserDone
{
    __weak GuessLikeViewController* wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [wself.tableview.mj_header beginRefreshing];
    });
}

-(void)setupTableview
{
    self.tableview.showsVerticalScrollIndicator = NO;
    self.tableview.height = kScreenHeight - kNavigationBarHeight - kTabbarHeight -50;
    self.tableview.estimatedRowHeight = 278;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = (id)self;
    self.tableview.dataSource = (id)self;
    [self.tableview registerNib:[UINib nibWithNibName:@"TwoGoodItemsTableViewCell" bundle:nil] forCellReuseIdentifier:@"TwoGoodItemsTableViewCell"];
    [self addMJRefresh];
}

#pragma mark - 网络请求
-(void)requestGuessLikeDataWithPageIndex:(NSInteger)pageIndex
{
    NSDictionary* param = @{
        @"page":[NSNumber numberWithInteger:self.pageIndex],
        @"page_size":@"10"
    };
    
    __weak GuessLikeViewController* wself = self;
    
    [self GetWithUrlStr:kFullUrl(kGuessLike) param:param showHud:NO resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes){
            [wself handleGuessLikeDataWithPageIndex:self.pageIndex data:res];
        }
    } falsed:^(NSError * _Nullable error) {
        
    }];
}

-(void)handleGuessLikeDataWithPageIndex:(NSInteger)pageIndex data:(NSDictionary*)data
{
    NSArray* goods_list = data[@"data"];
    NSMutableArray* mutArr = [NSMutableArray new];
    
       for(int i = 0; i < goods_list.count; i++){
           NSError* err = nil;
           GuessLikeGoodModel* guessLikeGoodModel = [[GuessLikeGoodModel alloc]initWithDictionary:goods_list[i] error:&err];
           if(guessLikeGoodModel){
               [mutArr addObject:guessLikeGoodModel];
           } else {
               NSLog(@"福利购商品转换失败");
           }
       }
    [self configDataSource:mutArr];
}

-(void)configDataSource:(NSArray*)tempArray
{
    __weak GuessLikeViewController* wself = self;
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
    NSMutableArray* mutArr = [NSMutableArray new];
    for(int i = 0; i < self.datasource.count; i++){//self.datasource.count/2 是整数
        NSMutableArray* item = [NSMutableArray new];
        if(i%2 == 0) {
            //基数个 左边model
            GuessLikeGoodModel* modelLeft = nil;
            if(self.datasource.count > i){
                modelLeft = self.datasource[i];
            }else{
                modelLeft = [GuessLikeGoodModel new];
            }
            
            GuessLikeGoodModel* modelRight = nil;
            if(self.datasource.count > (i+1)){
                modelRight = self.datasource[i+1];
            }else{
                modelRight = [GuessLikeGoodModel new];
            }
            
            [item addObject:modelLeft];
            [item addObject:modelRight];
            [mutArr addObject:item];
        }
    }
    return mutArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TwoGoodItemsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TwoGoodItemsTableViewCell" forIndexPath:indexPath];
    
    NSMutableArray* mutArr = [NSMutableArray new];
    for(int i = 0; i < self.datasource.count; i++){//self.datasource.count/2 是整数
        NSMutableArray* item = [NSMutableArray new];
        if(i%2 == 0) {
            //基数个
            GuessLikeGoodModel* modelLeft = nil;
            if(self.datasource.count > i){
                modelLeft = self.datasource[i];
            }else{
                modelLeft = [GuessLikeGoodModel new];
            }
            
            GuessLikeGoodModel* modelRight = nil;
            if(self.datasource.count > (i+1)){
                modelRight = self.datasource[i+1];
            }else{
                modelRight = [GuessLikeGoodModel new];
            }
            
            [item addObject:modelLeft];
            [item addObject:modelRight];
            [mutArr addObject:item];
        }
       
    }
    
    NSArray* item = mutArr[indexPath.row];
    
    [cell fullDataWithLeftModel:item.firstObject rightModel:item.lastObject];
    
    __weak GuessLikeViewController* wself = self;
    cell.guessLikeGoodClickedCallback = ^(GuessLikeGoodModel * _Nonnull guessLikeGoodModel) {
        if(guessLikeGoodModel.item_id){
            
            if([LLUserManager shareManager].currentUser == nil){
                __strong GuessLikeViewController* sself = wself;
                [Utility ShowAlert:@"尚未登录" message:@"\n是否登录" buttonName:@[@"好的,去登录",@"不用了,谢谢"] sureAction:^{
                    LoginAndRigistMainVc* vc = [LoginAndRigistMainVc new];
                    vc.hidesBottomBarWhenPushed = YES;
                    [sself.navigationController pushViewController:vc animated:YES];
                } cancleAction:nil];
                return;
            }
            
            GoodDetailViewController* vc = [[GoodDetailViewController alloc]initWithItem_id:guessLikeGoodModel.item_id];
            vc.hidesBottomBarWhenPushed = YES;
            [wself.navigationController pushViewController:vc animated:YES];
        }
    };
    return cell;
}


#pragma mark - helper
-(void)addMJRefresh
{
    __weak GuessLikeViewController* wself = self;
    self.tableview.mj_header = [LLRefreshGifHeader headerWithRefreshingBlock:^{
        wself.isMJHeaderRefresh = YES; //重要代码
        //获取评论数据
        wself.pageIndex=1;
        [wself requestGuessLikeDataWithPageIndex:wself.pageIndex];
        [wself impactLight];
    }];
    
    self.tableview.mj_footer = [LLRefreshAutoGifFooter footerWithRefreshingBlock:^{
         wself.isMJFooterRefresh = YES;
        //获取评论数据
         wself.pageIndex++;
         [wself requestGuessLikeDataWithPageIndex:wself.pageIndex];
        [wself impactLight];
    }];
}

@end
