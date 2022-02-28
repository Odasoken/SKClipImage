//
//  ViewController.m
//  SKClipImage
//
//  Created by mac on 2021/9/29.
//

#import "ViewController.h"
#import "SKClipImageController.h"
#import "SKClipImageHelper.h"
#import "SKCornerImageViewController.h"

@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showClipTool)];
    [_imageView addGestureRecognizer:tap];
    
    UIImage *img = [UIImage imageNamed:@"12333.jpeg"];
//    UIImage *img2 = [UIImage imageWithCGImage:img.CGImage scale:img.scale orientation:(UIImageOrientationUpMirrored)];
//    img2 = [SKClipImageHelper createImage:img2 degrees:90];
    _imageView.image = img;
    
//    NSData *imgData = UIImagePNGRepresentation(img);
////    if (imgData) {
////        [imgData writeToFile:@"/Users/mac/desktop/hello1" atomically:YES];
////    }
//    UIImage *roundImg = [SKClipImageHelper roundImage:img cornerRadius:50];
//    UIImageWriteToSavedPhotosAlbum(roundImg, nil, nil, nil);
    

    
}
-(void)showClipTool
{
    SKClipImageController *clipVC = [[SKClipImageController alloc] init];
    clipVC.originImage = self.imageView.image;
    __weak typeof(self) weakSelf = self;
    clipVC.clipCompletion = ^(UIImage * _Nonnull clipImg) {
        weakSelf.imageView.image = clipImg;
    };
    clipVC.imageName = @"SKClipImage";
    clipVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:clipVC animated:true completion:nil];
}
- (IBAction)touchSelectImage {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.delegate = self;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;

    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)touchSaveBtn:(UIButton *)sender {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"Save current image?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveImage:self.imageView.image];
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:okAction];
    [self  presentViewController:alertVC animated:YES completion:nil];
    
}
-(void)saveImage:(UIImage *)image{
    if (!image) {
        return;
    }
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [self showTipsLabel:NO message:nil];
    }else
    {
        [self showTipsLabel:YES message:nil];
    }
//    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}
-(void)showTipsLabel:(BOOL)isSuccess message:(NSString *)msg
{
    if (!msg.length) {
        msg = isSuccess ? @"Success" : @"Fail";
    }
    _tipsLabel.text = msg;
    _tipsLabel.alpha = 0.0;
    [UIView animateWithDuration:0.25 animations:^{
        self.tipsLabel.alpha = 1.0;
    } completion:^(BOOL finished) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                self.tipsLabel.alpha = 0.0;
            } completion:nil];
        });
        
    }];
}

#pragma mark - imagePickerController delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
   UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
    
//    UIImage *img2 = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:(UIImageOrientationDownMirrored)];
////    img2 = [SKClipImageHelper createImage:img2 degrees:90];
//    _imageView.image = img2;
}
- (IBAction)showCornerTool:(UIButton *)sender {
    SKCornerImageViewController *toolVC = [[SKCornerImageViewController alloc] init];
    toolVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:toolVC animated:true completion:nil];
}
- (IBAction)touchMirroredBtn:(UIButton *)sender {
    UIImage *image =   self.imageView.image;
    if (!image) {
        [self showTipsLabel:YES message:@"Empty Image!"];
        return;
    }
    UIImage *img2 = [SKClipImageHelper mirroredImage:image];
    
    
  ////    img2 = [SKClipImageHelper createImage:img2 degrees:90];
    if (img2) {
        _imageView.image = img2;
    }else
    {
        [self showTipsLabel:YES message:@"No mirrored Image found!"];
    }
  //
}

@end
