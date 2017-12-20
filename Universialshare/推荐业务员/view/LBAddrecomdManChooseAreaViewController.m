//
//  LBAddrecomdManChooseAreaViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/28.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBAddrecomdManChooseAreaViewController.h"

@interface LBAddrecomdManChooseAreaViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerview;
@property (weak, nonatomic) IBOutlet UILabel *titlelb;

@property (strong, nonatomic)NSString *resultStr;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger selectIndex;//选中第几行 。默认为0

@end

@implementation LBAddrecomdManChooseAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
 
    self.selectIndex = 0;
    self.titlelb.text = self.titlestr;
    

}


- (IBAction)canelbutton:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"LoveConsumptionVC" object:nil];
    
}

- (IBAction)ensurebutton:(UIButton *)sender {
    
    if (self.returnreslut) {
        self.returnreslut(self.selectIndex);
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"LoveConsumptionVC" object:nil];
    
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

/**< 行*/
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    
    return self.provinceArr.count;
}
-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *displaylable;
    
    displaylable=[[UILabel alloc]initWithFrame:CGRectMake(0, 1, (self.view.bounds.size.width - 20), 48)];
    displaylable.textAlignment=NSTextAlignmentCenter;
    displaylable.backgroundColor=[UIColor whiteColor];
    displaylable.textColor=[UIColor darkGrayColor];
    displaylable.font=[UIFont boldSystemFontOfSize:14];
    displaylable.numberOfLines=0;
    
    if ([self.titlestr isEqualToString:@"请选择省份"]) {
         displaylable.text = [self.provinceArr objectAtIndex:row][@"province_name"];
    }else if ([self.titlestr isEqualToString:@"请选择城市"]){
        displaylable.text = [self.provinceArr objectAtIndex:row][@"city_name"];
    }else if ([self.titlestr isEqualToString:@"请选择区域"]){
        displaylable.text = [self.provinceArr objectAtIndex:row][@"country_name"];
    }else if ([self.titlestr isEqualToString:@"请选择开户行"]){
        displaylable.text = [self.provinceArr objectAtIndex:row][@"bank_name"];
    }else if ([self.titlestr isEqualToString:@"请选择一级行业分类"] || [self.titlestr isEqualToString:@"请选择一级商户"]){
        displaylable.text = [self.provinceArr objectAtIndex:row][@"trade_name"];
    }else if ([self.titlestr isEqualToString:@"请选择二级行业分类"] || [self.titlestr isEqualToString:@"请选择二级商户"]){
        displaylable.text = [self.provinceArr objectAtIndex:row][@"trade_name"];
    }else if([self.titlestr isEqualToString:@"请选择一级分类"]){
        displaylable.text = [self.provinceArr objectAtIndex:row][@"catename"];
    }else if ([self.titlestr isEqualToString:@"请选择二级分类"]){
        displaylable.text = [self.provinceArr objectAtIndex:row][@"catename"];
    }
    
    UIView *maskview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, (self.view.bounds.size.width - 20), 50)];
    maskview.backgroundColor=[UIColor whiteColor];
    [maskview addSubview:displaylable];
    
    
    for(UIView *singleLine in pickerView.subviews)
    {
        if (singleLine.frame.size.height < 1)
        {
            singleLine.backgroundColor = YYSRGBColor(40, 150, 58, 1);
        }
    }
    
    return maskview;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    return (self.view.bounds.size.width - 20);/**< 宽度*/
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 50;/**< 高度*/
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    self.selectIndex = row;
    
}


@end
