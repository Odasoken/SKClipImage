//
//  SKImageClipBorderView.m
//  PTCutImage
//
//  Created by mac on 2021/9/16.
//  Copyright © 2021 MB. All rights reserved.
//

#import "SKImageClipBorderView.h"

#define  clipBoundsWidth 40.0f
#define skclipBorderWidth 150.0f
@interface SKImageClipBorderView()<UIGestureRecognizerDelegate>
@property (nonatomic,strong)  UIView *topLeftV;
@property (nonatomic,strong)  UIView *topRightV;
@property (nonatomic,strong)  UIView *bottomLeftV;
@property (nonatomic,strong)  UIView *bottomRightV;
@property (nonatomic,strong)  UIView *clipView;

@property (nonatomic,assign)  CGRect preFrame;
@property (nonatomic,assign)  BOOL isfirst;
@end


@implementation SKImageClipBorderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _clipView =  [[UIView alloc] init];
        _clipView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
        [self addSubview:_clipView];
        
       
        
        
        
        UIColor *boundColor = [UIColor systemPinkColor];
        _topLeftV =  [[UIView alloc] init];
        [self addSubview:_topLeftV];
//        _topLeftV.backgroundColor = [UIColor redColor];
        CGFloat boundWidth =  20;
        UIBezierPath *boundPath = [UIBezierPath bezierPath];
        [boundPath moveToPoint:CGPointMake(0, 0)];
        [boundPath addLineToPoint:CGPointMake(boundWidth, 00)];
        [boundPath moveToPoint:CGPointMake(0, 0)];
        [boundPath addLineToPoint:CGPointMake(0, boundWidth)];
        CAShapeLayer *boundLayer = [self boundLayeWithPath:boundPath color:boundColor];
        
        [_topLeftV.layer addSublayer:boundLayer];
        
        
        
        UIPanGestureRecognizer *pan1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panTopLeft:)];
        [_topLeftV addGestureRecognizer:pan1];
        pan1.maximumNumberOfTouches = 1;
        
        _topRightV =  [[UIView alloc] init];
        [self addSubview:_topRightV];
//        _topRightV.backgroundColor = [UIColor greenColor];
        UIPanGestureRecognizer *pan2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panTopRight:)];
        
        [_topRightV addGestureRecognizer:pan2];
        UIBezierPath *boundPath2 = [UIBezierPath bezierPath];
        [boundPath2 moveToPoint:CGPointMake(clipBoundsWidth - boundWidth, 0)];
        [boundPath2 addLineToPoint:CGPointMake(clipBoundsWidth, 0)];
        [boundPath2 moveToPoint:CGPointMake(clipBoundsWidth, 0)];
        [boundPath2 addLineToPoint:CGPointMake(clipBoundsWidth, boundWidth)];
        CAShapeLayer *boundLayer2 = [self boundLayeWithPath:boundPath2 color:boundColor];
        
        [_topRightV.layer addSublayer:boundLayer2];
        
        
        
        
        
        _bottomLeftV =  [[UIView alloc] init];
        [self addSubview:_bottomLeftV];
//        _bottomLeftV.backgroundColor = [UIColor blueColor];
        UIPanGestureRecognizer *pan3 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panBottomLeft:)];
        [_bottomLeftV addGestureRecognizer:pan3];
        UIBezierPath *boundPath3 = [UIBezierPath bezierPath];
        [boundPath3 moveToPoint:CGPointMake(0, clipBoundsWidth - boundWidth)];
        [boundPath3 addLineToPoint:CGPointMake(0, clipBoundsWidth)];
        [boundPath3 moveToPoint:CGPointMake(0, clipBoundsWidth)];
        [boundPath3 addLineToPoint:CGPointMake(boundWidth, clipBoundsWidth )];
        CAShapeLayer *boundLayer3 = [self boundLayeWithPath:boundPath3 color:boundColor];
        
        [_bottomLeftV.layer addSublayer:boundLayer3];
        
        
        _bottomRightV =  [[UIView alloc] init];
        [self addSubview:_bottomRightV];
