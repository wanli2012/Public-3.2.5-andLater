
//
//  CustomDatePicker.m
//  PublicLetter
//
//  Created by jiangxiao on 15/6/8.
//  Copyright (c) 2015年 江萧. All rights reserved.
//

#import "CustomDatePicker.h"

@implementation CustomDatePicker
{
    
//    NSArray *dayarr1;
//    NSArray *dayarr2;
    NSMutableArray *yeararr;
    UIPickerView *picker;
}
@synthesize year,day,month;
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       picker = [[UIPickerView alloc] initWithFrame:self.bounds];
       
        picker.delegate  = self;
        picker.dataSource = self;
        picker.showsSelectionIndicator = YES;
        [self addSubview:picker];

        yeararr = [[NSMutableArray alloc] initWithCapacity:0];
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy"];
        year = [[formatter stringFromDate:date] intValue];
        [formatter setDateFormat:@"MM"];
         month = [[formatter stringFromDate:date] intValue];

        for (int i = year-30; i<year+30; i++) {
            NSString *str = [NSString stringWithFormat:@"%d",i];
//            NSLog(@"%@",str);
            [yeararr addObject:str];
        }
        [picker selectRow:30 inComponent:0 animated:YES];
        [picker selectRow:month-1 inComponent:1 animated:YES];

        
    }
    return self;
}
#pragma mark - pickerview
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{

    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if(component == 0)
    {
        return yeararr.count;
    }
    else{
        
        return 12;
    }
    
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *mycom1 = [[UILabel alloc] init];
    mycom1.textAlignment = NSTextAlignmentCenter;
    mycom1.backgroundColor = [UIColor clearColor];
    mycom1.frame = CGRectMake(0, 0, self.frame.size.width/2.0, 50);
    [mycom1 setFont:[UIFont boldSystemFontOfSize:16]];
//    [mycom1 setFont:[UIFont systemFontOfSize:16]];
    mycom1.font = [UIFont systemFontOfSize:16];
    if(component == 0)
    {
        mycom1.text = [NSString stringWithFormat:@"%@年",[yeararr objectAtIndex:row]];
    }
    else{
        mycom1.text = [NSString stringWithFormat:@"%ld月",row+1];
    }

    return mycom1;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    
    return self.frame.size.width/2.0;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 50;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    int rowy = (int)[picker selectedRowInComponent:0];
    int rowm = (int)[picker selectedRowInComponent:1];

    year = [[yeararr objectAtIndex:rowy] intValue];
     month = (int)rowm+1;

}


@end
