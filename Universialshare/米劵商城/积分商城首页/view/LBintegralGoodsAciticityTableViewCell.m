//
//  LBintegralGoodsAciticityTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/19.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBintegralGoodsAciticityTableViewCell.h"
#import "FLAnimatedImage.h"


@interface LBintegralGoodsAciticityTableViewCell ()<SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *baseview;
@property (strong, nonatomic)NSMutableArray *imagearr;

@property (nonatomic, strong) FLAnimatedImageView *imageView1;

@end


@implementation LBintegralGoodsAciticityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //[self.baseview addSubview:self.cycleScrollView];
    [self addSubview:self.imageView1];
}

-(void)loadimage:(NSString *)imageurl isGif:(NSString *)gifstr{

    if ([gifstr integerValue]==1) {
       self.imageView1.frame = CGRectMake(0.0, 0, SCREEN_WIDTH, self.size.height);
        self.imageone.hidden = YES;
        self.imageView1.hidden = NO;
        NSURL *url2 = [NSURL URLWithString:imageurl];
        [self loadAnimatedImageWithURL:url2 completion:^(FLAnimatedImage *animatedImage) {
            self.imageView1.animatedImage = animatedImage;

        }];

    }else{

        self.imageone.hidden = NO;
         self.imageView1.hidden = YES;
        [self.imageone sd_setImageWithURL:[NSURL URLWithString:imageurl]];
    }
    
}

-(SDCycleScrollView*)cycleScrollView{
    
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80 * autoSizeScaleX)
                                                              delegate:self
                                                      placeholderImage:[UIImage imageNamed:LUNBO_PlaceHolder]];//当一张都没有的时候的 占位图
        //每一张图的占位图
        _cycleScrollView.placeholderImage = [UIImage imageNamed:LUNBO_PlaceHolder];
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.autoScrollTimeInterval = 2;// 自动滚动时间间隔
        _cycleScrollView.showPageControl = NO;
        _cycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];// 图片对应的标题的 背景色。（因为没有设标题）
        _cycleScrollView.localizationImageNamesGroup = self.imagearr;
        
    }
    
    return _cycleScrollView;
    
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
  
    
}

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
    
}
- (void)loadAnimatedImageWithURL:(NSURL *const)url completion:(void (^)(FLAnimatedImage *animatedImage))completion
{
    NSString *const filename = url.lastPathComponent;
    NSString *const diskPath = [NSHomeDirectory() stringByAppendingPathComponent:filename];
    
    NSData * __block animatedImageData = [[NSFileManager defaultManager] contentsAtPath:diskPath];
    FLAnimatedImage * __block animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:animatedImageData];
    
    if (animatedImage) {
        if (completion) {
            completion(animatedImage);
        }
    } else {
        [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            animatedImageData = data;
            animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:animatedImageData];
            if (animatedImage) {
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(animatedImage);
                    });
                }
                [data writeToFile:diskPath atomically:YES];
            }
        }] resume];
    }
}


-(NSMutableArray*)imagearr{
    
    if (!_imagearr) {
        _imagearr = [NSMutableArray array];
    }
    
    return _imagearr;
    
}

-(FLAnimatedImageView*)imageView1{

    if (!_imageView1) {
        _imageView1 = [[FLAnimatedImageView alloc] init];
        _imageView1.contentMode = UIViewContentModeScaleAspectFill;
        _imageView1.clipsToBounds = YES;
    }
    
    return _imageView1;

}

@end
