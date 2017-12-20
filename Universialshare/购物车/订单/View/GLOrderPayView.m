//
//  GLOrderPayView.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/6.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLOrderPayView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface GLOrderPayView ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *passV;
@property (weak, nonatomic) IBOutlet UIImageView *oneImageV;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageV;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageV;
@property (weak, nonatomic) IBOutlet UIImageView *forthImageV;
@property (weak, nonatomic) IBOutlet UIImageView *fifthImageV;
@property (weak, nonatomic) IBOutlet UIImageView *sixImageV;


@end

@implementation GLOrderPayView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = 5.f;
    self.layer.masksToBounds = YES;
    
//    [self.passwordF becomeFirstResponder];
    self.passwordF.delegate = self;
    self.passwordF.returnKeyType = UIReturnKeyDone;
    self.passwordF.keyboardType = UIKeyboardTypeNumberPad;
    //添加键盘监听事件
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//    当系统消息出现UIKeyboardWillShowNotification和UIKeyboardWillHideNotification消息就会调用我们的keyboardWillShow和keyboardWillHide方法。
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:self.passwordF];
}
- (void)textFieldChanged:(NSNotification *)sender{
    
    if (self.passwordF.text.length > 6) {
        self.passwordF.text = [self.passwordF.text substringToIndex:6];
    }else{
        self.passwordF.text = [NSString stringWithFormat:@"%@",self.passwordF.text];
    }
    
    if (self.passwordF.text.length == 0) {
        
        [self showimageone:@"" imagetwo:@"" imagethree:@"" imagefour:@"" imagefive:@"" imagesix:@""];
        
    }else if (self.passwordF.text.length == 1){
        
        [self showimageone:@"加密密码" imagetwo:@"" imagethree:@"" imagefour:@"" imagefive:@"" imagesix:@""];
        
    }else if (self.passwordF.text.length == 2){
        
        [self showimageone:@"加密密码" imagetwo:@"加密密码" imagethree:@"" imagefour:@"" imagefive:@"" imagesix:@""];
        
    }else if (self.passwordF.text.length == 3){
        
        [self showimageone:@"加密密码" imagetwo:@"加密密码" imagethree:@"加密密码" imagefour:@"" imagefive:@"" imagesix:@""];
        
    }else if (self.passwordF.text.length == 4){
        
        [self showimageone:@"加密密码" imagetwo:@"加密密码" imagethree:@"加密密码" imagefour:@"加密密码" imagefive:@"" imagesix:@""];
        
    }else if (self.passwordF.text.length == 5){
        
        [self showimageone:@"加密密码" imagetwo:@"加密密码" imagethree:@"加密密码" imagefour:@"加密密码" imagefive:@"加密密码" imagesix:@""];
        
    }else if (self.passwordF.text.length == 6){
        
        [self showimageone:@"加密密码" imagetwo:@"加密密码" imagethree:@"加密密码" imagefour:@"加密密码" imagefive:@"加密密码" imagesix:@"加密密码"];
        [self.passwordF resignFirstResponder];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"input_PasswordNotification" object:nil userInfo:@{@"password":self.passwordF.text}];
        
        NSLog(@"6格拉 不要在输了%@",self.passwordF.text);
        return;
        
    }

}

-(void)showimageone:(NSString*)imageone imagetwo:(NSString*)imagetwo imagethree:(NSString*)imagethree imagefour:(NSString*)imagefour imagefive:(NSString*)imagefive imagesix:(NSString*)imagesix{
    
    _oneImageV.image = [UIImage imageNamed:imageone];
    _secondImageV.image = [UIImage imageNamed:imagetwo];
    _thirdImageV.image = [UIImage imageNamed:imagethree];
    _forthImageV.image = [UIImage imageNamed:imagefour];
    _fifthImageV.image = [UIImage imageNamed:imagefive];
    _sixImageV.image = [UIImage imageNamed:imagesix];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.passwordF resignFirstResponder];
    return YES;
}


#pragma mark ---- 根据键盘高度将当前视图向上滚动同样高度
///键盘显示事件
- (void)keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset = 0;
    if (kbHeight < (self.yy_height - CGRectGetMaxY(self.passwordF.frame))) {
        offset = 0;
    }else{
        offset = kbHeight - (SCREEN_HEIGHT*0.5 - CGRectGetMaxY(self.passwordF.frame)) + 20;
    }
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.frame = CGRectMake(0, SCREEN_HEIGHT *0.5 - offset, self.frame.size.width, SCREEN_HEIGHT *0.5);
            //                NSLog(@"%@",NSStringFromCGRect(self.frame));
        }];
    }
}
#pragma mark ---- 当键盘消失后，视图需要恢复原状
///键盘消失事件
- (void)keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT-self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
