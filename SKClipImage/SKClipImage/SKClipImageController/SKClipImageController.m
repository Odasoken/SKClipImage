//
//  PTCutImageViewController.m
//  PTCutImage
//
//  Created by mac on 2020/5/29.
//  Copyright © 2020 MB. All rights reserved.
//

#import "SKClipImageController.h"
#import "UIView+Extend.h"
#import "Masonry.h"
#import "SKImageClipBorderView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kw(R)   (R) * (kScreenWidth) / 375.0

#define HEXCOLOR(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]

#define KAppRedColor_FF6A6A HEXCOLOR(0xFF6A6A)


@interface SKClipImageController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *originImageView;
@property (nonatomic, strong) UIImageView *coverImgView;
@property (nonatomic,strong)  SKImageClipBorderView *clipView;

@end

@implementation SKClipImageController


- (void)viewDidLoad {
    [super viewDidLoad];    
    
    self.view.backgroundColor = [UIColor blackColor];

    [self bulidUI];
}

- (void)bulidUI{
    
    BOOL isX = [self isIPhoneX];
    CGFloat navH = isX ? 88 : 64;
    
    // 底部视图
    CGFloat bottomHeight = kw(60) + (isX ? 34 : 0);
    UIView *bottomView = [self bulidBottomViewWithFrame:CGRectMake(0, kScreenHeight - bottomHeight, kScreenWidth, bottomHeight)];
    [self.view addSubview:bottomView];
    
    
    
    // 大背景滑动视图, 承载图片
    self.scrollView.frame = CGRectMake(0, navH, kScreenWidth, kScreenHeight - navH - bottomView.height);
    [self.view addSubview:self.scrollView];
    _clipView =  [[SKImageClipBorderView alloc] initWithFrame:self.scrollView.frame];

    
    CGFloat coverWH = kScreenWidth - kw(28); // 白色剪切框的宽高
    CGFloat imgW = coverWH;
    CGFloat imgH = coverWH;
    if (self.originImage.size.width > self.originImage.size.height)
    {
        imgW = imgH * self.originImage.size.width/self.originImage.size.height;
    }else
    {
        imgH = imgW * self.originImage.size.height/self.originImage.size.width;
    }
    

    // 根据图片大小, 加上左右, 上下边距, 设置 contentSize
    CGFloat upDownSpace = self.scrollView.height - coverWH;
    self.scrollView.contentSize = CGSizeMake(imgW + kw(28), imgH + upDownSpace);

    
    // 等待裁切的图片
    self.originImageView.frame = CGRectMake(0, 0, imgW, imgH);
    self.originImageView.center = CGPointMake(self.scrollView.contentSize.width/2, self.scrollView.contentSize.height/2);
    [self.scrollView addSubview:self.originImageView];

    
    // 移动图片到裁切框的中间
    self.scrollView.contentOffset = CGPointMake((self.scrollView.contentSize.width-self.scrollView.width)/2, (self.scrollView.contentSize.height-self.scrollView.height)/2);
    
    
    // 白色裁切框
//    self.coverImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, coverWH + 4, coverWH + 4)];
//    self.coverImgView.image = [UIImage imageNamed:@"cut_icon"];
//    self.coverImgView.center = CGPointMake(self.scrollView.centerX, self.scrollView.centerY);
//    [self.view addSubview:self.coverImgView];
//    
//    
//    // 白色半透明蒙版
//    UIView *markView = [[UIView alloc] initWithFrame:self.scrollView.frame];
//    markView.userInteractionEnabled = NO;
//    markView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
//    [self.view addSubview:markView];
//    
//    CGRect rect = [self.coverImgView convertRect:self.coverImgView.bounds toView:markView];
//    rect = CGRectMake(CGRectGetMinX(rect) + 2, CGRectGetMinY(rect) + 2, CGRectGetWidth(rect) - 4, CGRectGetHeight(rect) - 4);
//    UIBezierPath *tempPath = [UIBezierPath bezierPathWithRect:rect];
//    UIBezierPath *markPath = [UIBezierPath bezierPathWithRect:markView.bounds];
//    [markPath appendPath:tempPath];
//    
//    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//    shapeLayer.path = markPath.CGPath;
//    shapeLayer.fillColor = [UIColor blackColor].CGColor;
//    shapeLayer.fillRule = kCAFillRuleEvenOdd;
//    markView.layer.mask = shapeLayer;
    
    [self.view addSubview:_clipView];
}

