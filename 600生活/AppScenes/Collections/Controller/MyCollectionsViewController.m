//
//  MyCollectionsViewController.m
//  600生活
//
//  Created by iOS on 2019/11/13.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "MyCollectionsViewController.h"
#import "CollectedGoodTableViewCell.h"  //收藏的商品cell
#import "CollectedGoodModel.h" //收藏商品 model

#import "TwoGoodItemsTableViewCell.h" //精选 用的是猜你喜欢的cell
#import "GuessLikeGoodModel.h"  //精选 用的是猜你喜欢的model

#import "GoodDetailViewController.h"

@interface MyCollectionsViewController ()<UITableViewDataSource>

@property(nonatomic,strong)UIView* headerView;//收藏的headerview 主要为了展示无数据图
@property(nonatomic,strong)UILabel* footerTableViewHeader; //精选table的header
@property(nonatomic,strong)UITableView* footerTableView;   //精选推荐用这个table 它将成为self.tableview的footerView

@property(nonatomic,strong)NSArray* footerTableViewDatas;

@property(atomic,assign)int requestCounter;  //删除收藏请求次数记录
@property(nonatomic,strong)NSMutableArray* mutSelectedGoodList;//保存多选的商品(删除商品接口没有多选 只有单独删除)

@end

@implementation MyCollectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的收藏";
    [self setNavRightItemWithTitle:@"管理" titleColor:[UIColor blackColor] selector:@selector(rightItemAction:)];
    [self setupTableViews];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.footerTableView.height = self.footerTableView.contentSize.height;
}

#pragma mark - UI
-(void)setupTableViews
{
   //收藏table
    self.tableview.height = kScreenHeight - kNavigationBarHeight - kIPhoneXHomeIndicatorHeight;
    self.tableview.delegate = (id)self;
    self.tableview.dataSource = (id)self;
    self.tableview.estimatedRowHeight = 140;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addMJRefresh]; //请求收藏数据
    [self.tableview registerNib:[UINib nibWithNibName:@"CollectedGoodTableViewCell" bundle:nil] forCellReuseIdentifier:@"CollectedGoodTableViewCell"];
    
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.1)];
    self.tableview.tableHeaderView = _headerView;
    
    //精选table  作为 self.tableviewd的footer
    self.footerTableView = [[UITableView alloc]init];
    self.footerTableView.allowsMultipleSelectionDuringEditing = NO;
    self.footerTableView.scrollEnabled = NO;
    self.footerTableView.tableHeaderView = self.footerTableViewHeader;
    self.footerTableView.width = kScreenWidth;
    self.footerTableView.height = 200; //后面重设高度
    self.footerTableView.estimatedRowHeight = 278;
    self.footerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.footerTableView.delegate = (id)self;
    self.footerTableView.dataSource = (id)self;
    [self.footerTableView registerNib:[UINib nibWithNibName:@"TwoGoodItemsTableViewCell" bundle:nil] forCellReuseIdentifier:@"TwoGoodItemsTableViewCell"];
    [self requestGoodSelect]; //请求精选数据
    
    self.tableview.tableFooterView = self.footerTableView;
}

#pragma mark - 网络请求

//收藏
-(void)requestMyCollectedGoods:(NSInteger)pageIndex
{
    if (pageIndex == 1) {
        [self.datasource removeAllObjects];
    }
     NSDictionary* param = @{
           @"page":[NSNumber numberWithInteger:pageIndex],
           @"page_size":@"10"
     };
    [[LLNetWorking sharedWorking]helper];
    [self GetWithUrlStr:kFullUrl(kCollectgoods) param:param showHud:YES resCache:^(id  _Nullable cacheData) {
        if(kSuccessCache){
            [self handleMyCollectedGoods:pageIndex datas:cacheData[@"data"]];
        }
    } success:^(id  _Nullable res) {
        if(kSuccessRes){
            NSArray *ary = res[@"data"];
            if (pageIndex == 1 && ary.count == 0) {
                  [self.datasource removeAllObjects];
              }
            [self handleMyCollectedGoods:pageIndex datas:res[@"data"]];
            
        }
    } falsed:^(NSError * _Nullable error) {
      
    }];
}

