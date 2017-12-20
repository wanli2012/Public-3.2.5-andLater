//
//  GLBankCardCellTableViewCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/14.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLBankCardCellTableViewCell.h"

@interface GLBankCardCellTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;
@property (weak, nonatomic) IBOutlet UILabel *banknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankNumLabel;


@end

@implementation GLBankCardCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(GLBankCardModel *)model {
    _model = model;
    _banknameLabel.text = model.name;
    
    _bankNumLabel.text = [NSString stringWithFormat:@"%@*****%@",[model.number substringToIndex:4],[model.number substringFromIndex:model.number.length - 4]];

    if ([model.name isEqualToString:@"中国银行"]) {
        
        _iconImageV.image = [UIImage imageNamed:@"BOC"];
        
    }else if ([model.name isEqualToString:@"中国工商银行"]){
        
        _iconImageV.image = [UIImage imageNamed:@"ICBC"];
        
    }else if ([model.name isEqualToString:@"中国建设银行"]){
        
        _iconImageV.image = [UIImage imageNamed:@"CCB"];
        
    }else if ([model.name isEqualToString:@"中国农业银行"]){
        
        _iconImageV.image = [UIImage imageNamed:@"ABC"];
        
    }else{
        _iconImageV.image = [UIImage imageNamed:@"bank_nopicture"];
    }

}
@end
