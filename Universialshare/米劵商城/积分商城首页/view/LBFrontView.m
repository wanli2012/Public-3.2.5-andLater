//
//  LBFrontView.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/8/12.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBFrontView.h"
#import <Masonry/Masonry.h>

@interface LBFrontView ()<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *searchview;

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic)NSArray *imagearr;

@end

@implementation LBFrontView

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        self = [[NSBundle mainBundle]loadNibNamed:@"LBFrontView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.autoresizingMask = UIViewAutoresizingNone;
        self.backgroundColor = [UIColor whiteColor];
        self.searchview.layer.cornerRadius = 4;
        self.searchview.clipsToBounds = YES;
        [self initInyerface];
    }
    return self;
}

-(void)initInyerface{
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [self.backView addSubview:self.cycleScrollView];
    
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self.backView).offset(0);
        make.leading.equalTo(self.backView).offset(0);
        make.top.equalTo(self.backView).offset(0);
        make.bottom.equalTo(self.backView).offset(0);
    }];

    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgesturesearch)];
    
    [self.searchview addGestureRecognizer:tapgesture];

}

-(void)tapgesturesearch{
    
    [self.delegete tapgesturesearch];
    
}

-(SDCycleScrollView*)cycleScrollView{

    if (!_cycleScrollView) {
        _cycleScrollView = [[SDCycleScrollView alloc]init];
        _cycleScrollView.delegate = self;
        //每一张图的占位图
        _cycleScrollView.placeholderImage = [UIImage imageNamed:LUNBO_PlaceHolder];
         _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.autoScrollTimeInterval = 2;// 自动滚动时间间隔
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 翻页 右下角
        _cycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];// 图片对应的标题的 背景色。（因为没有设标题）
        _cycleScrollView.pageControlDotSize = CGSizeMake(10, 10);
        _cycleScrollView.localizationImageNamesGroup = self.imagearr;
        _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"banner选中"];
        _cycleScrollView.pageDotImage = [UIImage imageNamed:@"banner未选中"];
    }
    
    return _cycleScrollView;

}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
   
    [self.delegete clickScrollViewImage:index];
}

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{

    
}

-(void)reloadImage:(NSArray *)arr{
    self.imagearr = arr;
    self.cycleScrollView.imageURLStringsGroup = arr;

}

-(NSArray*)imagearr{

    if (!_imagearr) {
        _imagearr = @[@"banner01.jpg",
                      @"banner02.jpg",
                      @"banner03.jpg"];
    }
    
    return _imagearr;

}

@end
