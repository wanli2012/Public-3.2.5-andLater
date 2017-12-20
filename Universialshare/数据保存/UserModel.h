//
//  UserModel.h
//  813DeepBreathing
//
//  Created by rimi on 15/8/13.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject<NSCoding>
@property (nonatomic, assign) BOOL needAutoLogin;

@property (nonatomic, assign)BOOL   loginstatus;//登陆状态

@property (nonatomic, copy)NSString  *uid;//用户uid
@property (nonatomic, copy)NSString  *phone;//用户手机号
@property (nonatomic, copy)NSString  *name;//用户ID
@property (nonatomic, copy)NSString  *banknumber;//默认银行卡
@property (nonatomic, copy)NSString  *groupId;//用户组id
@property (nonatomic, copy)NSString  *regTime;//注册时间
@property (nonatomic, copy)NSString  *lastTime;//上次登录时间
@property (nonatomic, copy)NSString  *token;//token 校验码
@property (nonatomic, copy)NSString  *headPic;//头像地址
@property (nonatomic, copy)NSString  *mark;//积分
@property (nonatomic, copy)NSString  *loveNum;//爱心数量
@property (nonatomic, copy)NSString  *ketiBean;//志愿豆 可提豆
@property (nonatomic, copy)NSString  *recommendMark;//推荐提成 注册奖励
@property (nonatomic, copy)NSString  *lastFanLiTime;//上次奖励时间
@property (nonatomic, copy)NSString  *giveMeMark;//获赠的豆豆
@property (nonatomic, copy)NSString  *version;//版本号
@property (nonatomic, copy)NSString  *vsnUpdateTime;//版本上次更新时间
@property (nonatomic, copy)NSString  *vsnAddress;//版本地址
@property (nonatomic, copy)NSString  *counta;//
@property (nonatomic, copy)NSString  *usrtype;//用户类型
@property (nonatomic ,copy)NSString  *djs_bean;//代缴税
@property (nonatomic ,copy)NSString  *idcard;//身份证
@property (nonatomic ,copy)NSString  *truename;//真实姓名
@property (nonatomic ,copy)NSString  *tjr;//推荐人
@property (nonatomic ,copy)NSString  *tjrname;//推荐人姓名
@property (nonatomic ,copy)NSString  *AudiThrough;//判断商家是否通过审核
@property (nonatomic ,copy)NSString  *rzstatus;//是否认证，0没有认证，1申请认证，2审核通过，3失败
@property (nonatomic ,copy)NSString  *is_main;//是否是主店,0:主点  1:分店
@property (nonatomic ,copy)NSString  *main_id;//主店id
@property (nonatomic ,copy)NSString  *isSetTwoPwd;//是否设置了二级密码
@property (nonatomic ,copy)NSString  *meeple;//米宝
@property (nonatomic ,copy)NSString  *shop_name;//商家
@property (nonatomic ,copy)NSString  *shop_address;//商家地址
@property (nonatomic ,copy)NSString  *shop_type;//商家类型

@property (nonatomic ,copy)NSString  *back;//兑换消息1
@property (nonatomic ,copy)NSString  *bonus_log;//奖励消息2
@property (nonatomic ,copy)NSString  *log;//推荐消息3       
@property (nonatomic ,copy)NSString  *logtd;//团队消息7
@property (nonatomic ,copy)NSString  *order_line;//下单消息4
@property (nonatomic ,copy)NSString  *system_message;//其他消息6
@property (nonatomic ,copy)NSString  *give;//转赠消息5
@property (nonatomic ,copy)NSString  *pushLog;//推送消息8

//兑换比例
@property (nonatomic ,copy)NSString  *t_one;
@property (nonatomic ,copy)NSString  *t_two;
@property (nonatomic ,copy)NSString  *t_three;
//商家额度
@property (nonatomic ,copy)NSString  *single;//每单额度
@property (nonatomic ,copy)NSString  *surplusLimit;//剩余额度
@property (nonatomic ,copy)NSString  *allLimit;//总额度
@property (nonatomic ,copy)NSString  *isapplication;//判断是否正在申请额度 0 为没有申请 1 为正在申请
@property (nonatomic ,copy)NSString  *shop_phone;//商家展示给会员的电话号码
@property (nonatomic ,copy)NSString  *pre_phone;//客服电话号码
@property (nonatomic ,copy)NSString  *congig_ads;//公司名称
@property (nonatomic ,copy)NSString  *open_bank;//开户行
@property (nonatomic ,copy)NSString  *card_num;//账号
@property (nonatomic ,copy)NSString  *im_id;//聊天id
@property (nonatomic ,copy)NSString  *im_token;//聊天token
@property (nonatomic ,copy)NSString  *is_yx;//是否允许云信登录 1是 2否,

//自己加的
//@property (nonatomic ,copy)NSString  *defaultBanknumber;//默认银行卡号
@property (nonatomic ,copy)NSString  *defaultBankname;//默认银行名
@property (nonatomic ,copy)NSString  *defaultBankIcon;//默认银行图标

@property (nonatomic ,copy)NSString  *activation_mark;//活跃积分
@property (nonatomic ,copy)NSString  *frozen_mark;//冻结积分
@property (nonatomic ,copy)NSString  *line_money;//设置提单金额限制

@property (nonatomic ,copy)NSString  *meeple_model;//米宝是否开启  1是 0否
@property (nonatomic ,copy)NSString  *game_recharge_model;//游戏充值是否开启 1是

+(UserModel*)defaultUser;

@end