-(void)handleMyCollectedGoods:(NSInteger)pageIndex datas:(NSArray*)list
{
    NSMutableArray* mutArr = [NSMutableArray new];
    for(int i = 0; i < list.count; i++){
        NSError* err = nil;
        CollectedGoodModel* collectedGoodModel = [[CollectedGoodModel alloc]initWithDictionary:list[i] error:&err];
        if(collectedGoodModel){
            [mutArr addObject:collectedGoodModel];
        } else {
            NSLog(@"收藏的商品模型创建失败");
        }
    }
    [self configDataSource:mutArr];
}

-(void)configDataSource:(NSArray*)tempArray
{
    __weak MyCollectionsViewController* wself = self;
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
            wself.headerView.height = 200;
            wself.tableview.tableHeaderView = wself.headerView;
            wself.tableview.tableFooterView = wself.footerTableView; //self.headerView
            
            [Utility showTipViewOn:wself.headerView type:0 iconName:@"tipview无收藏" msg:@"没有收藏哟!"];
        }else{
            wself.headerView.height = 0.1;
            wself.tableview.tableHeaderView = wself.headerView;
            wself.tableview.tableFooterView = wself.footerTableView;
            [Utility dismissTipViewOn:wself.headerView];
        }
    });
}

//精选
-(void)requestGoodSelect
{
    //kGoodSelect
    NSDictionary* param = @{
        @"page":[NSNumber numberWithInteger:1],
        @"page_size":@"10"
    };
    
    [self GetWithUrlStr:kFullUrl(kGoodSelect) param:param showHud:YES resCache:^(id  _Nullable cacheData) {
        if(kSuccessCache){
            [self handleGoodSelect:cacheData[@"data"]];
        }
    } success:^(id  _Nullable res) {
        if(kSuccessRes){
            [self handleGoodSelect:res[@"data"]];
        }
    } falsed:^(NSError * _Nullable error) {

    }];
}

-(void)handleGoodSelect:(NSArray*)datas
{
    //lhf -- 使用的是GuessLikeGoodModel
    NSArray* goods_list = datas;
    
    NSMutableArray* mutArr = [NSMutableArray new];
    for(int i = 0; i < goods_list.count; i++){
        NSError* err = nil;
        GuessLikeGoodModel* guessLikeGoodModel = [[GuessLikeGoodModel alloc]initWithDictionary:goods_list[i] error:&err];
        if(guessLikeGoodModel){
            [mutArr addObject:guessLikeGoodModel];
        } else {
            NSLog(@"%@",err.description);
        }
        
        if(i == 3){
            break; //只加了4个元素
        }
    }
    
    _footerTableViewDatas = [[NSArray alloc]initWithArray:mutArr];
    __weak MyCollectionsViewController* wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
         [wself.footerTableView reloadData];
    });
}

//删除一件收藏商品
-(void)requestDeleteCollectedGoodWithGoodId:(NSString*)goodId maxCount:(int)maxCount
{
    self.requestCounter++;
    
    NSDictionary* param = @{
        @"id":goodId
    };
   
    [[LLNetWorking sharedWorking]Delete:kFullUrl(kWillUnCollectGood) param:param success:^(id  _Nonnull res) {
        if(kSuccessRes){
            if(self.requestCounter == maxCount){
                [[LLHudHelper sharedInstance]tipMessage:@"删除成功"];
                if(maxCount > 1){
                    //多选 删除
                    [self handleDeleteCollectedGoodWithGoodId:nil];
                }else{
                    //单选 删除
                    [self handleDeleteCollectedGoodWithGoodId:goodId];
                }
                self.requestCounter = 0;
            }
        }else{
            if(self.requestCounter == maxCount){
                self.requestCounter = 0;
            }
        }
    } failure:^(NSError * _Nonnull error) {
        if(self.requestCounter == maxCount){
            self.requestCounter = 0;
        }
    }];
}


