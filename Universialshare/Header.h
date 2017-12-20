//
//  Header.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

#define timea 0.3f
#define YYSRGBColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define TABBARTITLE_COLOR YYSRGBColor(255, 155, 33 , 1.0) //导航栏颜色
#define autoSizeScaleX (SCREEN_WIDTH/320.f)
#define autoSizeScaleY (SCREEN_HEIGHT/568.f)

#define ADAPT(x) SCREEN_WIDTH / 375 *(x)

//#define URL_Base @"https://www.51dztg.com/index.php/App/"
#define URL_Base @"http://dzgx.joshuaweb.cn/index.php/App/"
//#define URL_Base @"http://192.168.0.131/dztg/index.php/App/"
//下载地址
#define DOWNLOAD_URL @"https://itunes.apple.com/cn/app/id1228047806?mt=8"
//获取appStore上的最新版本号地址
#define GET_VERSION  @"https://itunes.apple.com/lookup?id=1228047806"
//关于我们网址
#define ABOUTUS_URL @"https://www.51dztg.com/hyjm/hyjm.html"
//公告
#define NOTICE_URL @"http://gg.51dztg.com"
//注册协议
#define REGISTER_URL @"http://www.51dztg.com/index.php/Home/Regist/protocol.html"
//推荐扫码注册
#define RECOMMEND_REGISTER_URL @"http://www.51dztg.com/index.php/Home/Regist/index.html?username="
//常见问题
#define COMMONPROBLE @"https://www.51dztg.com/index.php/Home/Index/question.html"


#define OrdinaryUser @"10"//会员
#define Retailer @"9"//商家
#define ONESALER @"13"//大区创客
#define TWOSALER @"7"//城市创客
#define THREESALER @"8"//创客
#define PROVINCE @"1" //省级服务中心
#define CITY @"2"//市级服务中心
#define DISTRICT @"3"//区级服务中心
#define PROVINCE_INDUSTRY @"4"//省级行业服务中心
#define CITY_INDUSTRY @"5"//市级行业服务中心

#define PlaceHolderImage @"planceholder"
#define LUNBO_PlaceHolder @"轮播暂位图"
#define MERCHAT_PlaceHolder @"商户暂位图"

//http://dzgx.joshuaweb.cn/index.php/Home/Regist/index.html
//分享
#define SHARE_URL @"https://www.51dztg.com/index.php/Home/Regist/index.html"
#define UMSHARE_APPKEY @"58cf31dcf29d982906001f63"
//微信分享
#define WEIXI_APPKEY @"wx8ab86093bc51867d"
#define WEIXI_SECRET @"sag94FjbjrBHN5m6l3bGYjqZJrZDrE6u"
//微博分享
#define WEIBO_APPKEY @"2203958313"
#define WEIBO_SECRET @"9a911777f4b18555cd2b42a9bc186389"
//#define WEIBO_APPKEY @"688497271"
//#define WEIBO_SECRET @"5d4df0f912e9af331adaf718a357176f"
//虚拟货币名称
#define NormalMoney @"米子"
#define SpecialMoney @"推荐米子"
//公钥RSA
#define public_RSA @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDDF4IeiOMGVERr/4oTZWuthQx+eesKBx70SH5xPavN8s07rFbPf3VQ8yhqsX2TuBhsVz5PDjFyn3NgfJPXr5uVCSu3nONGttK3pnYsIlkHLOQAq3uDl3UwvuDnz6j7Urjxkkonh011o8FZ5pGMSSmGkMVyJ8RVTUIKgcQhNk4VXwIDAQAB"

#define NMUBERS @"0123456789./*-+~!@#$%^&()_+-=,./;'[]{}:<>?`"

#define KCURRENTCITYINFODEFAULTS [NSUserDefaults standardUserDefaults]

/**
 * 物流地址
 */

#define logisticsUrl @"http://jisukdcx.market.alicloudapi.com/express/query"

//3%奖励的宏
#define KThreePersent @"4"

//支付宝appid
#define AlipayAPPID @"2017060207408516"
//captchaid的值是每个产品从后台生成的,
#define CAPTCHAID @"e81c8a046b5e4d08999ef30e01999e35"

/**
 *常见问题汇总地址
 */

#define ordinaryURL @"https://www.51dztg.com/index.php/Home/Index/question/differ/ordinary.html"
#define financeURL @"https://www.51dztg.com/index.php/Home/Index/question/differ/finance.html"
#define technicalURL @"https://www.51dztg.com/index.php/Home/Index/question/differ/technology.html"

/**
 *app_version  app版本 ，为了区分之前的版本，保证之前接口
 */

#define APP_VERSION  @"3.2.0"

#endif /* Header_h */
