//
//  GLNearby_ClassifyHeaderView.h
//  Universialshare
//
//  Created by 龚磊 on 2017/5/15.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClassifyHeaderViewdelegete <NSObject>

-(void)tapgesture:(NSInteger)tag;
//点击轮播图
-(void)tapgestureImage:(NSInteger)index;
//点击扫码
-(void)clickSacnEvent;
//点击搜索
-(void)clickSerachevent;


@end

@interface GLNearby_ClassifyHeaderView : UIView

-(instancetype)initWithFrame:(CGRect)frame withDataArr:(NSArray*)dataArr;

@property (assign , nonatomic)id<ClassifyHeaderViewdelegete> delegete;

@property (weak, nonatomic) IBOutlet UIView *searchView;

@property (weak, nonatomic) IBOutlet UIButton *adressLb;

-(void)initdatasorece:(NSArray*)dataArr;

-(void)reloadScorlvoewimages:(NSArray*)dataArr;
//轮播高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightB;


@end
