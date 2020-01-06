//
//  JDCategorySubViewController.m
//  600生活
//
//  Created by iOS on 2020/1/2.
//  Copyright © 2020 灿男科技. All rights reserved.
//

#import "JDCategorySubViewController.h"
#import "JDTwoItemGoodTableViewCell.h"

@interface JDCategorySubViewController ()

@property(nonatomic,strong)JDCategoryModel*jdCategoryModel;

@end

@implementation JDCategorySubViewController

-(id)initWithJDCategoryModel:(JDCategoryModel*)jdCategoryModel
{
    if(self = [super init]){
        self.jdCategoryModel = jdCategoryModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupTable];
}

-(void)setupTable
{
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = (id)self;
    self.tableview.dataSource = (id)self;
    [self.tableview registerNib:[UINib nibWithNibName:@"JDTwoItemGoodTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDTwoItemGoodTableViewCell"];

    self.tableview.top = 40;
    self.tableview.left = 0;
    self.tableview.width = kScreenWidth;
    self.tableview.height = kScreenHeight - kNavigationBarHeight - kIPhoneXHomeIndicatorHeight - _superVCViewBannerImageViewHeight;

    [self addMJRefresh];
}

-(void)loadDatasWhenUserDone
{
    __weak JDCategorySubViewController* wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [wself.tableview.mj_header beginRefreshing];
    });
}

#pragma mark - 网络请求
//获取活动商品分类数据
-(void)requestSearchJDGoodsWithPageIndex:(NSInteger)pageIndex
{
    NSDictionary* param = @{
        @"page":[NSNumber numberWithInteger:pageIndex],
        @"page_size":@"10",
        @"cid":self.jdCategoryModel.cid.toString,
      };

      [self GetWithUrlStr:kFullUrl(kJDGoodsSearch) param:param showHud:NO resCache:nil success:^(id  _Nullable res) {
          if(kSuccessRes){
              [self handleSearchJDGoodsWithPageIndex:pageIndex datas:res[@"data"]];
          }
      } falsed:^(NSError * _Nullable error) {

      }];
}

-(void)handleSearchJDGoodsWithPageIndex:(NSInteger)pageIndex datas:(NSArray*)datas
{
    NSArray* list = datas;
    NSMutableArray* mutArr = [NSMutableArray new];
    for(int i = 0; i < list.count; i++){
        NSError* err = nil;
        JDGood* jdGood = [[JDGood alloc]initWithDictionary:list[i] error:&err];
        if(jdGood){
            [mutArr addObject:jdGood];
        } else {
            NSLog(@"京东商品模型创建失败");
        }
    }
    [self configDataSource:mutArr];
}

-(void)configDataSource:(NSArray*)tempArray
{
    __weak JDCategorySubViewController* wself = self;
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(wself.datasource.count == 0){
            [Utility showTipViewOn:wself.tableview type:0 iconName:@"tipview无浏览记录" msg:@"没有足迹哟!"];
        }else{
            [Utility dismissTipViewOn:wself.tableview];
        }
    });
}

#pragma mark - tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray* mutArr = [NSMutableArray new];
    for(int i = 0; i < self.datasource.count; i++){//self.datasource.count/2 是整数
        NSMutableArray* item = [NSMutableArray new];
        if(i%2 == 0) {
            //基数个 左边model
            JDGood* modelLeft = nil;
            if(self.datasource.count > i){
                modelLeft = self.datasource[i];
            }else{
                modelLeft = [JDGood new];
            }
            
            JDGood* modelRight = nil;
            if(self.datasource.count > (i+1)){
                modelRight = self.datasource[i+1];
            }else{
                modelRight = [JDGood new];
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
    JDTwoItemGoodTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JDTwoItemGoodTableViewCell" forIndexPath:indexPath];

    NSMutableArray* mutArr = [NSMutableArray new];
    for(int i = 0; i < self.datasource.count; i++){//self.datasource.count/2 是整数
        NSMutableArray* item = [NSMutableArray new];
        if(i%2 == 0) {
            //基数个
            JDGood* modelLeft = nil;
            if(self.datasource.count > i){
                modelLeft = self.datasource[i];
            }else{
                modelLeft = [JDGood new];
            }
            
            JDGood* modelRight = nil;
            if(self.datasource.count > (i+1)){
                modelRight = self.datasource[i+1];
            }else{
                modelRight = [JDGood new];
            }
            
            [item addObject:modelLeft];
            [item addObject:modelRight];
            [mutArr addObject:item];
        }
    }
    
    NSArray* item = mutArr[indexPath.row];
    
    [cell fullDataWithLeftModel:item.firstObject rightModel:item.lastObject];
    return cell;
}

-(void)addMJRefresh
{
    __weak JDCategorySubViewController* wself = self;
    self.tableview.mj_header = [LLRefreshGifHeader headerWithRefreshingBlock:^{
        wself.isMJHeaderRefresh = YES; //重要代码
        wself.pageIndex=1;
        [wself requestSearchJDGoodsWithPageIndex:wself.pageIndex];
        [wself impactLight];
    }];
    
    self.tableview.mj_footer = [LLRefreshAutoGifFooter footerWithRefreshingBlock:^{
         wself.isMJFooterRefresh = YES;
         wself.pageIndex++;
         [wself requestSearchJDGoodsWithPageIndex:wself.pageIndex];
        [wself impactLight];
    }];
}

@end
