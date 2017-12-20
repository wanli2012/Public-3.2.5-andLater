//
//  GLHourseDetailThirdCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/3/30.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLHourseDetailThirdCell.h"

@interface GLHourseDetailThirdCell ()
{
    NSArray *_titles;
}
@property (nonatomic, strong)NSMutableArray *labelArr;

@end

@implementation GLHourseDetailThirdCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    _titles = @[@"厂商:",@"级别:",@"级别:",@"级别",@"级别",@"级别",@"级别",@"级别",@"级别"];
    _labelArr = [NSMutableArray array];
}


-(instancetype)initWithFrame:(CGRect)frame andDatasource:(NSArray *)arr :(NSString *)typename
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
        lab.text = typename;
        lab.textColor = [UIColor blackColor];
        lab.font = [UIFont systemFontOfSize:14];
        [self addSubview:lab];
        
        float upX = 10;
        float upY = 40;
        
        for (int i = 0; i<arr.count; i++) {
            NSString *str = [arr objectAtIndex:i] ;
            
            NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont boldSystemFontOfSize:14] forKey:NSFontAttributeName];
            CGSize size = [str sizeWithAttributes:dic];
            
            if ( upX > (self.frame.size.width-20 -size.width-35)) {
            
                upX = 10;
                upY += 30;
            }
            
            UILabel *lab= [[UILabel alloc] init];
            lab.frame = CGRectMake(upX, upY, size.width+30,25);
            lab.backgroundColor = [UIColor clearColor];
            lab.textColor = [UIColor darkGrayColor];
            lab.font = [UIFont systemFontOfSize:13];
            lab.text = arr[i];
            
            lab.layer.cornerRadius = 8;
            lab.layer.borderColor = [UIColor clearColor].CGColor;
            lab.layer.borderWidth = 0;
            [lab.layer setMasksToBounds:YES];
            
            [_labelArr addObject:lab];
            [self addSubview:lab];
            lab.tag = 100+i;
            upX+= SCREEN_WIDTH * 0.4;
        }
        
        upY +=30;
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, upY+10, self.frame.size.width, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        line.alpha = 0;
        [self addSubview:line];
        
        self.height = upY+11;
        frame.size.height = self.height;
        self.frame = frame;

    }
    return self;
}

@end
