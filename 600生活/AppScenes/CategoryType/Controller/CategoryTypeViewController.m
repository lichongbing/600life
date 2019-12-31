//
//  CategoryTypeViewController.m
//  600生活
//
//  Created by iOS on 2019/11/8.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "CategoryTypeViewController.h"
#import "LLBaseView.h"
#import "GoodSelectToolBar.h"  //工具栏
#import "SelectedGoodTableViewCell.h"   //选取商品的cell
#import "SelectedGoodModel.h"   //选取商品 model
#import "SPButton.h"
//#import "SearchResultListController.h" //搜索结果页
#import "CategoryGoodListViewController.h" //商品列表

#import "GoodDetailViewController.h"   //商品详情
#import "ZhongHeView.h"
#import "LoginAndRigistMainVc.h"


#define kControlSpaceTop  12 + 10   //上边
#define kControlSpaceLeft 20     //左边
#define kControlSpaceV 20       // 竖直 距离
#define kControlSpaceH 20       // 水平 距离
#define kColumns      5         //列数（行数根据列数计算而来）

@interface CategoryTypeViewController()<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *categoryBgView; //分类背景
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoryBgViewHeightCons;

@property (weak, nonatomic) IBOutlet UIView *toolBarBgView;
@property (weak, nonatomic) IBOutlet LLBaseView *layoutBottomLine;

@end


@interface CategoryTypeViewController ()<UITableViewDelegate,UITableViewDataSource,GoodSelectToolBarDelegate>
@property(nonatomic,strong)NSNumber* cid;
@property(nonatomic,strong)NSString*  categoryName;
@property(nonatomic,strong)NSArray<HomePageMenuCategoryChild*>* childArray;

@property(nonatomic,assign)int sort;  //保存搜索方式
@property(nonatomic,strong)NSString* keywords;
@property(nonatomic,strong)ZhongHeView* zhongHeView;

@end

@implementation CategoryTypeViewController

-(id)initWithCid:(NSNumber*)cid categoryName:(NSString*)categoryName childArray:(NSArray<HomePageMenuCategoryChild*>*)childArray
{
    if( self = [super init]){
        self.cid = cid;
        self.categoryName = categoryName;
        self.childArray = childArray;
        self.sort = 1;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     [self setupUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)loadDatasWhenUserDone
{
    __weak CategoryTypeViewController* wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [wself.tableview.mj_header beginRefreshing];
    });
}

#pragma mark - UI
-(void)setupUI
{
    //分类
    self.categoryBgView.width = kScreenWidth;
    [self resetupCategoryItems];
    
    //工具栏
    self.toolBarBgView.width = kScreenWidth;
    GoodSelectToolBar* goodSelectToolBar = [[GoodSelectToolBar alloc]initWithFrame:CGRectMake(0, 150, kScreenWidth, 40)];
    [self.toolBarBgView addSubview:goodSelectToolBar];
    goodSelectToolBar.tag = 288;
    goodSelectToolBar.top = goodSelectToolBar.left = 0;
    goodSelectToolBar.width = kScreenWidth;
    goodSelectToolBar.delegate = (id)self;
    
    self.headerView.width = kScreenWidth;
    self.tableview.tableHeaderView = self.headerView;
    self.tableview.height = kScreenHeight - kNavigationBarHeight - kTabbarHeight - 40; //40是工具栏高度
    
    self.tableview.estimatedRowHeight = 140;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = (id)self;
    self.tableview.dataSource = (id)self;
    
    [self.tableview registerNib:[UINib nibWithNibName:@"SelectedGoodTableViewCell" bundle:nil] forCellReuseIdentifier:@"SelectedGoodTableViewCell"];
    
    __weak CategoryTypeViewController* wself = self;
      _layoutBottomLine.viewDidLayoutNewFrameCallBack = ^(CGRect newFrame) {
          wself.headerView.height = newFrame.origin.y + newFrame.size.height;
          wself.tableview.tableHeaderView = wself.headerView;
      };
    
    [self addMJRefresh];
}

#pragma mark - 网络请求
/** kCategoryDetail 商品分类数据sort:
 1：综合
 2：收益由高到低
 3:佣金比例由大到小
 4:价格由高到低
 5:价格由低到高
 6:销量由高到低
 7:销量由低到高
 8:最新
 */
