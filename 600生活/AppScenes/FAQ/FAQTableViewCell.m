//
//  FAQTableViewCell.m
//  600生活
//
//  Created by iOS on 2019/11/14.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "FAQTableViewCell.h"
#import "NSString+ext.h"

#define kIsHeadBtnSelected @"isHeadBtnSelected"

@interface FAQTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *showMoreIcon;
@property (nonatomic,strong) NSIndexPath* currentIndexPath;

@property(nonatomic,strong)FAQModel* faqModel;

@end


@implementation FAQTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)fullData:(FAQModel*)faqModel indexPath:(NSIndexPath*)indexPath
{
    self.faqModel = faqModel;
    
    //清空旧的view
    for(UIView* subView in self.subviews){
        if(subView.tag >= 10){
            [subView removeFromSuperview];
        }
    }
    
    _showMoreIcon.hidden = YES;
    
    
    /******************************创建界面********************************/
    
    //标题
    self.titleLab.text = faqModel.name;
    //图片
    [self.icon sd_setImageWithURL:[NSURL URLWithString:faqModel.icon]];
    
    //问题列表
    NSArray* questions = faqModel.question_list;
    
    
    //只有一条问题
    if(questions.count == 1){
        UIView* bgView = [self onlyOneQuestionBgViewWithQuestion:questions.firstObject];
        bgView.tag = 11;
        [self addSubview:bgView];
    }
    
    //大于一条问题
    if(questions.count > 1){
        //是否展示更多
        BOOL isShowMoreInfo = faqModel.isShowMoreInfo;
        
        int max = 0;
        if(!isShowMoreInfo){
            max = 2;
        }else{
            max = (int)questions.count;
        }
        
        CGFloat top = 0;
        for(int i = 0; i < max; i++){
            UIView* bgView = [self setupQuestionBgViewWithQuestion:questions[i]];
            [self addSubview:bgView];
            bgView.tag = 10+i;
            bgView.top = top;
            bgView.left = 106;   //没有设置y坐标值
            top = bgView.bottom;
        }
        //如果超过cell默认高度100
        if(top > 100){
            // do something 约束会自动改变cell高度
        }
    }
    
    //下拉icon展示或者隐藏
    if (questions.count > 2){
        _showMoreIcon.hidden = NO;
        if(faqModel.isShowMoreInfo){
            _showMoreIcon.image = [UIImage imageNamed:@"上箭头"];
        }else{
            _showMoreIcon.image = [UIImage imageNamed:@"下箭头"];
        }
    }
}


-(UIView*)onlyOneQuestionBgViewWithQuestion:(QuestionModel*)questionModel
{
    NSString* questionId = questionModel.id.toString;
    NSString* title = questionModel.title;
    NSString* content = questionModel.content;
    
    //背景按钮
    UIButton* bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bgBtn.tag = questionId.longLongValue;
    [bgBtn addTarget:self action:@selector(questionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [bgBtn setTitle:title forState:UIControlStateNormal];
    objc_setAssociatedObject(bgBtn, kRunTimeFAQQuestionButtomWithData, content, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    CGFloat lineRight = 106;
    CGFloat space = 20;
    CGFloat btnDefaultHeight = 100;
    bgBtn.width = kScreenWidth - lineRight - space;
    bgBtn.height = btnDefaultHeight;  //高度后面根据lab文字重新设置
    bgBtn.left = lineRight + space;
    bgBtn.top = 0;
    
    //展示问题lab
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, bgBtn.width, 14)];
    lab.textColor = [UIColor colorWithHexString:@"#161515"];
    lab.font = [UIFont systemFontOfSize:14];
    lab.textAlignment = NSTextAlignmentLeft;
    lab.text = title;
    lab.width = bgBtn.width;
    lab.height = [lab.text sizeWithFont:lab.font maxSize:CGSizeMake(lab.width, MAXFLOAT)].height;
    [bgBtn addSubview:lab];
    lab.left = 0;
    lab.top = 0;
    lab.centerY = bgBtn.height * 0.5;
    
    return bgBtn;
}

//按钮默认包括上方14高度的lab和下方14高度的空高度  总共28高度
-(UIView*)setupQuestionBgViewWithQuestion:(QuestionModel*)questionModel
{
    NSString* questionId = questionModel.id.toString;
    NSString* title = questionModel.title;
    NSString* content = questionModel.content;
    
    UIView* bgView = [UIView new];
    bgView.frame = CGRectZero;
    
    //背景按钮
    UIButton* bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:bgBtn];
    bgBtn.tag = questionId.longLongValue;
    [bgBtn addTarget:self action:@selector(questionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [bgBtn setTitle:title forState:UIControlStateNormal];
    objc_setAssociatedObject(bgBtn, kRunTimeFAQQuestionButtomWithData, content, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    CGFloat lineRight = 106;
    CGFloat space = 20;
    CGFloat btnDefaultHeight = 50; //cell的高度的0.5

    bgBtn.width = kScreenWidth - lineRight - space * 2;
    bgBtn.height = btnDefaultHeight;  //高度后面根据lab文字重新设置
    bgBtn.left = space;
    bgBtn.top = 0;
    
    //展示问题lab
    UILabel* lab = [UILabel new];
    [bgView addSubview:lab];
    lab.left = bgBtn.left;
    lab.width = bgBtn.width;
    lab.textColor = [UIColor colorWithHexString:@"#161515"];
    lab.font = [UIFont systemFontOfSize:14];
    lab.textAlignment = NSTextAlignmentLeft;
    lab.text = title;
    lab.width = bgBtn.width;
    lab.height = [lab.text sizeWithFont:lab.font maxSize:CGSizeMake(lab.width, MAXFLOAT)].height;
    
    if(lab.height > bgBtn.height){
        bgBtn.height = lab.height;
    }
    lab.centerY = bgBtn.height * 0.5;
    
    
    
    UIView* line = [UIView new];
    [bgView addSubview:line];
    line.width = lab.width;
    line.height = 1;
    line.left = space;
    line.bottom = bgBtn.bottom;
    line.backgroundColor = kAppBackGroundColor;
    
    
    bgView.width = bgBtn.width;
    bgView.height = line.bottom;
    return bgView;
}

#pragma mark - control action

- (IBAction)headBtnAction:(UIButton*)sender {
    if(self.faqModel.question_list.count > 2){
        self.faqModel.isShowMoreInfo = !self.faqModel.isShowMoreInfo;
           self.headIconClickedCallback(self.faqModel);
    }
}


-(void)questionBtnAction:(UIButton*)btn
{
    NSString* title = btn.titleLabel.text;
    NSString* content = objc_getAssociatedObject(btn, kRunTimeFAQQuestionButtomWithData);
    content = [NSString stringWithFormat:@"\n%@",content];
    [Utility ShowAlert:title message:content buttonName:@[@"我知道了"] sureAction:^{
        
    } cancleAction:nil];
}


@end
