//
//  PTCutImageViewController.h
//  PTCutImage
//
//  Created by mac on 2020/5/29.
//  Copyright © 2020 MB. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface SKClipImageController : UIViewController

/// 传入要裁切的图片
@property (nonatomic, strong) UIImage *originImage;
@property (nonatomic,copy)  NSString *imageName;

/// 裁切完成的图片
@property (nonatomic, copy) void (^clipCompletion)(UIImage *clipImg);

@end


