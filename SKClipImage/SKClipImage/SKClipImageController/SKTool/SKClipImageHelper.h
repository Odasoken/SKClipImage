//
//  SKImageHelper.h
//  SKClipImage
//
//  Created by mac on 2021/12/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define SKKLocalizedString(aText) [SKClipImageHelper sk_localizedStringForKey:aText]


@interface SKClipImageHelper : NSObject

+(UIImage *)createImage:(UIImage *)originImg degrees:(float)degrees;
+ (UIImage *)rotateImage:(UIImage *)image indegree:(CGFloat)indegree ;
+ (UIImage *)rotateImage:(UIImage *)image rotation:(UIImageOrientation)orientation;
+ (UIImage *)mirroredImage:(UIImage *)image;
+ (CGImageRef)createRotatedImage:(CGImageRef)original degrees:(float)degrees;
+ (NSString *)sk_localizedStringForKey:(NSString *)key;
+(UIImage *)roundImage:(UIImage *)originImg cornerRadius:(CGFloat)radius;
+(UIImage *)transparerntImage:(UIImage *)originImg;
+ (BOOL)isIPhoneX :(UIView *)currentView;
//+( UIImage *)rotateImage:(UIImage *)oldImage;

@end


