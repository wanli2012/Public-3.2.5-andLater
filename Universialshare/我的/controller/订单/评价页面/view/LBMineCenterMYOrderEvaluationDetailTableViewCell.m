//
//  LBMineCenterMYOrderEvaluationDetailTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/20.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterMYOrderEvaluationDetailTableViewCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface LBMineCenterMYOrderEvaluationDetailTableViewCell()<UITextViewDelegate>

@end
@implementation LBMineCenterMYOrderEvaluationDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.submitbt.layer.cornerRadius = 4;
    self.submitbt.clipsToBounds = YES;
    self.submitbt.layer.borderWidth = 1;
    self.submitbt.layer.borderColor = TABBARTITLE_COLOR.CGColor;
    self.starview.progress = 0;
    self.textview.delegate = self;


}

-(void)tapgestureview{

    [self.delegete tapgestureshowmoreinfo:self.index];

}

-(void)setOrderEvaluationModel:(orderEvaluationModel *)orderEvaluationModel{
    _orderEvaluationModel = orderEvaluationModel;
    
        self.starview.progress = _orderEvaluationModel.starValue;
        self.textview.text = _orderEvaluationModel.conentlb;
    
    
        self.starview.progressDidChangedByUser=^(CGFloat progress){
            _orderEvaluationModel.starValue = progress;
        };
        
        if (_orderEvaluationModel.conentlb.length  > 0) {
            self.placeholderLb.hidden = YES;
        }else{
            self.placeholderLb.hidden = NO;
        }
        
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView{

    self.placeholderLb.hidden = YES;

}

-(void)textViewDidEndEditing:(UITextView *)textView{

    if (textView.text.length <=0 ) {
        self.placeholderLb.hidden = NO;
    }else{
        self.placeholderLb.hidden = YES;
    }

}

-(void)textViewDidChange:(UITextView *)textView{

    [[self.textview rac_textSignal] subscribeNext:^(id x) {
        
        NSString *str=[NSString stringWithFormat:@"%@",x];
        _orderEvaluationModel.conentlb = str;
        if (str.length <= 300) {
            
            self.limiteLb.text = [NSString stringWithFormat:@"%lu/300",(unsigned long)str.length];
            
        }
    }];

}

- (IBAction)submitinfomation:(UIButton *)sender {
    
    [self.delegete submitevaluationinfo:self.index];
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    if ([text isEqualToString:@"\n"]) {
        [self.delegete ishidekeyboard];
        return NO;
    }
    
    if (_orderEvaluationModel.conentlb.length >= 300 && ![text isEqualToString:@""]) {
        return NO;
    }
    return YES;

}

@end
