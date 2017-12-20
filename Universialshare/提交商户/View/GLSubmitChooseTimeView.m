//
//  GLSubmitChooseTimeView.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/28.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLSubmitChooseTimeView.h"

@interface GLSubmitChooseTimeView()
{
    LoadWaitView *_loadV;
}
@property (nonatomic, copy)NSString *currentChoose;
@property (nonatomic, strong)NSMutableArray *dataArr;



@end

@implementation GLSubmitChooseTimeView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.layer.cornerRadius = 5.f;
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    self.datePicker.datePickerMode = UIDatePickerModeTime;
    [self.datePicker addTarget : self action:@selector (datePickerValueChanged:) forControlEvents : UIControlEventValueChanged ];
    

    
}
- (void)datePickerValueChanged:(UIDatePicker *)datePicker
{
//    NSLog(@"datePicker.date = %@",datePicker.date);
}
- (IBAction)cancel:(id)sender {
}
- (IBAction)ensure:(id)sender {
    
}


- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithArray:@[@"0:00",@"0:30",@"1:00",@"1:30",@"2:00",@"2:30",@"3:00",@"3:30",@"0:00",@"0:00",@"0:00",@"0:00",@"0:00",@"0:00",@"0:00",@"0:00",@"0:00",@"0:00",@"0:00",@"0:00",@"0:00",@"0:00",@"0:00",@"0:00",]];
    }
    return _dataArr;
}
@end
