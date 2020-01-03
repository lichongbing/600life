//
//  FootMarkListViewController.m
//  600生活
//
//  Created by iOS on 2019/11/13.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "FootMarkListViewController.h"
#import "FootMarkGoodModel.h"  //足迹商品模型
#import "FootMarkTableViewCell.h" //足迹cell

#import "FootMarkSimilarGoodsViewController.h"  //相似商品
#import "GoodDetailViewController.h"

@interface FootMarkListViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation FootMarkListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"600足迹";
    [self setNavRightItemWithImage:[UIImage imageNamed:@"navItem_删除"] selector:@selector(rightItemAction:)];
    [self setupTableView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavBarRedColor];
    [self setNavBackItemWhite];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
    [self.tableview registerNib:[UINib nibWithNibName:@"FootMarkTableViewCell" bundle:nil] forCellReuseIdentifier:@"FootMarkTableViewCell"];
}

#pragma mark - 网络请求

//获取足迹数据
-(void)requestGoodsLog:(NSInteger)pageIndex
{
     NSDictionary* param = @{
           @"page":[NSNumber numberWithInteger:pageIndex],
           @"page_size":@"10"
         };
    [self GetWithUrlStr:kFullUrl(kGoodsLog) param:param showHud:YES resCache:^(id  _Nullable cacheData) {
        if(kSuccessCache){
            [self handleGoodsLogWithPageIndex:pageIndex data:cacheData];
        }
    } success:^(id  _Nullable res) {
        if(kSuccessRes){
            [self handleGoodsLogWithPageIndex:pageIndex data:res];
        }
    } falsed:^(NSError * _Nullable error) {
        
    }];
}

-(void)handleGoodsLogWithPageIndex:(NSInteger)pageIndex data:(NSDictionary*)data
{
    //处理主页数据
    NSArray* list = data[@"data"];
    NSMutableArray* mutArr = [NSMutableArray new];
    for(int i = 0; i < list.count; i++){
        NSError* err = nil;
        FootMarkGoodModel* footMarkGood = [[FootMarkGoodModel alloc]initWithDictionary:list[i] error:&err];
        if(footMarkGood){
            [mutArr addObject:footMarkGood];
        } else {
            NSLog(@"足迹商品模型创建失败");
        }
    }
    
    [self configDataSource:mutArr];
}

