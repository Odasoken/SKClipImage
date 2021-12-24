//
//  SKImageHelper.h
//  SKClipImage
//
//  Created by mac on 2021/12/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface SKClipImageHelper : NSObject
+(UIImage *)createImage:(UIImage *)originImg degrees:(float)degrees;
+ (CGImageRef)createRotatedImage:(CGImageRef)original degrees:(float)degrees;
@end


