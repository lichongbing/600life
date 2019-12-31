//
//  SearchResultListController.m
//  600生活
//
//  Created by iOS on 2019/11/11.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "SearchResultListController.h"
#import "GoodSelectToolBar.h" //工具栏
#import "SearchedGoodTableViewCell.h"//选取商品cell
#import "SearchedGoodModel.h"  //搜索出来的商品模型
#import "GoodDetailViewController.h"  //商品详情
#import "ZhongHeView.h"


@interface SearchResultListController ()<UITableViewDelegate,UITableViewDataSource,GoodSelectToolBarDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navBarHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navBarTopConstraint;
@property (weak, nonatomic) IBOutlet UIView *toolBarBg;
@property(nonatomic,strong)ZhongHeView* zhongHeView;

@end

@interface SearchResultListController()

@property(nonatomic,strong)NSString* keywords;
@property(nonatomic,assign)int sort;

@end

@implementation SearchResultListController

-(id)initWithKeyWords:(NSString*)keywords
{
    if(self = [super init]){
        self.keywords = keywords;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.width = kScreenWidth;
    
    _navBarHeightConstraint.constant = kNavigationBarHeight;
    _navBarTopConstraint.constant = -kStatusBarHeight;
    _searchBar.delegate = (id)self;
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    if(self.keywords){
        _searchBar.text = self.keywords;
    }
    
    
    //工具栏
    self.toolBarBg.width = kScreenWidth;
    GoodSelectToolBar* goodSelectToolBar = [[GoodSelectToolBar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    [self.toolBarBg addSubview:goodSelectToolBar];
    goodSelectToolBar.delegate = (id)self;
    goodSelectToolBar.tag = 288;
    goodSelectToolBar.top = goodSelectToolBar.left = 0;
    goodSelectToolBar.width = kScreenWidth;
//    
//    self.tableview.estimatedRowHeight = 140;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = (id)self;
    self.tableview.dataSource = (id)self;
    [self.tableview registerNib:[UINib nibWithNibName:@"SearchedGoodTableViewCell" bundle:nil] forCellReuseIdentifier:@"SearchedGoodTableViewCell"];
    self.tableview.top = kNavigationBarHeight + goodSelectToolBar.height;
    self.tableview.width = kScreenWidth;
    self.tableview.height = kScreenHeight - self.tableview.top - kIPhoneXHomeIndicatorHeight;
    
    [self addMJRefresh];
    
    //请求数据
    self.pageIndex = 1;
    [self requestSearchGoodsWithKeyWords:self.keywords sort:1 PageIndex:self.pageIndex is_counpon:0 start_price:nil end_price:nil is_tmall:@"N"];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenNavigationBarWithAnimation:animated];
    self.fd_prefersNavigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self showNavigationBarWithAnimation:animated];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    if(kIsIOS13()){
         return UIStatusBarStyleDarkContent;
    }else{
        return UIStatusBarStyleDefault; //黑色文字
    }
}

#pragma mark getter
- (ZhongHeView *)zhongHeView
{
    if(!_zhongHeView){
        GoodSelectToolBar* goodSelectToolBar = [self.toolBarBg viewWithTag:288];
        _zhongHeView = [[ZhongHeView alloc]initWithToolBar:goodSelectToolBar];
    }
    return _zhongHeView;
}

#pragma mark - 网络请求

/**
 sort 字段
 1：综合排序
 2：佣金比例由大到小
 3：预估收益由高到低
 4：价格由大到小
 5：价格由小到大
 6：月销量由大到小
 7：月销量由小到大
 */
-(void)requestSearchGoodsWithKeyWords:(NSString*)keywords
                                 sort:(int)sort
                            PageIndex:(NSInteger)pageIndex
                           is_counpon:(int)is_counpon  //是否有券 1-有 0-全部
                          start_price:(NSString*  __nullable)start_price //折扣价上限
                            end_price:(NSString* __nullable)end_price //折扣价下限
                             is_tmall:(NSString*)is_tmall //是否是天猫Y-天猫，N-全部
{
    NSMutableDictionary* param = [NSMutableDictionary new];
    [param setValue:keywords forKey:@"keyword"];
    if(sort > 0){
        [param setValue:[NSString stringWithFormat:@"%d",sort] forKey:@"sort"];
    }
    [param setValue:[NSNumber numberWithInteger:pageIndex] forKey:@"page"];
    [param setValue:[NSNumber numberWithInteger:10] forKey:@"page_size"];
    [param setValue:[NSNumber numberWithInt:is_counpon] forKey:@"is_counpon"];
    if(start_price){
        [param setValue:start_price forKey:@"start_price"];
    }
    if(end_price){
        [param setValue:start_price forKey:@"end_price"];
    }
    [param setValue:is_tmall forKey:@"is_tmall"];
    
    __weak SearchResultListController* wself = self;
    [self PostWithUrlStr:kFullUrl(kSearchGoods) param:param showHud:YES resCache:^(id  _Nullable cacheData) {
        if(kSuccessCache){
            [wself handleSearchGoodsWithPageIndex:pageIndex data:cacheData];
        }
    } success:^(id  _Nullable res) {
  
        if(kSuccessRes){
            [wself handleSearchGoodsWithPageIndex:pageIndex data:res];
        }
    } falsed:^(NSError * _Nullable error) {
    }];
}

-(void)handleSearchGoodsWithPageIndex:(NSInteger)pageIndex data:(NSDictionary*)data
{
    //处理主页数据
    NSArray* list = data[@"data"];
    NSMutableArray* mutArr = [NSMutableArray new];
    for(int i = 0; i < list.count; i++){
        NSError* err = nil;
        SearchedGoodModel* searchedGoodModel = [[SearchedGoodModel alloc]initWithDictionary:list[i] error:&err];
        if(searchedGoodModel){
            [mutArr addObject:searchedGoodModel];
        } else {
           
        }
    }
       
    [self configDataSource:mutArr];
}

-(void)configDataSource:(NSArray*)tempArray
{
    __weak SearchResultListController* wself = self;
    
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
    
    if(self.datasource.count > 0){
         [Utility dismissTipViewOn:self.tableview];
    }else{
        [Utility showTipViewOn:self.tableview type:0 iconName:@"tipview未查到订单" msg:@"未查到搜索结果!"];
    }
}

#pragma mark - control action

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableview delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchedGoodTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SearchedGoodTableViewCell" forIndexPath:indexPath];
    [cell fullData:self.datasource[indexPath.row] keywords:self.keywords];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchedGoodModel* searchedGoodModel = [self.datasource objectAtIndex:indexPath.row];
    if(searchedGoodModel.item_id){
        GoodDetailViewController* goodDetailVC = [[GoodDetailViewController alloc]initWithItem_id:searchedGoodModel.item_id];
        goodDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:goodDetailVC animated:YES];
    } else {
        [[LLHudHelper sharedInstance]tipMessage:@"数据异常"];
    }
}