/// 底部视图
- (UIView *)bulidBottomViewWithFrame:(CGRect)frame{
    
    UIView *bgView = [[UIView alloc] initWithFrame:frame];

    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cancleButton];
    [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.mas_equalTo(bgView.mas_top).offset(kw(30));
        make.width.height.mas_equalTo(kw(60));
        make.left.mas_equalTo(0);
    }];
    
    
    UIButton *resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    resetButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [resetButton setTitle:@"还原" forState:UIControlStateNormal];
    [resetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [resetButton addTarget:self action:@selector(resteAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:resetButton];
    [resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.mas_equalTo(bgView.mas_top).offset(kw(30));
        make.width.height.mas_equalTo(kw(60));
        make.centerX.mas_equalTo(0);
    }];
    
    
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    finishButton.titleLabel.font = [UIFont systemFontOfSize:14];
    finishButton.layer.backgroundColor = KAppRedColor_FF6A6A.CGColor;
    finishButton.layer.cornerRadius = kw(15);
    [finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [finishButton addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:finishButton];
    [finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.mas_equalTo(bgView.mas_top).offset(kw(30));
        make.width.mas_equalTo(kw(60));
        make.height.mas_equalTo(kw(30));
        make.right.mas_equalTo(-kw(15));
    }];
    
    return bgView;
}

#pragma mark - methods
-(void)dismiss{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
/// 取消事件
- (void)cancleAction{
    
    [self dismiss];
}

/// 还原事件
- (void)resteAction{
    
    if (self.scrollView.zoomScale == 1)
    {
        [self.scrollView setContentOffset:CGPointMake((self.scrollView.contentSize.width - self.scrollView.width) / 2, (self.scrollView.contentSize.height - self.scrollView.height) / 2) animated:YES];
    }else
    {
        [UIView animateWithDuration:0.25 animations:^{
               self.scrollView.zoomScale = 1.0;
           }completion:^(BOOL finished) {
               [self.scrollView setContentOffset:CGPointMake((self.scrollView.contentSize.width - self.scrollView.width) / 2, (self.scrollView.contentSize.height - self.scrollView.height) / 2) animated:YES];
              
           }];
    }
}

/// 完成事件
- (void)finishAction{
    
    if (self.clipCompletion) {
        
        CGRect rect = [self.clipView.clipBoundsView convertRect:self.clipView.clipBoundsView.bounds toView:self.originImageView];
        UIImage *image = [self makeImageWithView:self.originImageView coverRect:rect];
        self.clipCompletion(image);
    }
    [self dismiss];
}

- (UIImage *)makeImageWithView:(UIView *)view coverRect:(CGRect)coverRect{
    
    /*
     下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。
     第三个参数就是屏幕密度了，关键就是第三个参数 [UIScreen mainScreen].scale。
     */
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // 按比例扩大剪切区域
    CGRect tempRect = CGRectMake(CGRectGetMinX(coverRect) * scale, CGRectGetMinY(coverRect) * scale, CGRectGetWidth(coverRect) * scale, CGRectGetHeight(coverRect) * scale );
    //将UIImage转换成CGImageRef
    CGImageRef sourceImageRef = [image CGImage];
    //按照给定的矩形区域进行剪裁
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, tempRect);
    //将CGImageRef转换成UIImage
    image = [UIImage imageWithCGImage:newImageRef];

    return image;
}








#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat upDownSpace = self.scrollView.height - (kScreenWidth - kw(28));
    self.scrollView.contentSize = CGSizeMake(self.originImageView.width + kw(28), self.originImageView.height + upDownSpace);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return self.originImageView;
}

#pragma mark - get/set

- (UIScrollView *)scrollView{
    
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.maximumZoomScale = 2.0;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIImageView *)originImageView{
    
    if (!_originImageView) {
        
        _originImageView = [[UIImageView alloc] init];
        _originImageView.contentMode = UIViewContentModeScaleAspectFill;
        _originImageView.image = self.originImage;
    }
    return _originImageView;
}

- (BOOL)isIPhoneX {
    
    // 根据安全区域判断
    if (@available(iOS 11.0, *)){
        return self.view.safeAreaInsets.bottom > 0.0;
    }
    return NO;
}



@end
