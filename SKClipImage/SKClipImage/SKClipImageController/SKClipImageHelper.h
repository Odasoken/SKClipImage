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
+ (CGImageRef)createRotatedImage:(CGImageRef)original degrees:(float)degrees;
+ (NSString *)sk_localizedStringForKey:(NSString *)key;

@end


