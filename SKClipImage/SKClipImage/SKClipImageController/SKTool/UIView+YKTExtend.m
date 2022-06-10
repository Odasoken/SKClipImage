//
//  UIView+Extend.m
//  PGJOA
//
//  Created by QzydeMac on 16/9/5.
//  Copyright © 2016年 Qzy. All rights reserved.
//

#import "UIView+YKTExtend.h"

@implementation UIView (Extend)

- (CGFloat)ykt_width
{
    return self.frame.size.width;
}

- (void)setYkt_width:(CGFloat)ykt_width
{
    CGRect frame = self.frame;
    frame.size.width = ykt_width;
    self.frame = frame;
}

- (CGFloat)ykt_height
{
    return self.frame.size.height;
}

- (void)setYkt_height:(CGFloat)ykt_height
{
    CGRect frame = self.frame;
    frame.size.height = ykt_height;
    self.frame = frame;
}

- (CGFloat)ykt_maxX
{
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)ykt_maxY
{
    return CGRectGetMaxY(self.frame);
}

-(CGFloat)ykt_minX
{
    return CGRectGetMinX(self.frame);
}

- (CGFloat)ykt_minY
{
    return CGRectGetMinY(self.frame);
}

- (void)setYkt_centerX:(CGFloat)ykt_centerX
{
    CGPoint center = self.center;
    center.x = ykt_centerX;
    self.center = center;
}

- (CGFloat)ykt_centerX
{
    return self.center.x;
}

- (void)setYkt_centerY:(CGFloat)ykt_centerY
{
    CGPoint center = self.center;
    center.y = ykt_centerY;
    self.center = center;
}

- (CGFloat)ykt_centerY
{
    return self.center.y;
}

- (void)setYkt_x:(CGFloat)ykt_x
{
    CGRect frame = self.frame;
    frame.origin.x = ykt_x;
    self.frame = frame;
}

- (CGFloat)ykt_x
{
    return self.frame.origin.x;
}

- (void)setYkt_y:(CGFloat)ykt_y
{
    CGRect frame = self.frame;
    frame.origin.y = ykt_y;
    self.frame = frame;
}

- (CGFloat)ykt_y
{
    return self.frame.origin.y;
}

- (void)setYkt_size:(CGSize)ykt_size
{
    CGRect frame = self.frame;
    frame.size = ykt_size;
    self.frame = frame;
}

- (CGSize)ykt_size
{
    return self.frame.size;
}

@end

