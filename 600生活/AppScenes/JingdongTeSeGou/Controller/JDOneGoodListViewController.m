//
//  JDOneGoodListViewController.m
//  600生活
//
//  Created by iOS on 2020/1/3.
//  Copyright © 2020 灿男科技. All rights reserved.
//

#import "JDOneGoodListViewController.h"
#import "GoodSelectToolBar.h"
#import "ZhongHeView.h"
#import "JDGoodTableViewCell.h"

@interface JDOneGoodListViewController ()<GoodSelectToolBarDelegate>

@property (weak, nonatomic) IBOutlet UIView *toolBarBg;
@property(nonatomic,strong)ZhongHeView* zhongHeView;
@property(nonatomic,assign)int sort;
@property(nonatomic,strong)NSString* sort_name;

@end



@implementation JDOneGoodListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupToolBar];
    [self setupTableView];
    
    self.pageIndex = 1;
    [self requestJDGoods:self.pageIndex sort:nil sort_name:nil];
}



#pragma mark - UI

-(void)setupToolBar
{
    GoodSelectToolBar* goodSelectToolBar = [[GoodSelectToolBar alloc]initWithGoodSelectToolBarType:GoodSelectToolBarType1];
    [self.toolBarBg addSubview:goodSelectToolBar];
    goodSelectToolBar.delegate = (id)self;
    goodSelectToolBar.tag = 288;
    goodSelectToolBar.top = goodSelectToolBar.left = 0;
    goodSelectToolBar.width = kScreenWidth;
}

-(void)setupTableView
{
    CGFloat imageTop = 10;
    CGFloat imageLeft = 12;
    CGFloat imageWidth = kScreenWidth - imageLeft * 2;
    CGFloat imageHeight = imageWidth * 129 / 351;
    CGFloat imageAll = imageTop + imageHeight;
    CGFloat toolBarAndSpMenu = 40 + 40;
    self.tableview.top = self.toolBarBg.height;
    self.tableview.height = kScreenHeight - kNavigationBarHeight - imageAll - toolBarAndSpMenu - kIPhoneXHomeIndicatorHeight;
    
    self.tableview.delegate = (id)self;
    self.tableview.dataSource = (id)self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
 
    
    [self addMJRefresh];
    [self.tableview registerNib:[UINib nibWithNibName:@"JDGoodTableViewCell" bundle:nil] forCellReuseIdentifier:@"JDGoodTableViewCell"];
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
//特色购数据

/**
 *cid 商品类型1-好卷商品 2-为你推荐，3-特价9.9 4-品牌好货 （默认为1） 不用传 穿件vc时已经有值
 *sort 1正序 2倒序（综合排序不传sort_name）
 *sort_name 1-价格 2-佣金 3-销量(可以带sort参数，不带默认为倒序)
 */
-(void)requestJDGoods:(NSInteger)pageIndex
                 sort:(NSString*)sort
            sort_name:(NSString*)sort_name
{
    NSMutableDictionary* param = [NSMutableDictionary new];
    [param setValue:[NSNumber numberWithInteger:pageIndex] forKey:@"page"];
    [param setValue:[NSNumber numberWithInteger:10] forKey:@"page_size"];
    [param setValue:self.cid forKey:@"cid"];
    if(sort){
        [param setValue:sort forKey:@"sort"];
    }
    if(sort_name){
        [param setValue:sort_name forKey:@"sort_name"];
    }
    
    [self GetWithUrlStr:kFullUrl(kJDActivity) param:param showHud:NO resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes){
            [self handleJDRecommendGoodsWithPageIndex:pageIndex datas:res[@"data"]];
        }
    } falsed:^(NSError * _Nullable error) {
        
    }];
}

-(void)handleJDRecommendGoodsWithPageIndex:(NSInteger)pageIndex datas:(NSArray*)datas
{
    NSMutableArray* mutArr = [NSMutableArray new];
    for(int i = 0; i < datas.count; i++){
        NSError* err = nil;
        JDGood* jdGood = [[JDGood alloc]initWithDictionary:datas[i] error:&err];
        if(jdGood){
            [mutArr addObject:jdGood];
        } else {
            NSLog(@"京东商品模型转换失败");
        }
    }
    [self configDataSource:mutArr];
}

-(void)configDataSource:(NSArray*)tempArray
{
    __weak JDOneGoodListViewController* wself = self;
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
    JDGoodTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JDGoodTableViewCell" forIndexPath:indexPath];
    [cell fullData:self.datasource[indexPath.row]];
    return cell;
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
        CGFloat top = self.toolBarBg.bottom;
        [self.zhongHeView showOnSupperView:self.view frame:CGRectMake(0, top, kScreenWidth, self.view.height - top)];
    }  else {   //大于0的情况
        self.pageIndex = 1;
        NSString* sortStr = [NSString stringWithFormat:@"%d",self.sort];
        [self requestJDGoods:self.pageIndex sort:sortStr sort_name:self.sort_name];
    }
}

-(void)addMJRefresh
{
    __weak JDOneGoodListViewController* wself = self;
    self.tableview.mj_header = [LLRefreshGifHeader headerWithRefreshingBlock:^{
        wself.isMJHeaderRefresh = YES; //重要代码
        wself.pageIndex=1;
        NSString* sortStr = [NSString stringWithFormat:@"%d",self.sort];
        [wself requestJDGoods:wself.pageIndex sort:sortStr sort_name:self.sort_name];
        [wself impactLight];
    }];
    
    self.tableview.mj_footer = [LLRefreshAutoGifFooter footerWithRefreshingBlock:^{
        wself.isMJFooterRefresh = YES;
        wself.pageIndex++;
        NSString* sortStr = [NSString stringWithFormat:@"%d",self.sort];
        [wself requestJDGoods:wself.pageIndex sort:sortStr sort_name:self.sort_name];
        [wself impactLight];
    }];
    
     [self.tableview.mj_header beginRefreshing];
}
@end
