//
//  GLNearby_ClassifyHeaderView.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/15.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLNearby_ClassifyHeaderView.h"
#import "GLNearby_ClassifyConcollectionCell.h"
#import "LBNearby_classifyItemView.h"
#import <Masonry/Masonry.h>

#import "SDCycleScrollView.h"

@interface GLNearby_ClassifyHeaderView ()<UIScrollViewDelegate,SDCycleScrollViewDelegate>

@property (strong, nonatomic)  UIScrollView *scorllView;
@property (strong, nonatomic)  UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet UIView *classifyView;
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (strong, nonatomic)SDCycleScrollView *cycleScrollView;
@property (strong, nonatomic)NSArray *imagearr;
@property (assign, nonatomic)NSInteger SCR_conW;

@end

@implementation GLNearby_ClassifyHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.inputView.layer.cornerRadius = 4;
    self.clipsToBounds = YES;
    self.classifyView.layer.cornerRadius = 4;
    self.clipsToBounds = YES;
    self.inputView.layer.borderWidth = 1;
    self.inputView.layer.borderColor = [UIColor whiteColor].CGColor;
    
}

-(instancetype)initWithFrame:(CGRect)frame withDataArr:(NSArray*)dataArr{

    self = [super initWithFrame:frame];
    
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"GLNearby_ClassifyHeaderView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.autoresizingMask = UIViewAutoresizingNone;
        self.SCR_conW = SCREEN_WIDTH ;
        [self initerface];
    }
    
    return self;

}

-(void)initerface{
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    [self.bannerView addSubview:self.cycleScrollView];
    

    _pageControl = [[UIPageControl alloc]init];
     _pageControl.numberOfPages = 0 ;
    _pageControl.currentPage = 0;
    _pageControl.hidesForSinglePage = YES;
    _pageControl.currentPageIndicatorTintColor = TABBARTITLE_COLOR;
    _pageControl.pageIndicatorTintColor = [UIColor groupTableViewBackgroundColor];
    _pageControl.backgroundColor = [UIColor clearColor];
    [_pageControl setValue:[UIImage imageNamed:@"banner未选中"] forKeyPath:@"pageImage"];
    [_pageControl setValue:[UIImage imageNamed:@"banner选中"] forKeyPath:@"currentPageImage"];
    [_pageControl addTarget:self action:@selector(pageControlChanged:) forControlEvents:UIControlEventValueChanged];
    
    _scorllView = [[UIScrollView alloc] init];
    _scorllView.pagingEnabled = YES;
    _scorllView.showsHorizontalScrollIndicator = NO;
    _scorllView.showsVerticalScrollIndicator = NO;
    _scorllView.delegate = self;
    _scorllView.backgroundColor = [UIColor clearColor];
       [self addSubview:_scorllView];
       [self addSubview:_pageControl];
    
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.classifyView).offset(0);
        make.leading.equalTo(self.classifyView).offset(0);
        make.bottom.equalTo(self.classifyView).offset(0);
        make.height.equalTo(@15);
    }];
    
    [_scorllView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.classifyView).offset(0);
        make.leading.equalTo(self.classifyView).offset(0);
        make.top.equalTo(self.classifyView).offset(0);
        make.bottom.equalTo(self.pageControl.mas_bottom).offset(0);
    }];
    
    [_cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.bannerView).offset(0);
        make.leading.equalTo(self.bannerView).offset(0);
        make.top.equalTo(self.bannerView).offset(0);
        make.bottom.equalTo(self.bannerView).offset(0);
    }];
    
     _scorllView.contentSize = CGSizeMake(self.SCR_conW , _scorllView.frame.size.height);

}

