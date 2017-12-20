//
//  GLMerchat_StoreCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/14.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLMerchat_StoreCell.h"


@interface GLMerchat_StoreCell ()
@property (weak, nonatomic) IBOutlet UIButton *suspendBtn;
@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;//总销售额
@property (weak, nonatomic) IBOutlet UILabel *todayMoneyLabel;//今日销售额

@property (weak, nonatomic) IBOutlet UIButton *statusBtn;//显示状态

@end

@implementation GLMerchat_StoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.suspendBtn.layer.cornerRadius = 5.f;
    self.modifyBtn.layer.cornerRadius = 5.f;
    self.bgView.layer.cornerRadius = 5.f;

    self.statusBtn.layer.cornerRadius = 5.f;
    
}

- (IBAction)click:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(cellClick:indexPath:btnTitle:)]) {
        if (sender == self.suspendBtn) {
            [self.delegate cellClick:1 indexPath:self.indexPath btnTitle:self.suspendBtn.titleLabel.text];
        }else{
            [self.delegate cellClick:2 indexPath:self.indexPath btnTitle:self.modifyBtn.titleLabel.text];
        }
    }
}
- (void)setModel:(GLMerchat_StoreModel *)model {
    _model = model;
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.store_pic] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
//    self.picImageV.image = [UIImage imageNamed:PlaceHolderImage];
    self.nameLabel.text = model.shop_name;
    self.phoneLabel.text = model.phone;
    self.addressLabel.text = model.shop_address;
    self.totalMoneyLabel.text = model.total_money;
    self.todayMoneyLabel.text = model.today_money;
    
    switch ([model.status integerValue]) {
        case 0:
        {
            self.suspendBtn.hidden = YES;
            self.modifyBtn.hidden = YES;
            self.statusBtn.hidden = NO;
            [self.statusBtn setTitle:@"正在审核" forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            self.suspendBtn.hidden = NO;
            self.modifyBtn.hidden = NO;
            self.statusBtn.hidden = YES;
            if ([model.is_open integerValue] == 1) {
                [self.suspendBtn setTitle:@"暂停营业" forState:UIControlStateNormal];
                [self.modifyBtn setTitle:@"修改密码" forState:UIControlStateNormal];
            }else{
                [self.suspendBtn setTitle:@"开始营业" forState:UIControlStateNormal];
                [self.modifyBtn setTitle:@"修改密码" forState:UIControlStateNormal];
            }

        }
            break;
        case 2:
        {
            self.suspendBtn.hidden = YES;
            self.modifyBtn.hidden = YES;
            self.statusBtn.hidden = NO;
            [self.statusBtn setTitle:@"审核失败" forState:UIControlStateNormal];

        }
            break;
        case 3:
        {
            self.suspendBtn.hidden = YES;
            self.modifyBtn.hidden = YES;
            self.statusBtn.hidden = NO;
            [self.statusBtn setTitle:@"暂无资料" forState:UIControlStateNormal];

        }
            break;
            
        default:
            break;
    }
}

@end
