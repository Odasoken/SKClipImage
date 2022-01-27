//
//  SKCornerImageViewController.m
//  SKClipImage
//
//  Created by mac on 2022/1/25.
//

#import "SKCornerImageViewController.h"
#import "SKClipImageHelper.h"
#import "SKImagePreviewController.h"

@interface SKCornerImageViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UITextField *textfield;
@property (nonatomic,strong)  UIImage *originImg;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (nonatomic,strong)   UITapGestureRecognizer *tapGest;
@end

@implementation SKCornerImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _imageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGest =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(previewImage)];
    [_imageView addGestureRecognizer:tapGest];
    _tapGest = tapGest;
    
    
    [self updateCornerView:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - action

- (IBAction)dismiss:(id)sender {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (IBAction)selectImage:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.delegate = self;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;

    [self presentViewController:picker animated:YES completion:nil];
}
- (IBAction)updateCornerView:(UIButton *)sender {
    if (self.originImg == nil) {
        self.originImg = self.imageView.image;
        [self updateImageSizeTips];
    }
    CGFloat radius = self.textfield.text.floatValue;
    if (radius < 0.0) {
        radius = 0.0;
    }
  UIImage *img =   [SKClipImageHelper roundImage: self.originImg cornerRadius:radius];
    self.imageView.image = img;
}
-(void)updateImageSizeTips
{
    CGFloat imgW = 0.0;
    CGFloat imgH = 0.0;
    imgW = self.originImg.size.width;
    imgH = self.originImg.size.height;
    self.sizeLabel.text = [NSString stringWithFormat:@"Current image Size:  %0.1lf X %0.1lf",imgW,imgH];
    
}
- (IBAction)touchSaveBtn:(UIButton *)sender {
    UIImage *image = self.imageView.image;
    NSData *imgData =  UIImagePNGRepresentation(image);
    UIImage *pngImg = [[UIImage alloc] initWithData:imgData];
   
    [self saveImage:pngImg];
}

-(void)saveImage:(UIImage *)image{
    if (!image) {
        [self showMessage:@"empty image!" isSuccess:NO];
        return;
    }
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [self showMessage:[NSString stringWithFormat:@"Save failed:%@",error.localizedDescription] isSuccess:NO];
    }else
    {
        [self showMessage:@"Save sucess" isSuccess:YES];
    }
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}
-(void)showMessage:(NSString *)msg isSuccess:(BOOL)isSuccess
{
    _tipsLabel.text = msg;
    _tipsLabel.textColor = isSuccess?[UIColor greenColor]:[UIColor redColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tipsLabel.text = @"";
    });
}
-(void)previewImage{
    if (self.imageView.image) {
        SKImagePreviewController*previewVC = [[SKImagePreviewController alloc] init];
        previewVC.previewImage = self.imageView.image;
        previewVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:previewVC animated:true completion:nil];
    }
    
}
#pragma mark - imagePickerController delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
   UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.originImg = image;
    [self updateImageSizeTips];
    [self updateCornerView:nil];
}
@end