//        _bottomRightV.backgroundColor = [UIColor yellowColor];
        UIPanGestureRecognizer *pan4 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panBottomRight:)];
        [_bottomRightV addGestureRecognizer:pan4];
        UIBezierPath *boundPath4 = [UIBezierPath bezierPath];
        [boundPath4 moveToPoint:CGPointMake(clipBoundsWidth, clipBoundsWidth - boundWidth)];
        [boundPath4 addLineToPoint:CGPointMake(clipBoundsWidth, clipBoundsWidth)];
        [boundPath4 moveToPoint:CGPointMake(clipBoundsWidth, clipBoundsWidth)];
        [boundPath4 addLineToPoint:CGPointMake(clipBoundsWidth - boundWidth, clipBoundsWidth)];
        CAShapeLayer *boundLayer4 = [self boundLayeWithPath:boundPath4 color:boundColor];
        
        [_bottomRightV.layer addSublayer:boundLayer4];
        
        pan1.delegate = self;
        pan2.delegate = self;
        pan3.delegate = self;
        pan4.delegate = self;
     
        
    }
    return self;
}
-(CAShapeLayer *)boundLayeWithPath:(UIBezierPath *)path color:(UIColor *)color
{
    CAShapeLayer *boundLayer = [CAShapeLayer layer];
    boundLayer.lineWidth = 2.5;
    boundLayer.strokeColor = color.CGColor;
    boundLayer.path = path.CGPath;
    boundLayer.fillColor = color.CGColor;
    boundLayer.lineCap = kCALineCapRound;
    boundLayer.lineJoin = kCALineJoinBevel;
    return boundLayer;
}
-(UIView *)clipBoundsView
{
    return _clipView;
}
-(void)restore
{
    _isfirst = NO;
    [self setNeedsLayout];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat w = CGRectGetWidth(self.frame);
    CGFloat h = CGRectGetHeight(self.frame);
    if (!_isfirst) {
        _isfirst = YES;
        _clipView.frame = CGRectMake((w - skclipBorderWidth)* 0.5, (h - skclipBorderWidth)* 0.5, skclipBorderWidth, skclipBorderWidth);
        [self updateBtnFrame];
    }
   
    
    
}
-(void)updateBtnFrame
{
    _topLeftV.frame = CGRectMake(CGRectGetMinX(_clipView.frame), CGRectGetMinY(_clipView.frame), clipBoundsWidth, clipBoundsWidth);
    _topRightV.frame = CGRectMake(CGRectGetMaxX(_clipView.frame)-clipBoundsWidth, CGRectGetMinY(_clipView.frame), clipBoundsWidth, clipBoundsWidth);
    _bottomLeftV.frame = CGRectMake(CGRectGetMinX(_clipView.frame), CGRectGetMaxY(_clipView.frame)-clipBoundsWidth, clipBoundsWidth, clipBoundsWidth);
    _bottomRightV.frame = CGRectMake(CGRectGetMaxX(_clipView.frame)-clipBoundsWidth, CGRectGetMaxY(_clipView.frame)-clipBoundsWidth, clipBoundsWidth, clipBoundsWidth);
}


-(void)panTopLeft:(UIPanGestureRecognizer*)gst{
    self.preFrame = self.clipView.frame;
    CGPoint bpoint =  [gst locationInView:self];
    CGFloat x = bpoint.x;
    CGFloat y = bpoint.y;
    CGFloat w = CGRectGetMaxX(self.preFrame) - x;
    CGFloat h = CGRectGetMaxY(self.preFrame) - y;
    CGFloat minClipW = clipBoundsWidth *2+30;
    
    CGFloat maxX = self.frame.size.width;
    CGFloat maxY = self.frame.size.height;
    BOOL isInX = (x+w) <= maxX;
    BOOL isInY = (y+h) <= maxY;
    if (isInX && isInY && x>=0 && y >= 0 && w >= minClipW && h >= minClipW  ) {
        self.clipView.frame = CGRectMake(x, y, w, h);
        [self updateBtnFrame];
    }
   
   
}

