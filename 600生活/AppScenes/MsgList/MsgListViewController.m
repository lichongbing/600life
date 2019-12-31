//
//  SystemMsgViewController.m
//  600生活
//
//  Created by iOS on 2019/11/18.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "MsgListViewController.h"
#import "MsgTableViewCell.h"
#import "MsgModel.h"

@interface MsgListViewController ()

@property(nonatomic,strong)NSString*type;

@end

@implementation MsgListViewController

-(id)initWithType:(NSString*)type
{
    if(self = [super init]){
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if([self.type isEqualToString:@"1"]){
        self.title = @"系统消息";
    }else if([self.type isEqualToString:@"2"]){
        self.title = @"收益消息";
    }
    
    [self setupTableView];
}


#pragma mark - UI
-(void)setupTableView
{
    self.tableview.height = kScreenHeight - kNavigationBarHeight - kIPhoneXHomeIndicatorHeight;
    self.tableview.delegate = (id)self;
    self.tableview.dataSource = (id)self;
    self.tableview.estimatedRowHeight = 135;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableview registerNib:[UINib nibWithNibName:@"MsgTableViewCell" bundle:nil] forCellReuseIdentifier:@"MsgTableViewCell"];
    [self addMJRefresh];
}


#pragma mark - 网络请求
-(void)requestMsgList:(NSInteger)pageIndex
{
    NSDictionary* param = @{
        @"page_size":@"10",
        @"type":self.type,
    };
    [self GetWithUrlStr:kFullUrl(kMessageList) param:param showHud:NO resCache:nil success:^(id  _Nullable res) {
         [self handlerequestMsgList:pageIndex datas:res[@"data"]];
    } falsed:^(NSError * _Nullable error) {
        
    }];
}

-(void)handlerequestMsgList:(NSInteger)pageIndex datas:(NSArray*)datas
{
    NSArray* msgList = datas;
    NSMutableArray* mutArr = [NSMutableArray new];
    
       for(int i = 0; i < msgList.count; i++){
           NSError* err = nil;
           MsgModel* msgModel = [[MsgModel alloc]initWithDictionary:msgList[i] error:&err];
           if(msgModel){
               [mutArr addObject:msgModel];
           } else {
               NSLog(@"消息模型转换失败");
           }
       }
    [self configDataSource:mutArr];
}

-(void)configDataSource:(NSArray*)tempArray
{
    __weak MsgListViewController* wself = self;
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(wself.datasource.count == 0){
            [Utility showTipViewOn:wself.tableview type:0 iconName:@"tipview无消息" msg:@"没有消息哟!"];
        }else{
            [Utility dismissTipViewOn:wself.tableview];
        }
    });
}

//请求阅读一条消息
-(void)requestUserReadMsg:(NSString*)msgId
{
    NSDictionary* param = @{
        @"id": msgId,
        @"type":self.type,
    };
    
    __weak MsgListViewController* wself = self;
    [self GetWithUrlStr:kFullUrl(kReadMessage) param:param showHud:YES resCache:nil success:^(id  _Nullable res) {
        [wself handleUserReadMsgId:msgId];
    } falsed:^(NSError * _Nullable error) {
        
    }];
}

-(void)handleUserReadMsgId:(NSString*)msgId
{
    for(int i = 0; i < self.datasource.count; i++){
        MsgModel* msgModel =[self.datasource objectAtIndex:i];
        if([msgModel.id.toString isEqualToString:msgId]){
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            __weak MsgListViewController* wself = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                MsgTableViewCell* msgTableViewCell = [wself.tableview cellForRowAtIndexPath:indexPath];
                [msgTableViewCell hiddenRedDot];
                msgModel.read = [NSNumber numberWithInt:1];
            });
            return;
        }
    }
}

#pragma mark - tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MsgTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MsgTableViewCell" forIndexPath:indexPath];
    [cell fullData:self.datasource[indexPath.row]];
    
    __weak MsgListViewController* wself = self;
    cell.cellClickedCallback = ^(MsgModel * _Nonnull msgModel) {
        NSInteger index = [wself.datasource indexOfObject:msgModel];
        [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        
        //请求阅读消息
        if([msgModel.read.toString isEqualToString:@"0"]){
            [self requestUserReadMsg:msgModel.id.toString];
        }
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark - helper

-(void)addMJRefresh
{
    __weak MsgListViewController* wself = self;
    self.tableview.mj_header = [LLRefreshGifHeader headerWithRefreshingBlock:^{
        wself.isMJHeaderRefresh = YES; //重要代码
        //获取评论数据
        wself.pageIndex=1;
        [wself requestMsgList:wself.pageIndex];
        [wself impactLight];
    }];
    
    self.tableview.mj_footer = [LLRefreshAutoGifFooter footerWithRefreshingBlock:^{
         wself.isMJFooterRefresh = YES;
        //获取评论数据
         wself.pageIndex++;
         [wself requestMsgList:wself.pageIndex];
        [wself impactLight];
    }];
    
    [self.tableview.mj_header beginRefreshing];
}


@end
