//
//  LBRiceShopTagView.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/11/11.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LBRiceShopTagViewDelegate <NSObject>

-(void)LBRiceShopTagView:(UIView*)dwq fetchWordToTextFiled:(NSDictionary *)dic;

@end

@interface LBRiceShopTagView : UIView<UIGestureRecognizerDelegate>
{
    CGRect previousFrame;
    NSInteger totalHeight;
}
@property (nonatomic, weak) id<LBRiceShopTagViewDelegate> delegate;
/**
 *  整个View的背景颜色
 */
@property (nonatomic, strong) UIColor *BigBGColor;
/**
 *  设置子标签View的单一颜色
 */
@property (nonatomic, strong) UIColor *singleTagColor;
/**
 *  标签文本数组的赋值
 */
-(void)setTagWithTagArray:(NSArray *)arr;

@property (strong , nonatomic)NSArray *dataArr;

@property (assign , nonatomic)NSInteger selecindex;//选中第几个 默认第一个

@end
