//
//  CategoryGoodListViewController.m
//  600生活
//
//  Created by iOS on 2019/12/11.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "CategoryGoodListViewController.h"
#import "GoodSelectToolBar.h" //工具栏


#import "CategoryGoodTableViewCell.h"  //分类商品cell
#import "CategoryGoodModel.h"          //分类商品model

#import "GoodDetailViewController.h"  //商品详情

#import "ZhongHeView.h"
#import "LoginAndRigistMainVc.h"


@interface CategoryGoodListViewController ()<GoodSelectToolBarDelegate,UISearchBarDelegate>

@property(nonatomic,strong)GoodSelectToolBar* goodSelectToolBar;
@property(nonatomic,strong)ZhongHeView* zhongHeView;


@property(nonatomic,strong)NSString* categoryId;   //分类id
@property(nonatomic,strong)NSString* categoryName;  //分类名称
@property(nonatomic,assign)int sort;

@end

@implementation CategoryGoodListViewController


-(id)initWithCategoryId:(NSString*)categoryId CategoryName:(NSString*)categoryName
{
    if(self = [super init]){
        self.categoryId = categoryId;
        self.categoryName = categoryName;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = self.categoryName;
    
    _goodSelectToolBar = [[GoodSelectToolBar alloc]initWithGoodSelectToolBarType:GoodSelectToolBarTypeDefault];
    _goodSelectToolBar.top = 0;
    [self.view addSubview:_goodSelectToolBar];
    _goodSelectToolBar.delegate = self;
    _goodSelectToolBar.width = kScreenWidth;
    
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = (id)self;
    self.tableview.dataSource = (id)self;
    [self.tableview registerNib:[UINib nibWithNibName:@"CategoryGoodTableViewCell" bundle:nil] forCellReuseIdentifier:@"CategoryGoodTableViewCell"];
    self.tableview.top = _goodSelectToolBar.height;
    self.tableview.width = kScreenWidth;
    self.tableview.height = kScreenHeight - kNavigationBarHeight - self.goodSelectToolBar.height - kIPhoneXHomeIndicatorHeight;
    
    self.pageIndex = 1;
    self.sort = 1;
    [self addMJRefresh];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
        _zhongHeView = [[ZhongHeView alloc]initWithToolBar:self.goodSelectToolBar];
    }
    return _zhongHeView;
}


#pragma mark - 网络请求

//获取商品分类数据
-(void)requestCategoryDatasWithPageIndex:(NSInteger)pageIndex sort:(int)sort isShowHud:(BOOL)isShowHud
{
    NSDictionary* param = @{
        @"cid" : self.categoryId,
        @"q": self.categoryName,
        @"sort" : [NSNumber numberWithInt:self.sort],
        @"page":[NSNumber numberWithInteger:pageIndex],
        @"page_size":@"10"
      };
    
    __weak CategoryGoodListViewController* wself = self;
    [self PostWithUrlStr:kFullUrl(kCategoryDetail) param:param showHud:isShowHud resCache:^(id  _Nullable cacheData) {
        if(kSuccessCache){
            [wself handleCategoryDatasWithPageIndex:pageIndex data:cacheData];
        }
    } success:^(id  _Nullable res) {
        if(kSuccessRes){
            [wself handleCategoryDatasWithPageIndex:pageIndex data:res];
        }
    } falsed:^(NSError * _Nullable error) {
    }];
}

-(void)handleCategoryDatasWithPageIndex:(NSInteger)pageIndex data:(NSDictionary*)data
{
    //处理分类数据
       NSArray* list = data[@"data"];
       NSMutableArray* mutArr = [NSMutableArray new];
       for(int i = 0; i < list.count; i++){
           NSError* err = nil;
           CategoryGoodModel* categoryGoodModel = [[CategoryGoodModel alloc]initWithDictionary:list[i] error:&err];
           if(categoryGoodModel){
               [mutArr addObject:categoryGoodModel];
           } else {
           NSLog(@"%@",err.description);
           }
       }
       
    [self configDataSource:mutArr];
}

-(void)configDataSource:(NSArray*)tempArray
{
    __weak CategoryGoodListViewController* wself = self;
    
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
    
    if(self.datasource.count == 0){
       [Utility showTipViewOn:self.tableview type:0 iconName:@"tipview无商品" msg:@"没有分类商品哟!"];
    }else{
        [Utility dismissTipViewOn:self.tableview];
    }
}


#pragma mark - tableview delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryGoodTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryGoodTableViewCell" forIndexPath:indexPath];
    [cell fullData:self.datasource[indexPath.row] keywords:self.categoryName];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([LLUserManager shareManager].currentUser == nil){
        __weak CategoryGoodListViewController* wself = self;
        [Utility ShowAlert:@"尚未登录" message:@"\n是否登录" buttonName:@[@"好的,去登录",@"不用了,谢谢"] sureAction:^{
            LoginAndRigistMainVc* vc = [LoginAndRigistMainVc new];
            vc.hidesBottomBarWhenPushed = YES;
            [wself.navigationController pushViewController:vc animated:YES];
        } cancleAction:nil];
        return;
    }
    
    CategoryGoodModel* categoryGoodModel = [self.datasource objectAtIndex:indexPath.row];
    if(categoryGoodModel.item_id){
        GoodDetailViewController* goodDetailVC = [[GoodDetailViewController alloc]initWithItem_id:categoryGoodModel.item_id];
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
        CGFloat top = 40;
        [self.zhongHeView showOnSupperView:self.view frame:CGRectMake(0, top, kScreenWidth, self.view.height - top)];
    }  else {   //大于0的情况
        self.pageIndex = 1;
        
        //这里要重新处理一下 如果选择的是佣金比例由大到小 控件返回的是2 我们应该修改成3
        //如果选择的是预估收益由高到低 控件返回的是3 我们应该修改成2
        if(sort == 2){
            self.sort = 3;
        } else if (sort == 3){
            self.sort = 2;
        }
      [self requestCategoryDatasWithPageIndex:self.pageIndex sort:self.sort isShowHud:YES];
    }
}

#pragma mark - helper

-(void)addMJRefresh
{
    __weak CategoryGoodListViewController* wself = self;
    self.tableview.mj_header = [LLRefreshGifHeader headerWithRefreshingBlock:^{
        wself.isMJHeaderRefresh = YES; //重要代码
        //获取评论数据
        wself.pageIndex = 1;
       [wself requestCategoryDatasWithPageIndex:wself.pageIndex sort:wself.sort isShowHud:NO];
        [wself impactLight];
    }];
    
    self.tableview.mj_footer = [LLRefreshAutoGifFooter footerWithRefreshingBlock:^{
         wself.isMJFooterRefresh = YES;
        //获取评论数据
        wself.pageIndex++;
        [wself requestCategoryDatasWithPageIndex:wself.pageIndex sort:wself.sort isShowHud:NO];
        [wself impactLight];
    }];
    [self.tableview.mj_header beginRefreshing];
}
@end