-(void)initdatasorece:(NSArray*)dataArr{
    
   [self.scorllView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
 
    _scorllView.contentSize = CGSizeMake(self.SCR_conW * ((dataArr.count ) / 10 + 1), _scorllView.frame.size.height);
    _pageControl.numberOfPages = ((dataArr.count ) / 10 + 1) ;

    NSInteger itemW = 45 * autoSizeScaleX ; //每个分类的宽度
    NSInteger itemH = itemW + 25; // 每个分类的高度
    NSInteger num = 5 ;//每行展示多少个分类
    NSInteger padding_x = 10 ;//第一个距离边界多少px
    NSInteger padding_top = 10 ;//距离顶部多少px
    NSInteger padding_y = 10 ;//item之间多少px
    NSInteger item_dis = (self.SCR_conW - padding_x * 2 - num * itemW) / (num - 1);
    
    for (int i = 0 ; i <= dataArr.count; i++) {
        
        LBNearby_classifyItemView *item = [[NSBundle mainBundle]loadNibNamed:@"LBNearby_classifyItemView" owner:nil options:nil].firstObject;
        
        int  V = i / num;
        int  H = i % num;
        NSInteger sep = self.SCR_conW * (i / 10);
        
        item.tag = 10 + i;
        item.frame = CGRectMake(sep + padding_x + (itemW + item_dis) * H, padding_x + padding_top + (padding_y + itemH) * (V % 2), itemW , itemH);
        item.autoresizingMask = UIViewAutoresizingNone;
        item.backgroundColor = [UIColor clearColor];
        if (i == dataArr.count) {
            item.titleLb.text = @"全部分类";
            item.imagev.image = [UIImage imageNamed:@"全部分类"];
        }else{
            item.titleLb.text = dataArr[i][@"trade_name"];
            [item.imagev sd_setImageWithURL:[NSURL URLWithString:dataArr[i][@"thumb"]] placeholderImage:[UIImage imageNamed:@"分类占位图"]];
        }
        item.titleLb.font = [UIFont systemFontOfSize:10 * autoSizeScaleX];
        
        UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestureClassfty:)];
        [item addGestureRecognizer:tapgesture];
        [_scorllView addSubview:item];
        
    }
    
}

-(void)reloadScorlvoewimages:(NSArray *)dataArr{
    self.imagearr = dataArr;
    if (self.imagearr.count > 1) {
        self.cycleScrollView.autoScroll = YES;
    }
    self.cycleScrollView.imageURLStringsGroup = self.imagearr;
}

-(void)pageControlChanged:(UIPageControl*)pageControl{

    NSInteger page = pageControl.currentPage;
    [self.scorllView setContentOffset:CGPointMake(page * self.SCR_conW, 0) animated:YES];

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    NSInteger offset = scrollView.contentOffset.x / self.SCR_conW;

    self.pageControl.currentPage = offset;

}

-(void)tapgestureClassfty:(UITapGestureRecognizer*)tap{

    [self.delegete tapgesture:tap.view.tag];

}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    [self.delegete tapgestureImage:index];
}
//扫码
- (IBAction)clickScan:(id)sender {
    [self.delegete clickSacnEvent];
}
//搜索
- (IBAction)clickSearch:(id)sender {
    [self.delegete clickSerachevent];
}

-(SDCycleScrollView*)cycleScrollView{
    
    if (!_cycleScrollView) {
        _cycleScrollView = [[SDCycleScrollView alloc]init];//当一张都没有的时候的 占位图
        //每一张图的占位图
        _cycleScrollView.delegate = self;
        _cycleScrollView.placeholderImage = [UIImage imageNamed:LUNBO_PlaceHolder];
         _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.autoScrollTimeInterval = 2;// 自动滚动时间间隔
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 翻页 右下角
        _cycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];// 图片对应的标题的 背景色。（因为没有设标题）
        _cycleScrollView.pageControlDotSize = CGSizeMake(10, 10);
        _cycleScrollView.localizationImageNamesGroup = self.imagearr;
        _cycleScrollView.showPageControl = NO;
    }
    
    return _cycleScrollView;
    
}

-(NSArray*)imagearr{
    
    if (!_imagearr) {
        _imagearr = @[@"逛逛占位图"];
    }
    
    return _imagearr;
    
}
@end
