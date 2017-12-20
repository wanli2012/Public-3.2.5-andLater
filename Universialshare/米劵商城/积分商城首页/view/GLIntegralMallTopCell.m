//
//  GLIntegralMallTopCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLIntegralMallTopCell.h"
#import "UIImageView+WebCache.h"
#import "GLMallHotModel.h"
@interface GLIntegralMallTopCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UIImageView *imageV2;
@property (weak, nonatomic) IBOutlet UIImageView *imageV3;
@property (weak, nonatomic) IBOutlet UIImageView *imageV4;
@property (weak, nonatomic) IBOutlet UIImageView *imageV5;
@property (weak, nonatomic) IBOutlet UIView *baseview;

@property (strong, nonatomic)NSMutableArray *imagearr;

@end

@implementation GLIntegralMallTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setNeedsLayout];
    [self layoutIfNeeded];

}


- (void)setModels:(NSArray *)models{
    _models = models;
    
    for (int i =0; i < _models.count; i++) {
        GLMallHotModel *model = _models[i];
        UIImageView *imagev =(UIImageView*)[self viewWithTag:i+1];
        [imagev removeGestureRecognizer:[imagev.gestureRecognizers firstObject]];
        [imagev sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:nil];
        
         UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(classifyClick:)];
        [imagev addGestureRecognizer:tap];
        
    }

}

-(void)classifyClick:(UITapGestureRecognizer*)gesture{

    NSInteger Tag = gesture.view.tag;
    
    [self.delegete tapgestureTag:Tag];

}


@end
