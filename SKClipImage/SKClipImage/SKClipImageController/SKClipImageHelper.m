//
//  SKImageHelper.m
//  SKClipImage
//
//  Created by mac on 2021/12/24.
//

#import "SKClipImageHelper.h"

@implementation SKClipImageHelper

+(UIImage *)roundImage:(UIImage *)originImg cornerRadius:(CGFloat)radius {
    if (!originImg) {
        return nil;
    }
    CGRect rect = CGRectMake(0, 0, originImg.size.width, originImg.size.height);
    //(CGRect){0.f, 0.f, originImg.size};
//    [[UIColor clearColor] set];
    UIGraphicsBeginImageContextWithOptions(originImg.size, NO, UIScreen.mainScreen.scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(),
    [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    [originImg drawInRect:rect];
   
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}




+(UIImage *)createImage:(UIImage *)originImg degrees:(float)degrees
{
    if (originImg == nil || degrees == 0.0f) {
        return originImg;
    }
    CGImageRef oriImgRef = originImg.CGImage;
    CGImageRef rotatedImgRef = [self createRotatedImage:oriImgRef degrees:degrees];
    
    UIImage *rotatedImage =  [[UIImage alloc] initWithCGImage:rotatedImgRef];
    return rotatedImage;
}
// 图片旋转
+ (CGImageRef )createRotatedImage:(CGImageRef)original degrees:(float)degrees {
    if (degrees == 0.0f) {
        CGImageRetain(original);
        return original;
    } else {
        double radians = degrees * M_PI / 180;
        
#if TARGET_OS_EMBEDDED || TARGET_IPHONE_SIMULATOR
        radians = -1*radians;
#endif
        
        size_t _width = CGImageGetWidth(original);
        size_t _height = CGImageGetHeight(original);
        
        CGRect imgRect = CGRectMake(0, 0, _width, _height);
        CGAffineTransform __transform = CGAffineTransformMakeRotation(radians);
        CGRect rotatedRect = CGRectApplyAffineTransform(imgRect, __transform);
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(NULL,
                                                     rotatedRect.size.width,
                                                     rotatedRect.size.height,
                                                     CGImageGetBitsPerComponent(original),
                                                     0,
                                                     colorSpace,
                                                     kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedFirst);
        CGContextSetAllowsAntialiasing(context, FALSE);
        CGContextSetInterpolationQuality(context, kCGInterpolationNone);
        CGColorSpaceRelease(colorSpace);
        
        CGContextTranslateCTM(context,
                              +(rotatedRect.size.width/2),
                              +(rotatedRect.size.height/2));
        CGContextRotateCTM(context, radians);
        
        CGContextDrawImage(context, CGRectMake(-imgRect.size.width/2,
                                               -imgRect.size.height/2,
                                               imgRect.size.width,
                                               imgRect.size.height),
                           original);
        
        CGImageRef rotatedImage = CGBitmapContextCreateImage(context);
        CFRelease(context);
        
        return rotatedImage;
    }
}

+ (NSString *)sk_localizedStringForKey:(NSString *)key
{
    return [self sk_localizedStringForKey:key value:nil];
}

+ (NSString *)sk_localizedStringForKey:(NSString *)key value:(NSString *)value
{
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        NSString *language = [NSLocale preferredLanguages].firstObject;
        if ([language hasPrefix:@"en"]) {
            language = @"en";
        } else if ([language hasPrefix:@"zh"]) {
            if ([language rangeOfString:@"Hans"].location != NSNotFound) {
                language = @"zh-Hans"; // 简体中文
            } else { // zh-Hant\zh-HK\zh-TW
                language = @"zh-Hant"; // 繁體中文
            }
        } else {
            language = @"en";
        }
        
        // 从MJRefresh.bundle中查找资源
        bundle = [NSBundle bundleWithPath:[[self sk_clipImageBundle] pathForResource:language ofType:@"lproj"]];
    }
    value = [bundle localizedStringForKey:key value:value table:nil];
    return [[NSBundle mainBundle] localizedStringForKey:key value:value table:nil];
}
+ (NSBundle *)sk_clipImageBundle
{
    static NSBundle *refreshBundle = nil;
    if (refreshBundle == nil) {
       
        refreshBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"SKClipImage" ofType:@"bundle"]];
    }
    return refreshBundle;
}
+ (BOOL)isIPhoneX :(UIView *)currentView{
    
    // 根据安全区域判断
    if (@available(iOS 11.0, *)){
        UIWindow *window =  [UIApplication sharedApplication].windows.firstObject;
        if (window.safeAreaInsets.bottom > 0.0) {
            return YES;
        }
        return currentView.safeAreaInsets.bottom > 0.0;
    }
    return NO;
}
+(UIImage *)transparerntImage:(UIImage *)originImg
{
//    return [self maskImage:originImg];
    CGImageRef rawImageRef = originImg.CGImage;
     UIGraphicsBeginImageContext ( originImg .size);
    CGFloat components[] = {222, 255, 222, 255, 222, 255};
    CGImageRef  maskedImageRef = CGImageCreateWithMaskingColors(rawImageRef, components);
    CGContextRef  context = UIGraphicsGetCurrentContext ();
    CGContextTranslateCTM(context, 0, originImg .size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGRectMake(0, 0, originImg .size.width, originImg .size.height), maskedImageRef);

    UIImage *result =  UIGraphicsGetImageFromCurrentImageContext ();
    UIGraphicsEndImageContext ();
    return  result;
}

+ (UIImage *)maskImage:(UIImage *)image
{
//    const float colorMasking[6] = {219.0, 255.0, 219.0, 255.0, 219.0, 255.0};
        const CGFloat colorMasking[6] = {250.0, 255.0, 250.0, 255.0, 250.0, 255.0};
    CGImageRef sourceImage = image.CGImage;
    
    CGImageAlphaInfo info = CGImageGetAlphaInfo(sourceImage);
    if (info != kCGImageAlphaNone) {
        NSData *buffer = UIImageJPEGRepresentation(image, 1);
        UIImage *newImage = [UIImage imageWithData:buffer];
        sourceImage = newImage.CGImage;
    }

    CGImageRef masked = CGImageCreateWithMaskingColors(sourceImage, colorMasking);
    UIImage *retImage = [UIImage imageWithCGImage:masked];
    CGImageRelease(masked);
    return retImage;
}

@end