//如果是
-(void)handleDeleteCollectedGoodWithGoodId:(NSString*)goodId
{
    if(!goodId){//多选删除
        //创建indexPath  list
        NSMutableArray<NSIndexPath*>* mutArr = [NSMutableArray new];
        for(int i = 0; i < self.mutSelectedGoodList.count; i++){
            CollectedGoodModel* collectedGoodModel = self.mutSelectedGoodList[i];

            NSInteger row = [self.datasource indexOfObject:collectedGoodModel];
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [mutArr addObject:indexPath];
        }
        
        //数据源删除model list
        [self.datasource removeObjectsInArray:self.mutSelectedGoodList];
        
        //table 根据 indexPath  list 创建删除动画
        __weak MyCollectionsViewController* wself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself.tableview beginUpdates];
            [wself.tableview deleteRowsAtIndexPaths:mutArr withRowAnimation:UITableViewRowAnimationFade];
            [wself.tableview endUpdates];
        });
        
        if(self.datasource.count == 0){
            self.pageIndex = 1;
            [self requestMyCollectedGoods:self.pageIndex];
        }
    }else{//单选删除
        for(int i = 0; i < self.mutSelectedGoodList.count; i++){
            CollectedGoodModel* collectedGoodModel = self.mutSelectedGoodList[i];
            if([collectedGoodModel.item_id isEqualToString:goodId]){
                NSInteger row = [self.datasource indexOfObject:collectedGoodModel];
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                
                [self.datasource removeObject:collectedGoodModel];
                
                //table 根据 indexPath  list 创建删除动画
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableview beginUpdates];
                    [self.tableview deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [self.tableview endUpdates];
                });
                return;
            }
        }
    }
}


//-(void)handleDeleteGoodLogListWithGoodIdList:(NSArray<FootMarkGoodModel*>*)footMarkGoodModelList
//{
//    //创建indexPath  list
//    NSMutableArray<NSIndexPath*>* mutArr = [NSMutableArray new];
//    for(int i = 0; i < footMarkGoodModelList.count; i++){
//        FootMarkGoodModel* footMarkGoodModel = footMarkGoodModelList[i];
//        NSInteger row = [self.datasource indexOfObject:footMarkGoodModel];
//        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row inSection:0];
//        [mutArr addObject:indexPath];
//    }
//
//    //数据源删除model list
//    [self.datasource removeObjectsInArray:footMarkGoodModelList];
//
//
//    //table 根据 indexPath  list 创建删除动画
//    [self.tableview beginUpdates];
//    [self.tableview deleteRowsAtIndexPaths:mutArr withRowAnimation:UITableViewRowAnimationFade];
//    [self.tableview endUpdates];
//
//    //提示成功
//    [[LLHudHelper sharedInstance]tipMessage:@"删除成功"];
//}


#pragma mark - tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.tableview){
        return self.datasource.count;
    }
    
    if(tableView == self.footerTableView){
        NSMutableArray* mutArr = [NSMutableArray new];
        for(int i = 0; i < self.footerTableViewDatas.count; i++){//self.datasource.count/2 是整数
            NSMutableArray* item = [NSMutableArray new];
            if(i%2 == 0) {
                //基数个 左边model
                GuessLikeGoodModel* modelLeft = self.footerTableViewDatas[i];
                GuessLikeGoodModel* modelRight = self.footerTableViewDatas[i+1];
                [item addObject:modelLeft];
                [item addObject:modelRight];
                [mutArr addObject:item];
            }
        }
        return mutArr.count;
    }
    
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tableview){
        CollectedGoodTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CollectedGoodTableViewCell" forIndexPath:indexPath];
        [cell fullData:self.datasource[indexPath.row]];
        return cell;
    }
    
    if(tableView == self.footerTableView){
        TwoGoodItemsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TwoGoodItemsTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSMutableArray* mutArr = [NSMutableArray new];
        for(int i = 0; i < self.footerTableViewDatas.count; i++){//self.datasource.count/2 是整数
            NSMutableArray* item = [NSMutableArray new];
            if(i%2 == 0) {
                //基数个 左边model
                GuessLikeGoodModel* modelLeft = self.footerTableViewDatas[i];
                GuessLikeGoodModel* modelRight = self.footerTableViewDatas[i+1];
                [item addObject:modelLeft];
                [item addObject:modelRight];
                [mutArr addObject:item];
            }
        }
        
        NSArray* item = mutArr[indexPath.row];
        
        [cell fullDataWithLeftModel:item.firstObject rightModel:item.lastObject];
        __weak MyCollectionsViewController* wself = self;
        cell.guessLikeGoodClickedCallback = ^(GuessLikeGoodModel * _Nonnull guessLikeGoodModel) {
            if(guessLikeGoodModel.item_id){
                GoodDetailViewController* vc = [[GoodDetailViewController alloc]initWithItem_id:guessLikeGoodModel.item_id];
                vc.hidesBottomBarWhenPushed = YES;
                [wself.navigationController pushViewController:vc animated:YES];
            }
        };
        
        return cell;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tableview){
        
        if(self.tableview.isEditing == NO){
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            CollectedGoodModel* collectedGoodModel =[self.datasource objectAtIndex:indexPath.row];
            if(collectedGoodModel.item_id){
                GoodDetailViewController* vc = [[GoodDetailViewController alloc]initWithItem_id:collectedGoodModel.item_id];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [[LLHudHelper sharedInstance]tipMessage:@"数据异常"];
            }
        }
       
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if([tableView isEqual:self.footerTableView]){
        return NO;
    }
    return YES;
}

