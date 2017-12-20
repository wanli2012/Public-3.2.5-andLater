//
//  LBMineCenterReceivingGoodsTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterReceivingGoodsTableViewCell.h"

#import "LBWaitOrdersListModel.h"
#import <Masonry/Masonry.h>

@interface LBMineCenterReceivingGoodsTableViewCell ()<DWBubbleMenuViewDelegate>
@property(nonatomic , strong)UILabel *showlabel;
@property(nonatomic , strong)NSArray *buttonArr;

@end
@implementation LBMineCenterReceivingGoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    self.buyBt.layer.borderWidth = 1;
//    self.buyBt.layer.borderColor = YYSRGBColor(191, 0, 0, 1).CGColor;
//    
//    self.SeeBt.layer.borderWidth = 1;
//    self.SeeBt.layer.borderColor = YYSRGBColor(191, 0, 0, 1).CGColor;
    
    self.sureSend.layer.cornerRadius = 4;
    self.sureSend.clipsToBounds = YES;
    
    [self addSubview:self.downMenuButton];
    [_downMenuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-10);
        make.centerY.equalTo(self);
        make.width.equalTo([NSNumber numberWithDouble:40]);
        make.height.equalTo([NSNumber numberWithDouble:40]);
    }];
}

- (NSArray *)createDemoButtonArray {
    NSMutableArray *buttonsMutable = [[NSMutableArray alloc] init];
    
    int i = 0;
    for (NSString *title in self.buttonArr) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        button.frame = CGRectMake(0.f, 0.f, 80.f, 30.f);
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.layer.cornerRadius = button.frame.size.height / 2.f;
        button.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.5f];
        button.clipsToBounds = YES;
        button.tag = i++;
        
        [button addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
        
        [buttonsMutable addObject:button];
    }
    
    return [buttonsMutable copy];
}

- (UILabel *)createHomeButtonView {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 40.f, 40.f)];
    label.text = @"展开";
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = label.frame.size.height / 2.f;
    label.backgroundColor =TABBARTITLE_COLOR;
    label.clipsToBounds = YES;
    
    self.showlabel = label;
    
    return label;
}

- (void)test:(UIButton *)sender {
//查看物流
    if (sender.tag == 0) {
        [self.delegete checklogistics:self.indexpath];
    } else if (sender.tag == 1  && [_WaitOrdersListModel.is_receipt isEqualToString:@"3"]) {//确认收货
        [self.delegete BuyAgaingoodid:_WaitOrdersListModel.orderGoodsId  orderid:self.order_id indexpath:self.indexpath];
    }
}

- (void)bubbleMenuButtonDidExpand:(DWBubbleMenuButton *)expandableView{
     self.showlabel.text = @"收起";
}

- (void)bubbleMenuButtonDidCollapse:(DWBubbleMenuButton *)expandableView{

    self.showlabel.text = @"展开";
    [self addSubview:self.downMenuButton];
    
}
-(void)setWaitOrdersListModel:(LBWaitOrdersListModel *)WaitOrdersListModel{

    if (_WaitOrdersListModel != WaitOrdersListModel) {
        _WaitOrdersListModel = WaitOrdersListModel;
    }
    
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:_WaitOrdersListModel.image_cover] placeholderImage:[UIImage imageNamed:@"planceholder"]];
    self.cartype.text = [NSString stringWithFormat:@"%@",_WaitOrdersListModel.goods_name];
    self.numlb.text = [NSString stringWithFormat:@"数量:x%@",_WaitOrdersListModel.goods_num];
    self.pricelb.text = [NSString stringWithFormat:@"价格:¥%@",_WaitOrdersListModel.goods_price];
    self.storename.text = [NSString stringWithFormat:@"店名:%@",_WaitOrdersListModel.shop_name];
    
    if ([_WaitOrdersListModel.is_receipt isEqualToString:@"3"]) {//未收货
//        [self.sureSend setTitle:@"确认收货" forState:UIControlStateNormal];
//        self.sureSend.backgroundColor = TABBARTITLE_COLOR;
//        self.sureSend.userInteractionEnabled = YES;
        
        self.buttonArr = @[@"查看物流",@"确认收货",@"申请退款中"];
        
    }else if ([_WaitOrdersListModel.is_receipt isEqualToString:@"2"]){// 未发货
//        [self.sureSend setTitle:@"未发货" forState:UIControlStateNormal];
//        self.sureSend.backgroundColor = [UIColor redColor];
//        self.sureSend.userInteractionEnabled = NO;
        
        self.buttonArr = @[@"查看物流",@"未发货"];
        
    }else if ([_WaitOrdersListModel.is_receipt isEqualToString:@"1"]){// 已收货
//        [self.sureSend setTitle:@"已收货" forState:UIControlStateNormal];
//        self.sureSend.backgroundColor = [UIColor grayColor];
//        self.sureSend.userInteractionEnabled = NO;
        
        self.buttonArr = @[@"查看物流",@"已收货"];
        
    }
    for(id view in [_downMenuButton subviews])
    {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    
     [_downMenuButton addButtons:[self createDemoButtonArray]];

}

- (IBAction)buyevent:(UIButton *)sender {
    
//    [self.delegete BuyAgaingoodid:_WaitOrdersListModel.orderGoodsId  orderid:self.order_id indexpath:self.indexpath];
}

//
//- (IBAction)SeeEvent:(UIButton *)sender {
//    
//    [self.delegete checklogistics:self.index];
//    
//}

-(DWBubbleMenuButton*)downMenuButton{
    if (!_downMenuButton) {
        UILabel *homeLabel = [self createHomeButtonView];
        _downMenuButton = [[DWBubbleMenuButton alloc] init];
        _downMenuButton.direction = DirectionLeft;
        _downMenuButton.homeButtonView = homeLabel;
        _downMenuButton.delegate = self;
        if (SCREEN_WIDTH <= 320) {
            _downMenuButton.buttonSpacing = (SCREEN_WIDTH - 300)/3.0;
        }
        
    }
    return _downMenuButton;
}

-(NSArray*)buttonArr{

    if (!_buttonArr) {
        _buttonArr = [NSArray array];
    }

    return _buttonArr;
}
@end
