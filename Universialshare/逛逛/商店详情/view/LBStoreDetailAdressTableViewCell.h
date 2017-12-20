//
//  LBStoreDetailAdressTableViewCell.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/16.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LBStoreDetailAdressDelegete <NSObject>

-(void)gotheremap;
-(void)takePhne;
-(void)contactMerchant;

@end


@interface LBStoreDetailAdressTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *adressLb;
@property (weak, nonatomic) IBOutlet UIButton *Bobt;
@property (weak, nonatomic) IBOutlet UIButton *phoneBt;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (assign, nonatomic)id<LBStoreDetailAdressDelegete> delegete;
@property (weak, nonatomic) IBOutlet UIButton *chatBt;

@end