#pragma mark - GoodSelectToolBarDelegate

- (void)goodSelectToolBarDidSelecedWithSort:(int)sort goodSelectToolBar:(GoodSelectToolBar*)goodSelectToolBar
{
    self.sort = sort;
    [self.zhongHeView dismiss];
    
    if (sort == -1){  //-1 关闭综合view
        //donothing
    } else if(sort == 0){  //0 打开综合view
        //展示综合
        CGFloat top = kNavigationBarHeight + 40;
        [self.zhongHeView showOnSupperView:self.view frame:CGRectMake(0, top, kScreenWidth, self.view.height - top)];
    }  else {   //大于0的情况
        self.pageIndex = 1;
        [self requestSearchGoodsWithKeyWords:self.keywords sort:sort PageIndex:self.pageIndex is_counpon:0 start_price:nil end_price:nil is_tmall:@"N"];
    }
}

#pragma mark - helper

-(void)addMJRefresh
{
    __weak SearchResultListController* wself = self;
    self.tableview.mj_header = [LLRefreshGifHeader headerWithRefreshingBlock:^{
        wself.isMJHeaderRefresh = YES; //重要代码
        wself.pageIndex = 1;
        [wself requestSearchGoodsWithKeyWords:self.keywords sort:self.sort PageIndex:wself.pageIndex is_counpon:0 start_price:nil end_price:nil is_tmall:@"N"];
        [wself impactLight];
    }];
    
    self.tableview.mj_footer = [LLRefreshAutoGifFooter footerWithRefreshingBlock:^{
         wself.isMJFooterRefresh = YES;
        wself.pageIndex++;
         [wself requestSearchGoodsWithKeyWords:self.keywords sort:self.sort PageIndex:wself.pageIndex is_counpon:0 start_price:nil end_price:nil is_tmall:@"N"];
        [wself impactLight];
    }];
    [self.tableview.mj_header beginRefreshing];
}

#pragma mark - searchBar delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if(searchBar.text.length > 0){
        self.pageIndex = 1;
        [self requestSearchGoodsWithKeyWords:self.keywords sort:1 PageIndex:self.pageIndex is_counpon:0 start_price:nil end_price:nil is_tmall:@"N"];
        [searchBar endEditing:YES];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.keywords = searchBar.text;
}
@end