#pragma mark - control action

-(void)rightItemAction:(UIButton*)btn
{
    if(!(self.datasource.count > 0)){
        [[LLHudHelper sharedInstance]tipMessage:@"暂无收藏数据"];
        return;
    }
    
    if(self.tableview.allowsMultipleSelectionDuringEditing==NO){
        self.tableview.allowsMultipleSelectionDuringEditing = YES;
    }
    
    if(self.tableview.isEditing == YES){//正在编辑->停止编辑 在handleMutSelectRowsAction中去关闭编辑
        [btn setTitle:@"管理" forState:UIControlStateNormal];
        [self handleMutSelectRowsAction];
        
//        [self.tableview setEditing:NO animated:YES]; //放在handleMutSelectRowsAction处理
    }else{//没有编辑->开始编辑
        [self.tableview setEditing:YES animated:YES];
        [btn setTitle:@"完成" forState:UIControlStateNormal];
    }
}

-(void)handleMutSelectRowsAction
{
    __weak MyCollectionsViewController* wself = self;
    // 获得所有被选中的行
    NSArray<NSIndexPath*> *indexPathList = [self.tableview indexPathsForSelectedRows];
    if(indexPathList.count > 0) {
        [Utility ShowAlert:@"提示" message:[NSString stringWithFormat:@"是否删除%lu项收藏商品",indexPathList.count] buttonName:@[@"立刻删除",@"再想想",] sureAction:^{
            //停止多选
            [self.tableview setEditing:NO animated:YES];
            //网络请求
            
            wself.mutSelectedGoodList = [NSMutableArray new];
            for(int i = 0; i < indexPathList.count; i++){
                NSIndexPath* indexPath = indexPathList[i];
                CollectedGoodModel* collectedGoodModel = [self.datasource objectAtIndex:indexPath.row];
                [wself.mutSelectedGoodList addObject:collectedGoodModel];
                [self  requestDeleteCollectedGoodWithGoodId:collectedGoodModel.item_id maxCount:(int)indexPathList.count];
            }
        } cancleAction:^{
            
        }];
    }else{
        //停止多选
        [self.tableview setEditing:NO animated:YES];
    }
}

#pragma mark - helper

-(void)addMJRefresh
{
    __weak MyCollectionsViewController* wself = self;
    self.tableview.mj_header = [LLRefreshGifHeader headerWithRefreshingBlock:^{
        wself.isMJHeaderRefresh = YES; //重要代码
        //获取评论数据
        wself.pageIndex=1;
        [wself requestMyCollectedGoods:wself.pageIndex];
        [wself impactLight];
    }];
    
    self.tableview.mj_footer = [LLRefreshAutoGifFooter footerWithRefreshingBlock:^{
        wself.isMJFooterRefresh = YES;
        //获取评论数据
        wself.pageIndex++;
        [wself requestMyCollectedGoods:wself.pageIndex];
        [wself impactLight];
    }];
    
    [self.tableview.mj_header beginRefreshing];
}

-(UILabel*)footerTableViewHeader
{
    if(!_footerTableViewHeader){
        _footerTableViewHeader = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        _footerTableViewHeader.font = [UIFont systemFontOfSize:16];
        _footerTableViewHeader.text = @"━ ♡ 为您精选 ━";
        _footerTableViewHeader.textAlignment = NSTextAlignmentCenter;
        _footerTableViewHeader.backgroundColor = kAppBackGroundColor;
        _footerTableViewHeader.textColor = [UIColor colorWithHexString:@"#F54556"];
    }
    return _footerTableViewHeader;
}

@end