-(void)requestCategoryDatasWithPageIndex:(NSInteger)pageIndex sort:(int)sort
{
    NSDictionary* param = @{
        @"cid" : [NSString stringWithFormat:@"%@",self.cid],
        @"q": @"",
        @"sort" : [NSNumber numberWithInt:sort],//综合排序
        @"page":[NSNumber numberWithInteger:pageIndex],
        @"page_size":@"10"
      };
    
    __weak CategoryTypeViewController* wself = self;
    [self PostWithUrlStr:kFullUrl(kCategoryDetail) param:param showHud:NO resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes){
            [wself handleCategoryDatasWithPageIndex:pageIndex data:res];
        }
    } falsed:^(NSError * _Nullable error) {
    }];
}

-(void)handleCategoryDatasWithPageIndex:(NSInteger)pageIndex data:(NSDictionary*)data
{
    //处理主页数据
       NSArray* list = data[@"data"];
       NSMutableArray* mutArr = [NSMutableArray new];
       for(int i = 0; i < list.count; i++){
           NSError* err = nil;
           SelectedGoodModel* selectedGoodModel = [[SelectedGoodModel alloc]initWithDictionary:list[i] error:&err];
           if(selectedGoodModel){
               [mutArr addObject:selectedGoodModel];
           } else {
           NSLog(@"%@",err.description);
           }
       }
       
    [self configDataSource:mutArr];
}

-(void)configDataSource:(NSArray*)tempArray
{
    __weak CategoryTypeViewController* wself = self;
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
    
    if(self.datasource.count == 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            UIView* tipBg = [UIView new];
            tipBg.frame = CGRectMake(0, wself.tableview.tableHeaderView.height, kScreenWidth, wself.tableview.height - wself.tableview.tableHeaderView.height);
            [wself.tableview addSubview:tipBg];
            [Utility showTipViewOn:tipBg type:0 iconName:@"tipview无商品" msg:@"没有分类商品哟!"];
        });
    }else{
        [Utility dismissTipViewOn:self.tableview];
    }
}

