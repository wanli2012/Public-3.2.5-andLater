//
//  LBRiceShopTagView.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/11/11.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBRiceShopTagView.h"
/** 字体离边框的水平距离 */
#define HORIZONTAL_PADDING 10.0f
/** 字体离边框的竖直距离 */
#define VERTICAL_PADDING   5.0f
/** tagLab之间的水平间距 */
#define HORIZONTAL_MARGIN  15.0f
/** tagLab之间的竖直间距 */
#define VERTICAL_MARGIN    10.0f

@implementation LBRiceShopTagView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        totalHeight=0;
        self.selecindex = 0;
        self.userInteractionEnabled = YES;
        self.frame = frame;
    }
    return self;
}
-(void)setTagWithTagArray:(NSArray*)arr{
    self.dataArr = arr;
    /**
     *  很关键——————防止放于cell上时复用重复创建
     *  让第之后创建totalHeight重新置为0
     *  删除之前存在的subView
     */
    totalHeight = 0;
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    /***************************************/
    
    previousFrame = CGRectZero;
    
    for (int i = 0; i < arr.count; i++) {
        UILabel *tag = [[UILabel alloc] initWithFrame:CGRectZero];
        tag.userInteractionEnabled = YES;
        //        UIButton*tag = [UIButton buttonWithType:0];
        tag.frame = CGRectZero;
     
        if (i == self.selecindex) {
            tag.backgroundColor=TABBARTITLE_COLOR;
            tag.textColor = [UIColor whiteColor];
        }else{
            tag.textColor = [UIColor blackColor];
            tag.backgroundColor=[UIColor groupTableViewBackgroundColor];
        }
        tag.textAlignment = NSTextAlignmentCenter;
        tag.font = [UIFont systemFontOfSize:15];
        tag.text = arr[i][@"title"];
        tag.tag = 500 + i;
        tag.layer.cornerRadius = 4.0;
        tag.clipsToBounds = YES;
        
        CGSize textStrSize = [tag.text sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}];
        textStrSize.width += HORIZONTAL_PADDING*2;
        textStrSize.height += VERTICAL_PADDING*2 + 7;
        
        CGRect newRect = CGRectZero;
        
        /** 如果新的tagLab超出屏幕边界 */
        if (previousFrame.origin.x + previousFrame.size.width + textStrSize.width + HORIZONTAL_MARGIN > self.bounds.size.width) {
            newRect.origin = CGPointMake(10, previousFrame.origin.y + textStrSize.height + VERTICAL_MARGIN);
            totalHeight += textStrSize.height + VERTICAL_MARGIN;
        }
        else {
            newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + HORIZONTAL_MARGIN, previousFrame.origin.y);
        }
        newRect.size = textStrSize;
        [tag setFrame:newRect];
        previousFrame = tag.frame;
        [self setHight:self andHight:totalHeight + textStrSize.height];
        [self addSubview:tag];
        //        [tag addTarget:self action:@selector(touchSubTagViewClick:) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer *tapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchSubTagView:)];
        tapOne.delegate = self;
        tapOne.numberOfTapsRequired = 1.0;
        [tag addGestureRecognizer:tapOne];
    }
    if(_BigBGColor){
        self.backgroundColor=_BigBGColor;
    }else{
        self.backgroundColor=[UIColor whiteColor];
    }
}

-(void)touchSubTagView:(UITapGestureRecognizer*)tapOne
{
    UILabel *lab = (UILabel *)tapOne.view;
    UILabel *selectlab = (UILabel *)[self viewWithTag:500 + self.selecindex];
    
    if (self.selecindex != lab.tag - 500) {
        lab.backgroundColor=TABBARTITLE_COLOR;
        lab.textColor = [UIColor whiteColor];
        
        selectlab.textColor = [UIColor blackColor];
        selectlab.backgroundColor=[UIColor groupTableViewBackgroundColor];
         self.selecindex = lab.tag - 500;
        if (self.delegate && [self.delegate respondsToSelector:@selector(LBRiceShopTagView:fetchWordToTextFiled:)]) {
            [self.delegate LBRiceShopTagView:self fetchWordToTextFiled:self.dataArr[lab.tag - 500]];
        }
    }

}
#pragma mark-改变子tag控件高度
- (void)setHight:(UIView *)view andHight:(CGFloat)hight
{
    CGRect tempFrame = view.frame;
    tempFrame.size.height = hight;
    view.frame = tempFrame;
}

-(NSArray*)dataArr{

    if (!_dataArr) {
        _dataArr = [NSArray array];
    }
    return _dataArr;
}
@end
