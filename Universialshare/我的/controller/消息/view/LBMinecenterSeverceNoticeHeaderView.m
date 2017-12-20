//
//  LBMinecenterSeverceNoticeHeaderView.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/29.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMinecenterSeverceNoticeHeaderView.h"
#import <Masonry/Masonry.h>

@implementation LBMinecenterSeverceNoticeHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor=[UIColor whiteColor];
        [self initsubsview];//_init表示初始化方法
    }
    
    return self;
}

-(void)initsubsview{

    [self addSubview:self.timelebel];
    [self addSubview:self.lineview];
    
    [self.timelebel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self);
        make.leading.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self).offset(-1);
    }];
    
    [self.timelebel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self);
        make.leading.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(@1);
    }];

}

-(UILabel*)timelebel{
    
    if (!_timelebel) {
        _timelebel=[[UILabel alloc]init];
        _timelebel.backgroundColor=[UIColor whiteColor];
        _timelebel.text=@"0:00";
        _timelebel.textColor=[UIColor blackColor];
        _timelebel.font=[UIFont systemFontOfSize:12 * autoSizeScaleX];
        _timelebel.textAlignment=NSTextAlignmentCenter;
        
        
    }
    
    return _timelebel;
    
}

-(UIView*)lineview{

    if (!_lineview) {
        _lineview =[[UIView alloc]init];
        _lineview.backgroundColor=[UIColor groupTableViewBackgroundColor];
    }
    return _lineview;
}
@end
