//
//  GLBuyBackChooseBankView.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/14.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLBuyBackChooseBankView.h"

@interface GLBuyBackChooseBankView()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    LoadWaitView *_loadV;
}
@property (nonatomic, copy)NSString *currentChoose;
@property (nonatomic, strong)NSMutableArray *dataArr;
@end

@implementation GLBuyBackChooseBankView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.layer.cornerRadius = 5.f;
    self.clipsToBounds = YES;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    
    _loadV = [LoadWaitView addloadview:self.bounds tagert:self];
    [NetworkManager requestPOSTWithURLStr:@"User/openBankName" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        //        NSLog(@"responseObject = %@",responseObject);
        if ([responseObject[@"code"] integerValue] == 1){
            
            for (NSDictionary *dic in responseObject[@"data"]) {
                
                [self.dataArr addObject:dic[@"bank_name"]];
            }
        
            self.currentChoose = self.dataArr[0];
            [self.pickerView reloadAllComponents];
        }
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        
    }];

}
- (IBAction)ensureClick:(id)sender {
    self.block(self.currentChoose);
    
}

- (IBAction)cancelClick:(id)sender {
    self.block(@"");
}

#pragma  UIPickerViewDelegate UIPickerViewDataSource

// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    
    return self.dataArr.count;
}


#pragma Mark -- UIPickerViewDelegate
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    
    return self.yy_width -20;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 50;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.currentChoose = self.dataArr[row];
    //    self.messageType = row + 1;
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //    NSString *content;
    //    if (_index == 0) {
    //        content = self.dataArr[row];
    //    }else if (_index == 1){
    //    }
    return self.dataArr[row];
}
//-(NSMutableArray *)messageArr{
//
//    if (!_messageArr) {
//        _messageArr=[NSMutableArray array];
//        _messageArr = [NSMutableArray arrayWithObjects:@"nidaye",@"nidaye1",@"niday2e",@"nidaye3",@"nidaye4",@"nidaye5",@"nidaye6",@"nidaye7",@"nidaye8",@"nidaye9", nil];
//    }
//
//    return _messageArr;
//
//}
////重写方法
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH -20 , 50)];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [pickerLabel setTextColor:[UIColor darkGrayColor]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}



- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
@end