-(void)configDataSource:(NSArray*)tempArray
{
    
    __weak FootMarkListViewController* wself = self;
    
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

//删除足迹
-(void)requestDeleteGoodLogListWithGoodIdList:(NSArray<FootMarkGoodModel*>*)footMarkGoodModelList
{
    NSMutableDictionary* param = [NSMutableDictionary new];
    for(int i = 0; i < footMarkGoodModelList.count; i++){
        FootMarkGoodModel* footMarkGoodModel = [footMarkGoodModelList objectAtIndex:i];
        NSString* idStr = footMarkGoodModel.id.toString;
        NSString* key = [NSString stringWithFormat:@"id[%d]",i];
        NSString* value = idStr;
        [param setValue:value forKey:key];
    }
   
    [[LLNetWorking sharedWorking]Delete:kFullUrl(kClearTrack) param:param success:^(id  _Nonnull res) {
        if(kSuccessRes){
            __weak FootMarkListViewController* wself = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [wself handleDeleteGoodLogListWithGoodIdList:footMarkGoodModelList];
            });
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

-(void)handleDeleteGoodLogListWithGoodIdList:(NSArray<FootMarkGoodModel*>*)footMarkGoodModelList
{
    //创建indexPath  list
    NSMutableArray<NSIndexPath*>* mutArr = [NSMutableArray new];
    for(int i = 0; i < footMarkGoodModelList.count; i++){
        FootMarkGoodModel* footMarkGoodModel = footMarkGoodModelList[i];
        NSInteger row = [self.datasource indexOfObject:footMarkGoodModel];
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [mutArr addObject:indexPath];
    }
    
    //数据源删除model list
    [self.datasource removeObjectsInArray:footMarkGoodModelList];
    

    //table 根据 indexPath  list 创建删除动画
    [self.tableview beginUpdates];
    [self.tableview deleteRowsAtIndexPaths:mutArr withRowAnimation:UITableViewRowAnimationFade];
    [self.tableview endUpdates];
    
    //提示成功
    [[LLHudHelper sharedInstance]tipMessage:@"删除成功"];
    
    if(self.datasource.count == 0){
        self.pageIndex = 1;
        [self requestGoodsLog: self.pageIndex];
    }
}

#pragma mark - tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FootMarkTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FootMarkTableViewCell" forIndexPath:indexPath];
    [cell fullData:self.datasource[indexPath.row]];
    __weak FootMarkListViewController* wself = self;
    cell.similarBtnClickedCallback = ^(FootMarkGoodModel * _Nonnull footMarkGoodModel) {
        if(footMarkGoodModel.cat != nil){
           FootMarkSimilarGoodsViewController* vc = [[FootMarkSimilarGoodsViewController alloc]initWithCat:footMarkGoodModel.cat];
            vc.hidesBottomBarWhenPushed = YES;
            [wself.navigationController pushViewController:vc animated:YES];
        }else{
            [[LLHudHelper sharedInstance]tipMessage:@"商品数据异常"];
        }
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.tableview.isEditing == NO){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        FootMarkGoodModel* footMarkGoodModel = [self.datasource objectAtIndex:indexPath.row];
        if(footMarkGoodModel.item_id){
            GoodDetailViewController* vc = [[GoodDetailViewController alloc]initWithItem_id:footMarkGoodModel.item_id];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [[LLHudHelper sharedInstance]tipMessage:@"数据异常"];
        }
    }
}


//ios 11 删除cell
//- ( UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
//        FootMarkGoodModel* footMarkGoodModel = [self.datasource objectAtIndex:indexPath.row];
//        [self requestDeleteGoodLogListWithGoodIdList:@[footMarkGoodModel]];
//        completionHandler (YES);
//    }];
////    deleteRowAction.image = [UIImage imageNamed:@"上箭头"];
//    deleteRowAction.backgroundColor = [UIColor colorWithHexString:@"#F54556"];
//    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
//    return config;
//}


//左滑删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        FootMarkGoodModel* footMarkGoodModel = [self.datasource objectAtIndex:indexPath.row];
        [self requestDeleteGoodLogListWithGoodIdList:@[footMarkGoodModel]];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

    
#pragma mark - control action

-(void)rightItemAction:(UIButton*)btn
{
    if(!(self.datasource.count > 0)){
        [[LLHudHelper sharedInstance]tipMessage:@"暂无足迹"];
        return;
    }
    
    self.tableview.allowsMultipleSelectionDuringEditing = YES;
    
    if(self.tableview.isEditing == YES){//点击前正在编辑 -> 点击后停止编辑 在handleMutSelectRowsAction中去关闭编辑
        [btn setImage:[UIImage imageNamed:@"navItem_删除"] forState:UIControlStateNormal];
        [btn setTitle:nil forState:UIControlStateNormal];
        [self handleMutSelectRowsAction];
    }else{//点击前没有编辑 -> 点击后开始编辑
        [self.tableview setEditing:YES animated:YES];
        [btn setImage:nil forState:UIControlStateNormal];
        [btn setTitle:@"完成" forState:UIControlStateNormal];
    }
}

-(void)handleMutSelectRowsAction
{
    // 获得所有被选中的行
    NSArray<NSIndexPath*> *indexPathList = [self.tableview indexPathsForSelectedRows];
    if(indexPathList.count > 0) {
        [Utility ShowAlert:@"提示" message:[NSString stringWithFormat:@"是否删除%lu项足迹",indexPathList.count] buttonName:@[@"立刻删除",@"再想想",] sureAction:^{
            //停止多选
            [self.tableview setEditing:NO animated:YES];
            //网络请求
            NSMutableArray* mutArr= [NSMutableArray new];
            for(int i = 0; i < indexPathList.count; i++){
                NSIndexPath* indexPath = indexPathList[i];
                FootMarkGoodModel* footMarkGoodModel = [self.datasource objectAtIndex:indexPath.row];
                [mutArr addObject:footMarkGoodModel];
            }
            
            [self requestDeleteGoodLogListWithGoodIdList:mutArr];
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
    __weak FootMarkListViewController* wself = self;
    self.tableview.mj_header = [LLRefreshGifHeader headerWithRefreshingBlock:^{
        wself.isMJHeaderRefresh = YES; //重要代码
        //获取评论数据
        wself.pageIndex=1;
        [wself requestGoodsLog:wself.pageIndex];
        [wself impactLight];
    }];
    
    self.tableview.mj_footer = [LLRefreshAutoGifFooter footerWithRefreshingBlock:^{
         wself.isMJFooterRefresh = YES;
        //获取评论数据
        wself.pageIndex++;
        [wself requestGoodsLog:wself.pageIndex];
        [wself impactLight];
    }];
    
    [self.tableview.mj_header beginRefreshing];
}
@end
