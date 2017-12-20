//
//  GLHourseDetailFirstCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/3/30.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLHourseDetailFirstCell.h"

@interface GLHourseDetailFirstCell()
{
    NSString *_price;
    LoadWaitView *_loadV;
    
}

@property (weak, nonatomic) IBOutlet UILabel *monthSellLabel;
@property (weak, nonatomic) IBOutlet UILabel *yunfeiLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *modelLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstarit;

@end

@implementation GLHourseDetailFirstCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(GLGoodsDetailModel *)model{
    _model = model;;
    _monthSellLabel.text = [NSString stringWithFormat:@"总销%@笔",model.sell_count];
    _yunfeiLabel.text = [NSString stringWithFormat:@"运费:%@元",model.posttage];
    _modelLb.text = [NSString stringWithFormat:@"奖励模式:%@",model.intea_type];

    if ([model.goods_info rangeOfString:@"null"].location != NSNotFound || model.goods_info.length <= 0 ) {
        self.miaosuH.constant = 0;
        self.miaosuT.constant = 0;
    }else{
        self.miaosuH.constant = 20;
        self.miaosuT.constant = 15;
          _priceLabel.text = [NSString stringWithFormat:@"--%@",model.goods_info];
    }
    if ([_monthSellLabel.text rangeOfString:@"null"].location != NSNotFound) {
        _monthSellLabel.text = [NSString stringWithFormat:@"总销0笔"];
    }
    if ([_yunfeiLabel.text rangeOfString:@"null"].location != NSNotFound) {
        _yunfeiLabel.text = [NSString stringWithFormat:@"运费:0.0元"];
    }
    if ([_modelLb.text rangeOfString:@"null"].location != NSNotFound) {
        _modelLb.text = [NSString stringWithFormat:@"奖励模式:%%0"];
    }
    
    NSString *attrStr = [model.attr componentsJoinedByString:@"  "];

    _nameLabel.text = [NSString stringWithFormat:@"%@",_model.goods_name];
    
    if(attrStr.length <= 0){
        self.topConstarit.constant = 26;
         _nameLabel.text = @"";
    }else{
        self.topConstarit.constant = 10;
    }
    
    if([self.model.is_collection integerValue] == 1){
        
        self.collectionBt.selected = YES;
    }else{
        
        self.collectionBt.selected = NO;
    }
    
}

- (NSMutableAttributedString *)changeColor:(UILabel*)label rangeNumber:(NSString * )rangeNum
{

    NSString *totalStr = [NSString stringWithFormat:@"%@%@",_model.goods_name,rangeNum];
    NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString:totalStr];
    NSRange rangel = [[textColor string] rangeOfString:rangeNum];
    [textColor addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:rangel];
    return textColor;
}
//收藏
- (IBAction)collectionEvent:(UIButton *)sender {
    
    NSLog(@"%@",self.model.is_collection);
    
    if([_model.is_collection integerValue] == 1){
        
        [self cancelCollectionProduct];
    }else{
        [self collectionProduct];
        
    }
    
}


//收藏
-(void)collectionProduct{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"GID"] = _model.goods_id;
    dict[@"type"] = @(1);
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"Shop/addMyCollect" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == 1){
           _model.is_collection = @"1";
            self.collectionBt.selected = YES;
            [[UIApplication sharedApplication].keyWindow makeToast:@"收藏成功" duration:1 position:CSToastPositionCenter];
            
        }else{
            
            [[UIApplication sharedApplication].keyWindow makeToast:responseObject[@"message"] duration:1 position:CSToastPositionCenter];
            
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [[UIApplication sharedApplication].keyWindow makeToast:@"网络请求失败" duration:1 position:CSToastPositionCenter];
        
    }];
    
}
//取消收藏
-(void)cancelCollectionProduct{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"GID"] = _model.goods_id;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"Shop/delMyCollect" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == 1){
            _model.is_collection = @"0";
          self.collectionBt.selected = NO;
            [[UIApplication sharedApplication].keyWindow makeToast:@"取消收藏成功" duration:1 position:CSToastPositionCenter];
            
        }else{
            
            [[UIApplication sharedApplication].keyWindow makeToast:responseObject[@"message"] duration:1 position:CSToastPositionCenter];
        }
        
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [[UIApplication sharedApplication].keyWindow makeToast:@"网络请求失败" duration:1 position:CSToastPositionCenter];
    }];
    
}


@end
