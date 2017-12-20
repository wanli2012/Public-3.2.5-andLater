//
//  GLMine_InfoCell.m
//  PovertyAlleviation
//
//  Created by gonglei on 17/2/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_InfoCell.h"

@interface GLMine_InfoCell ()<UITextFieldDelegate>

@end

@implementation GLMine_InfoCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.textTf.delegate = self;
}

-(void)refrshdataSource:(NSString *)title vaule:(NSString *)value{

    self.titleLabel.text = title;
    if ([title isEqualToString:@"店铺地址"]) {
        self.adressLb.hidden = NO;
        self.textTf.hidden = YES;
        self.adressLb.text = value;
    }else{
        self.adressLb.hidden = YES;
        self.textTf.hidden = NO;
        self.textTf.text = value;
    }
    
    if ([title isEqualToString:@"用户名"]||[title isEqualToString:@"联系电话"]) {
        self.textTf.enabled = NO;
    }else{
       self.textTf.enabled = NO;
    }
    
    if ([title isEqualToString:@"联系电话"]) {
        self.textTf.keyboardType = UIKeyboardTypePhonePad;
    }else{
       self.textTf.keyboardType = UIKeyboardTypeDefault;
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField endEditing:YES];

    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{

    if (self.returnEditing) {
        self.returnEditing(textField.text , self.index);
    }

}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

  
        if ([self.titleLabel.text isEqualToString:@"联系电话"]) {
            for(int i=0; i< [string length];i++){
                
                int a = [string characterAtIndex:i];
                
                if( a >= 0x4e00 && a <= 0x9fff)
                    
                    return NO;
            }
        }
    
    return YES;

}

@end
