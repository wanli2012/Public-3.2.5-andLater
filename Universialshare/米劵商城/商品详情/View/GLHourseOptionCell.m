//
//  GLHourseOptionCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/3/31.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLHourseOptionCell.h"
@interface GLHourseOptionCell ()
@property (nonatomic,strong)NSMutableArray *btnArr;

@property (nonatomic, strong)UILabel *titleLabel;
@end

@implementation GLHourseOptionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _titleLabel = [[UILabel alloc] init];
//        _titleLabel.backgroundColor = [UIColor redColor];
        
        
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_titleLabel];
        
        _btnArr = [NSMutableArray array];
     
    }
    return self;
}
- (void)setModel:(GLHourseOptionModel *)model{
    if (!_model) {
        _model = model;
        
        float upX = 10;
        float upY = 40;
        
        _titleLabel.frame = CGRectMake(10, 10, 200, 20);
        _titleLabel.text = model.typeName;
        for (int i = 0; i < _model.titleNames.count; i ++) {
            
            NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont boldSystemFontOfSize:14] forKey:NSFontAttributeName];
            CGSize size = [model.titleNames[i] sizeWithAttributes:dic];
            
            if ( upX > (SCREEN_WIDTH - 20 - size.width - 35)) {
                
                upX = 10;
                upY += 30;
            }
            
            UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setBackgroundColor:[UIColor whiteColor]];
            [btn setTitleColor:[UIColor blackColor] forState:0];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [btn setTitle:model.titleNames[i] forState:0];
            btn.layer.cornerRadius = 8;
            btn.layer.borderColor = [UIColor clearColor].CGColor;
            btn.layer.borderWidth = 1;
            [btn.layer setMasksToBounds:YES];
            [btn addTarget:self action:@selector(touchbtn:) forControlEvents:UIControlEventTouchUpInside];
            
            btn.frame = CGRectMake(upX, upY, size.width+30,25);
            upX+=size.width+35;
            NSLog(@"%@",NSStringFromCGRect(btn.frame));
            
            [_btnArr addObject:btn];
            [self.contentView addSubview:btn];
            
        }
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
   

    
    
}
-(void)touchbtn:(UIButton *)btn
{
//    NSLog(@"%d",btn.selected);
    [self resumeBtn:self.btnArr btn:btn];

    [self.delegate btnindex:(int)btn.tag];
    
}
//恢复按钮的原始状态
-(void)resumeBtn:(NSArray *)arr btn:(UIButton *)btn
{
    for (int i = 0; i< arr.count; i++) {
        
        UIButton *button = arr[i];
        
        if (button != btn ) {
            button.selected = NO;
        }
        
        button.layer.borderColor = [UIColor clearColor].CGColor;
    }
    
    if (btn.selected) {
        
        btn.layer.borderColor = [UIColor clearColor].CGColor;
    }else{
        btn.layer.borderColor = [UIColor redColor].CGColor;
    }
    btn.selected = !btn.selected;
}

@end