#pragma mark - control action
-(void)homePageMenuCategoryChildBtnAction:(SPButton*)spButton
{
    if([LLUserManager shareManager].currentUser == nil){
        __weak CategoryTypeViewController* wself = self;
        [Utility ShowAlert:@"尚未登录" message:@"\n是否登录" buttonName:@[@"好的,去登录",@"不用了,谢谢"] sureAction:^{
            LoginAndRigistMainVc* vc = [LoginAndRigistMainVc new];
            vc.hidesBottomBarWhenPushed = YES;
            [wself.navigationController pushViewController:vc animated:YES];
        } cancleAction:nil];
        return;
    }
    
    NSInteger index = spButton.tag - 100;
    HomePageMenuCategoryChild* homePageMenuCategoryChild = self.childArray[index];
    
    CategoryGoodListViewController* vc = [[CategoryGoodListViewController alloc]initWithCategoryId:self.cid.toString CategoryName:homePageMenuCategoryChild.cid];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - tableview delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectedGoodTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SelectedGoodTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell fullData:self.datasource[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([LLUserManager shareManager].currentUser == nil){
        __weak CategoryTypeViewController* wself = self;
        [Utility ShowAlert:@"尚未登录" message:@"\n是否登录" buttonName:@[@"好的,去登录",@"不用了,谢谢"] sureAction:^{
            LoginAndRigistMainVc* vc = [LoginAndRigistMainVc new];
            vc.hidesBottomBarWhenPushed = YES;
            [wself.navigationController pushViewController:vc animated:YES];
        } cancleAction:nil];
        return;
    }
    
    SelectedGoodModel* selectedGoodModel =[self.datasource objectAtIndex:indexPath.row];
    if(selectedGoodModel.item_id){
        GoodDetailViewController* vc = [[GoodDetailViewController alloc]initWithItem_id:selectedGoodModel.item_id];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [[LLHudHelper sharedInstance]tipMessage:@"商品数据异常"];
    }
}


#pragma mark - helper

-(void)addMJRefresh
{
    __weak CategoryTypeViewController* wself = self;
    self.tableview.mj_header = [LLRefreshGifHeader headerWithRefreshingBlock:^{
        wself.isMJHeaderRefresh = YES; //重要代码
        wself.pageIndex = 1;
        [wself requestCategoryDatasWithPageIndex:wself.pageIndex sort:self.sort];
        [wself impactLight];
    }];
    
    self.tableview.mj_footer = [LLRefreshAutoGifFooter footerWithRefreshingBlock:^{
         wself.isMJFooterRefresh = YES;
         wself.pageIndex++;
         [wself requestCategoryDatasWithPageIndex:wself.pageIndex sort:self.sort];
        [wself impactLight];
    }];
}

//分类
-(void)resetupCategoryItems
{
    if(!self.childArray || self.childArray.count == 0){
        [Utility showTipViewOn:self.categoryBgView type:0 iconName:@"tipview无收藏" msg:@"无分类数据"];
        return;
    }else{
        [Utility dismissTipViewOn:self.categoryBgView];
    }
    
    //控件宽度
    CGFloat controlWidth = (kScreenWidth - kControlSpaceLeft*2 - kControlSpaceH*(kColumns-1)) / kColumns;
    
    //控件高度
    CGFloat controlHeight = controlWidth * 1 ;
    
    //保存图片背景高度
    CGFloat imagesBgViewHeight = 0;
    for (int i = 0; i < self.childArray.count; i++) {
        int row = i / kColumns;      //当前行数
        int col = i % kColumns;      //当前列数
        
        //控件left
        CGFloat controlLeft = kControlSpaceLeft + col*controlWidth + col*kControlSpaceH;
        
        //控件top
        CGFloat controlTop = kControlSpaceTop + row*controlHeight + row*kControlSpaceV;
        
        SPButton* spButton = [[SPButton alloc]initWithImagePosition:1];
        spButton.imagePosition = SPButtonImagePositionTop;
        spButton.imageTitleSpace = 10;
        spButton.frame = CGRectMake(controlLeft, controlTop, controlWidth, controlHeight);
        [self.categoryBgView addSubview:spButton];
        
        HomePageMenuCategoryChild* homePageMenuCategoryChild = self.childArray[i];
        [spButton setTitle:homePageMenuCategoryChild.name forState:UIControlStateNormal];
        [spButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [spButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [spButton sd_setImageWithURL:[NSURL URLWithString:homePageMenuCategoryChild.icon] forState:UIControlStateNormal placeholderImage:kPlaceHolderImg];
        
        [spButton addTarget:self action:@selector(homePageMenuCategoryChildBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        spButton.tag = 100 + i;
        
        if(imagesBgViewHeight < spButton.bottom){
            imagesBgViewHeight = spButton.bottom;
        }
        
        _categoryBgViewHeightCons.constant = imagesBgViewHeight + 12;
        
        if(i == 9){  //从第10个元素这里开始截取
            break;
        }
    }
}

#pragma mark getter
- (ZhongHeView *)zhongHeView
{
    if(!_zhongHeView){
        GoodSelectToolBar* goodSelectToolBar = [self.toolBarBgView viewWithTag:288];
        _zhongHeView = [[ZhongHeView alloc]initWithToolBar:goodSelectToolBar];
    }
    return _zhongHeView;
}

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    static CGFloat s_lastPosition = 0; //最后停留的位置
    int currentPostion = scrollView.contentOffset.y;
    
    CGFloat toolBarBgViewTop =  _toolBarBgView.top; //工具栏背景view的y值
    
    if (currentPostion - s_lastPosition > 20  && currentPostion > 0) {
        s_lastPosition = currentPostion;
        NSLog(@"手指上滑");
        
        if( currentPostion > toolBarBgViewTop ) {//当前位置大于toolBar的y
            GoodSelectToolBar* toolBar = [_toolBarBgView viewWithTag:288];
            if(![self.view viewWithTag:289]){//如果self.view没有 则添加
                [toolBar removeFromSuperview];
                [self.view addSubview:toolBar];
                toolBar.tag = 289;
                toolBar.frame = CGRectMake(0, 0, kScreenWidth, 44);
            }
        }
        
    } else if ((s_lastPosition - currentPostion > 20) && (currentPostion <= scrollView.contentSize.height-scrollView.bounds.size.height-20) ) {
        s_lastPosition = currentPostion;
        NSLog(@"手指下滑");
        if( currentPostion < toolBarBgViewTop ) {//当前位置小于toolBar的y
            GoodSelectToolBar* toolBar = [self.view viewWithTag:289];
            if([self.view viewWithTag:289]){ //如果self.view有了 则释放
                [toolBar removeFromSuperview];
                [self.toolBarBgView addSubview:toolBar];
                toolBar.tag = 288;
                toolBar.frame = CGRectMake(0, 0, kScreenWidth, 44);
            }
        }
    }
}

#pragma mark - GoodSelectToolBarDelegate

- (void)goodSelectToolBarDidSelecedWithSort:(int)sort goodSelectToolBar:(GoodSelectToolBar *)goodSelectToolBar
{
    self.sort = sort;
    [self.zhongHeView dismiss];
    
    if (sort == -1){  //-1 关闭综合view
        //donothing
    } else if(sort == 0){  //0 打开综合view
        //展示综合
        CGFloat top = self.toolBarBgView.bottom;
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
        [self requestCategoryDatasWithPageIndex:self.pageIndex sort:self.sort];
    }
}
@end
