//
//  UIView+Extend.h
//  PGJOA
//
//  Created by QzydeMac on 16/9/5.
//  Copyright © 2016年 Qzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YKTExtend)

@property (nonatomic,assign) CGFloat ykt_width;
@property (nonatomic,assign) CGFloat ykt_height;
@property (nonatomic,assign,readonly) CGFloat ykt_maxY;
@property (nonatomic,assign,readonly) CGFloat ykt_minY;
@property (nonatomic,assign,readonly) CGFloat ykt_maxX;
@property (nonatomic,assign,readonly) CGFloat ykt_minX;
@property (nonatomic,assign) CGFloat ykt_centerY;
@property (nonatomic,assign) CGFloat ykt_centerX;
@property (nonatomic,assign) CGFloat ykt_x;
@property (nonatomic,assign) CGFloat ykt_y;
@property (nonatomic,assign) CGSize ykt_size;


@end
