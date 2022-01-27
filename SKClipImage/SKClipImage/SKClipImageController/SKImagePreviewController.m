//
//  SKImagePreviewController.m
//  SKClipImage
//
//  Created by mac on 2022/1/25.
//

#import "SKImagePreviewController.h"
#import "SKClipImageHelper.h"
#define kw(R)   (R) * (kScreenWidth) / 375.0
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


@interface SKImagePreviewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic,assign)  CGFloat scrollViewH;
@property (nonatomic,strong)  UIImage *originImage;
@property (nonatomic,strong)  UIImageView *originImageView;
@end

@implementation SKImagePreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _originImage = self.previewImage;
    [self setupUI];
}

-(void)setupUI{
    
    BOOL isX = [SKClipImageHelper isIPhoneX:self.view];
    CGFloat navH = isX ? 88 : 64;
    
    // 底部视图
    CGFloat bottomHeight = kw(60) + (isX ? 34 : 0);
    CGFloat scrollViewH =  kScreenHeight - navH;
    _scrollViewH = scrollViewH;
    self.scrollView.frame = CGRectMake(0, navH, kScreenWidth, kScreenHeight - navH);
    [self.view addSubview:self.scrollView];
    
    CGFloat coverWH = kScreenWidth - kw(28); // 白色剪切框的宽高
    CGFloat imgW = coverWH;
    CGFloat imgH = coverWH;
    UIImage *currentImage =  self.originImage;
    CGFloat imgPiexH = currentImage.size.height;
    CGFloat imgPiexW = currentImage.size.width;
    if (self.originImage.size.width > self.originImage.size.height)
    {
        imgW = imgH * self.originImage.size.width/self.originImage.size.height;
    }else
    {
        imgH = imgW * self.originImage.size.height/self.originImage.size.width;
    }
    

    if (imgW > coverWH) {
        imgW = coverWH;
        imgH = imgW * imgPiexH / imgPiexW;
    }
    
    if (imgH > _scrollViewH) {
        imgH = _scrollViewH;
        imgW = imgH * imgPiexW/imgPiexH;
    }
    // 根据图片大小, 加上左右, 上下边距, 设置 contentSize

    

    self.originImageView.frame = CGRectMake(0, 0, imgW, imgH);
    self.originImageView.center = CGPointMake(self.scrollView.frame.size.width/2, self.scrollView.frame.size.height/2);
    [self.scrollView addSubview:self.originImageView];

    
    // 移动图片到裁切框的中间
    self.scrollView.contentOffset = CGPointMake((self.scrollView.contentSize.width-self.scrollView.frame.size.width)/2, (self.scrollView.contentSize.height-self.scrollView.frame.size.height)/2);
    if (!self.navigationController) {
        UIButton*dismissBtn =  [[UIButton alloc] init];
        [dismissBtn setTitle:@"Hide" forState:(UIControlStateNormal)];
        [dismissBtn setTitleColor:[UIColor systemGreenColor] forState:UIControlStateNormal];
        [dismissBtn addTarget:self action:@selector(touchDismissBtn) forControlEvents:UIControlEventTouchUpInside];
        dismissBtn.frame = CGRectMake(10, navH , 60, 44);
        [self.view addSubview:dismissBtn];
    }
  
}
-(void)touchDismissBtn
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (UIImageView *)originImageView{
    
    if (!_originImageView) {
        
        _originImageView = [[UIImageView alloc] init];
        _originImageView.contentMode = UIViewContentModeScaleAspectFill;
        _originImageView.image = self.originImage;
    }
    return _originImageView;
}

- (UIScrollView *)scrollView{
    
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.maximumZoomScale = 2.0;
        _scrollView.delegate = self;
    }
    return _scrollView;
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat upDownSpace = self.scrollView.frame.size.height - (kScreenWidth - kw(28));
    self.scrollView.contentSize = CGSizeMake(self.originImageView.frame.size.width + kw(28), self.originImageView.frame.size.height + upDownSpace);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return self.originImageView;
}
@end