-(void)panTopRight:(UIPanGestureRecognizer*)gst{
    self.preFrame = self.clipView.frame;
    CGPoint bpoint =  [gst locationInView:self];
    CGFloat x = CGRectGetMinX(self.preFrame);
    CGFloat y = bpoint.y;
    CGFloat w = bpoint.x - x;
    CGFloat h = CGRectGetMaxY(self.preFrame) - y;
    CGFloat minClipW = clipBoundsWidth *2+30;
    
    CGFloat maxX = self.frame.size.width;
    CGFloat maxY = self.frame.size.height;
    BOOL isInX = (x+w) <= maxX;
    BOOL isInY = (y+h) <= maxY;
    if (isInX && isInY && x>=0 && y >= 0 && w >= minClipW && h >= minClipW  ) {
        self.clipView.frame = CGRectMake(x, y, w, h);
        [self updateBtnFrame];
    }
   
   
}

-(void)panBottomLeft:(UIPanGestureRecognizer*)gst{
    self.preFrame = self.clipView.frame;
    CGPoint bpoint =  [gst locationInView:self];
    CGFloat x = bpoint.x;
    CGFloat y = CGRectGetMinY(self.preFrame);
    CGFloat w = CGRectGetMaxX(self.preFrame) - x;
    CGFloat h = bpoint.y - y;
    CGFloat minClipW = clipBoundsWidth *2+30;
    
    CGFloat maxX = self.frame.size.width;
    CGFloat maxY = self.frame.size.height;
    BOOL isInX = (x+w) <= maxX;
    BOOL isInY = (y+h) <= maxY;
    if (isInX && isInY && x>=0 && y >= 0 && w >= minClipW && h >= minClipW  ) {
        self.clipView.frame = CGRectMake(x, y, w, h);
        [self updateBtnFrame];
    }
   
    
}

-(void)panBottomRight:(UIPanGestureRecognizer*)gst{
    self.preFrame = self.clipView.frame;
    CGPoint bpoint =  [gst locationInView:self];
    CGFloat x = CGRectGetMinX(self.preFrame);;
    CGFloat y = CGRectGetMinY(self.preFrame);;
    CGFloat w = bpoint.x - x;
    CGFloat h = bpoint.y - y;
    CGFloat minClipW = clipBoundsWidth *2+30;
    
    CGFloat maxX = self.frame.size.width;
    CGFloat maxY = self.frame.size.height;
    BOOL isInX = (x+w) <= maxX;
    BOOL isInY = (y+h) <= maxY;
    if (isInX && isInY && x>=0 && y >= 0 && w >= minClipW && h >= minClipW  ) {
        self.clipView.frame = CGRectMake(x, y, w, h);
        [self updateBtnFrame];
    }
   
    
}

//-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = touches.anyObject;
//    [self updateClipWithToch:touch];
//}
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = touches.anyObject;
//    [self updateClipWithToch:touch];
//}
//-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    CGPoint point2  = [_topLeftV convertPoint:point toView:_topLeftV];
//    if (CGRectContainsPoint(_topLeftV.frame, point2)) {
//        return self;
//    }
//    NSLog(@"_clipView:%@",NSStringFromCGPoint(point2));
//    return nil;
//}
//-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
//{
//    if ([_topLeftV pointInside:point withEvent:event]) {
//        CGRectContainsPoint(_topLeftV.frame, <#CGPoint point#>)
//        return YES;
//    }
//
//    if ([_topRightV pointInside:point withEvent:event]) {
//        return YES;
//    }
//
//    if ([_bottomLeftV pointInside:point withEvent:event]) {
//        return YES;
//    }
//
//
//    if ([_bottomRightV pointInside:point withEvent:event]) {
//        return YES;
//    }
//
//
//    return NO;
//}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hitView = [super hitTest:point withEvent:event];

    if(hitView == self){
        return nil;

    }
    if (hitView == _clipView) {
        return nil;
    }

    return hitView;

}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
@end
