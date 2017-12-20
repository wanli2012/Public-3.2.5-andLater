//
//  LBCountDownActivityTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/12/2.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBCountDownActivityTableViewCell.h"
#import <Masonry/Masonry.h>
#import "UILabel+UILabel_ChangeLineSpaceAndWordSpace.h"
#import "LBCustomAttribuText.h"
#import "CountDown.h"

@interface LBCountDownActivityTableViewCell ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *titleview;
@property (weak, nonatomic) IBOutlet UILabel *titileLb;
@property (weak, nonatomic) IBOutlet UILabel *timeTitile;
@property (weak, nonatomic) IBOutlet UILabel *infolb;
@property (weak, nonatomic) IBOutlet UILabel *pricelb;
@property (weak, nonatomic) IBOutlet UILabel *numlb;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (strong, nonatomic)NSMutableArray *imagearr;
@property (weak, nonatomic) IBOutlet UIButton *hourLb;
@property (weak, nonatomic) IBOutlet UIButton *mineteLb;
@property (weak, nonatomic) IBOutlet UIButton *secondLb;
@property (strong, nonatomic)  CountDown *countDown;


@end

@implementation LBCountDownActivityTableViewCell

-(void)dealloc{
    [self.countDown destoryTimer];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    [UILabel changeWordSpaceForLabel:self.titileLb WithSpace:2];
//    self.titileLb.textAlignment  =  NSTextAlignmentCenter;
    self.titileLb.font = [UIFont fontWithName:@"RuixianTopHeiHeavyGB1.0" size:16];

    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.titleview.bounds byRoundingCorners:UIRectCornerTopRight |UIRectCornerBottomRight cornerRadii:CGSizeMake(15,15)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.titleview.bounds;
    maskLayer.path = maskPath.CGPath;
    self.titleview.layer.mask = maskLayer;
      self.countDown = [[CountDown alloc] init];

}

