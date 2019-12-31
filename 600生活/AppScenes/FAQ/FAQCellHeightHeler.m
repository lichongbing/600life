//
//  FAQCellHeightHeler.m
//  600生活
//
//  Created by iOS on 2019/11/14.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "FAQCellHeightHeler.h"

@implementation FAQCellHeightHeler

+(CGFloat)getCellHeightWithData:(FAQModel*)faqModel
{
    //问题列表
    NSArray* questions = faqModel.question_list;
    
    if(questions.count == 1){
        return 100;
    }
    
    if(questions.count > 1){
        //是否展示更多
        BOOL isShowMoreInfo = faqModel.isShowMoreInfo;
        
        int max = 0;
        if(!isShowMoreInfo){
            max = 2;
        }else{
            max = (int)questions.count;
        }
        
        CGFloat height = 0;
        for(int i = 0; i < max; i++){
            CGFloat itemHeight = [FAQCellHeightHeler heightForBgViewWithQuestion:questions[i]];
            height = height + itemHeight;
        }
        return height;
    }
    return 0;
}

//按钮默认包括上方14高度的lab和下方14高度的空高度  总共28高度
+(CGFloat)heightForBgViewWithQuestion:(QuestionModel*)questionModel
{
    NSString* title = questionModel.title;
    UIView* bgView = [UIView new];
    bgView.frame = CGRectZero;
    
    //背景按钮
    UIButton* bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:bgBtn];
    CGFloat lineRight = 106;
    CGFloat space = 20;
    CGFloat btnDefaultHeight = 50; //cell的高度的0.5

    bgBtn.width = kScreenWidth - lineRight - space * 2;
    bgBtn.height = btnDefaultHeight;  //高度后面根据lab文字重新设置
    bgBtn.left = 0;
    bgBtn.top = 0;
    
    //展示问题lab
    UILabel* lab = [UILabel new];
    [bgView addSubview:lab];
    lab.left = bgBtn.left;
    lab.width = bgBtn.width;
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
    line.left = 0;
    line.bottom = bgBtn.bottom;
    line.backgroundColor = kAppBackGroundColor;
    
    return line.bottom;
}

@end
