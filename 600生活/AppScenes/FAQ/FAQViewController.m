//
//  FAQViewController.m
//  600生活
//
//  Created by iOS on 2019/11/14.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "FAQViewController.h"
#import "FAQTableViewCell.h"
#import "FAQCellHeightHeler.h"
#import "FAQModel.h"

@interface FAQViewController ()

@end

@implementation FAQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavRightItemWithImage:[UIImage imageNamed:@"UserCenter_刷新"] selector:@selector(rightItemAction)];
    self.title = @"常见问题";
    [self setupTableview];
    [self requestFAQ];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - UI
-(void)setupTableview
{
    self.tableview.top = 5;
    self.tableview.height = kScreenHeight - kNavigationBarHeight - kIPhoneXHomeIndicatorHeight - 50 - self.tableview.top;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = (id)self;
    self.tableview.dataSource = (id)self;
    [self.tableview registerNib:[UINib nibWithNibName:@"FAQTableViewCell" bundle:nil] forCellReuseIdentifier:@"FAQTableViewCell"];
}

#pragma mark - 网络请求
-(void)requestFAQ
{
    [self GetWithUrlStr:kFullUrl(kFAQ) param:nil showHud:YES resCache:^(id  _Nullable cacheData) {
           if(kSuccessCache){
               [self handleFAQ:cacheData[@"data"]];
           }
       } success:^(id  _Nullable res) {
           if(kSuccessRes){
                [self handleFAQ:res[@"data"]];
           }
       } falsed:^(NSError * _Nullable error) {
       }];
}

-(void)handleFAQ:(NSArray*)list
{
    [Utility printModelWithDictionary:list[0][@"question_list"][0] modelName:@"A"];
    
    NSMutableArray* mutArr = [NSMutableArray new];
    for(int i = 0; i < list.count;i++){
        NSError* err = nil;
        FAQModel* faqModel = [[FAQModel alloc]initWithDictionary:list[i] error:&err];
        
        NSArray* question_list = faqModel.question_list;
        NSMutableArray* questions = [NSMutableArray new];
        for(int j = 0; j < question_list.count; j++){
            err = nil;
            QuestionModel* questionModel = [[QuestionModel alloc]initWithDictionary:question_list[j] error:&err];
            if(questionModel){
                [questions addObject:questionModel];
            }
        }
        if(questions.count > 0){
            faqModel.question_list = questions;
        }
        
        
        if(faqModel){
            [mutArr addObject:faqModel];
        }
    }
    
    if(mutArr.count > 0){
        self.datasource = mutArr;
        __weak FAQViewController* wself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself.tableview reloadData];
        });
    }
}

#pragma mark - tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.datasource.count > 0){
        NSDictionary* data = [self.datasource objectAtIndex:indexPath.row];
        return [FAQCellHeightHeler getCellHeightWithData:data];
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FAQTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FAQTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(self.datasource.count > 0){
        [cell fullData:self.datasource[indexPath.row] indexPath:indexPath];
    }
    
    __weak FAQViewController* wself = self;
    cell.headIconClickedCallback = ^(FAQModel* faqModel) {
        if(!faqModel.isShowMoreInfo){
            //收起来
            [wself.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
        }else{
            //弹出来
            [wself.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
        }
    };
    return cell;
}

#pragma mark - control action

-(void)rightItemAction
{
    [self requestFAQ];
}


@end