-(void)setModel:(LBCountDownmodel *)model{
    _model = model;
    
    _titileLb.text = [NSString stringWithFormat:@"%@",_model.active_name];
    _infolb.text = [NSString stringWithFormat:@"%@",_model.goods_name];
    _numlb.text = [NSString stringWithFormat:@"剩余:%@件",_model.surplus_count];

    [self.imageview sd_setImageWithURL:[NSURL URLWithString:_model.banner_img] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    
    if ([_model.coupons floatValue] <= 0) {
        NSString *priceAll = [NSString stringWithFormat:@"抢购价: ¥%@",_model.rice];
        self.pricelb.attributedText = [LBCustomAttribuText originstr:priceAll specilstr:_model.rice attribus:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
    }else if([_model.rice floatValue] <= 0){
        NSString *priceAll = [NSString stringWithFormat:@"抢购价: %@米券",_model.coupons];
        self.pricelb.attributedText = [LBCustomAttribuText originstr:priceAll specilstr:_model.coupons attribus:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
    }else{
        NSString *priceAll = [NSString stringWithFormat:@"抢购价: ¥%@+%@米券",_model.rice,_model.coupons];
        self.pricelb.attributedText = [LBCustomAttribuText originstr:priceAll specilstrarr:@[_model.rice,_model.coupons] attribus:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
        
    }
    
    NSInteger b= [self compareDate:[self nowtimeWithString] withDate:[self timeWithTimeIntervalString:_model.active_end_time]];
    
    if (b == -1) {
         self.timeTitile.text = @"活动已经结束";
        [self.hourLb setTitle:@"00" forState:UIControlStateNormal];
        [self.mineteLb setTitle:@"00" forState:UIControlStateNormal];
        [self.secondLb setTitle:@"00" forState:UIControlStateNormal];
        return;
    }
      __weak __typeof(self) weakSelf= self;
    [self.countDown countDownWithPER_SECBlock:^{

        _model.now_time = [NSString stringWithFormat:@"%f",[_model.now_time doubleValue] + 1];
        
        NSInteger a= [weakSelf compareDate:[weakSelf nowtimeWithString] withDate:[weakSelf timeWithTimeIntervalString:_model.active_start_time]];
        
        if (a == 0) {
            [weakSelf getNowTimeWithString:[weakSelf timeWithTimeIntervalString:_model.active_end_time] stuasstr:@"结束"];
        }else if (a==1){
            [weakSelf getNowTimeWithString:[weakSelf timeWithTimeIntervalString:_model.active_start_time] stuasstr:@"开始"];
        }else{
            [weakSelf getNowTimeWithString:[weakSelf timeWithTimeIntervalString:_model.active_end_time] stuasstr:@"结束"];
        }
        
    }];
  
}

-(void )getNowTimeWithString:(NSString *)aTimeString stuasstr:(NSString*)stuasstr{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // 截止时间date格式
    NSDate  *expireDate = [formater dateFromString:aTimeString];
    NSDate  *nowDate = [formater dateFromString:[self nowtimeWithString]];

//    NSDate  *nowDate = [NSDate date];
//    // 当前时间字符串格式
//    NSString *nowDateStr = [formater stringFromDate:nowDate];
//    // 当前时间date格式
//    nowDate = [formater dateFromString:nowDateStr];
    
    NSTimeInterval timeInterval =[expireDate timeIntervalSinceDate:nowDate];

    int days = (int)(timeInterval/(3600*24));
    int hours = (int)((timeInterval-days*24*3600)/3600);
    int minutes = (int)(timeInterval-days*24*3600-hours*3600)/60;
    int seconds = timeInterval-days*24*3600-hours*3600-minutes*60;
    
    NSString *dayStr;NSString *hoursStr;NSString *minutesStr;NSString *secondsStr;
    //天
    dayStr = [NSString stringWithFormat:@"%d",days];
    //小时
    if(hours<10)
        hoursStr = [NSString stringWithFormat:@"0%d",hours];
    else
        hoursStr = [NSString stringWithFormat:@"%d",hours];
    //分钟
    if(minutes<10)
        minutesStr = [NSString stringWithFormat:@"0%d",minutes];
    else
        minutesStr = [NSString stringWithFormat:@"%d",minutes];
    //秒
    if(seconds < 10)
        secondsStr = [NSString stringWithFormat:@"0%d", seconds];
    else
        secondsStr = [NSString stringWithFormat:@"%d",seconds];
    if (hours<=0&&minutes<=0&&seconds<=0) {
        self.timeTitile.text = @"活动已经结束";
        [self.hourLb setTitle:@"00" forState:UIControlStateNormal];
        [self.mineteLb setTitle:@"00" forState:UIControlStateNormal];
        [self.secondLb setTitle:@"00" forState:UIControlStateNormal];
        return;
    }
    if (days) {
        self.timeTitile.text = [NSString stringWithFormat:@"距离活动%@%@天",stuasstr,dayStr];
    }else{
    self.timeTitile.text = [NSString stringWithFormat:@"距离活动%@",stuasstr];
    }
    
    [self.hourLb setTitle:hoursStr forState:UIControlStateNormal];
    [self.mineteLb setTitle:minutesStr forState:UIControlStateNormal];
    [self.secondLb setTitle:secondsStr forState:UIControlStateNormal];
    
}

- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd  HH:mm:ss"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

-(NSString*)nowtimeWithString{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd  HH:mm:ss"];
    
//    // 毫秒值转化为秒
//    NSDate* date = [NSDate date];
//    NSString* dateString = [formatter stringFromDate:date];
//    return dateString;
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[self.model.now_time doubleValue]];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
    
}
//比较两个日期的大小  日期格式为2016-08-14 08：46：20
- (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate
{
    NSInteger aa;
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dta = [[NSDate alloc] init];
    NSDate *dtb = [[NSDate alloc] init];
    
    dta = [dateformater dateFromString:aDate];
    dtb = [dateformater dateFromString:bDate];
    NSComparisonResult result = [dta compare:dtb];
    if (result==NSOrderedSame)
    {
        //        相等
        aa=0;
    }else if (result==NSOrderedAscending)
    {
        //bDate比aDate大
        aa=1;
    }else
    {
        //bDate比aDate小
        aa=-1;
        
    }
    
    return aa;
}


-(NSMutableArray*)imagearr{
    
    if (!_imagearr) {
        _imagearr = [NSMutableArray array];
    }
    
    return _imagearr;
    
}

@end
