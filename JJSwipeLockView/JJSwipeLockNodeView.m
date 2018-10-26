//
//  JJSwipeLockNodeView.m
//  JJSwipeLockViewDemo
//
//  Created by xujun on 16/9/1.
//  Copyright © 2016年 xujun. All rights reserved.
//
#import "JJSwipeLockNodeView.h"
#import "JJSwipeLockView.h"
@interface JJSwipeLockNodeView()
@property (nonatomic, strong) CAShapeLayer *outlineLayer;
@property (nonatomic, strong) CAShapeLayer *innerCircleLayer;
@end


@implementation JJSwipeLockNodeView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer addSublayer:self.outlineLayer];
        [self.layer addSublayer:self.innerCircleLayer];
        self.nodeViewStatus = JJSwipeLockStateNormal;
    }
    return self;
}

- (void)pan:(UIPanGestureRecognizer *)rec
{
//    CGPoint point = [rec locationInView:self];
    self.nodeViewStatus = JJSwipeLockStateSelected;
}

- (void)setNodeViewStatus:(JJSwipeLockState)nodeViewStatus
{
    _nodeViewStatus = nodeViewStatus;
    switch (_nodeViewStatus) {
        case JJSwipeLockStateNormal:
            [self setStatusToNormal];
            break;
        case JJSwipeLockStateSelected:
            [self setStatusToSelected];
            break;
        case JJSwipeLockStateWarning:
            [self setStatusToWarning];
            break;
        default:
            break;
    }
}

- (void)setNodeColor:(UIColor *)nodeColor
{
    _nodeColor = nodeColor;
    self.nodeViewStatus = _nodeViewStatus;
}

- (void)setNodeSelectedColor:(UIColor *)nodeSelectedColor
{
    _nodeSelectedColor = nodeSelectedColor;
    self.nodeViewStatus = _nodeViewStatus;
}

- (void)setNodeWarningColor:(UIColor *)nodeWarningColor
{
    _nodeWarningColor = nodeWarningColor;
    self.nodeViewStatus = _nodeViewStatus;
}

- (void)setInnerCircleScale:(CGFloat)innerCircleScale
{
    _innerCircleScale = innerCircleScale;
    [self setNeedsLayout];
}

- (void)setStatusToNormal
{
    self.outlineLayer.lineWidth = 1;
    self.outlineLayer.strokeColor = _nodeColor.CGColor;
    self.innerCircleLayer.lineWidth = 1;
    self.innerCircleLayer.fillColor = [UIColor clearColor].CGColor;
}

- (void)setStatusToSelected
{
    self.outlineLayer.lineWidth = 1;
    self.outlineLayer.strokeColor = _nodeSelectedColor.CGColor;
    self.innerCircleLayer.lineWidth = 1;
    self.innerCircleLayer.fillColor = _nodeSelectedColor.CGColor;
}

- (void)setStatusToWarning
{
    self.outlineLayer.lineWidth = 1 ;
    self.outlineLayer.strokeColor = _nodeWarningColor.CGColor;
    self.innerCircleLayer.lineWidth = 1;
    self.innerCircleLayer.fillColor = _nodeWarningColor.CGColor;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.outlineLayer.frame = self.bounds;
    UIBezierPath *outlinePath = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    self.outlineLayer.path = outlinePath.CGPath;
    
    CGRect frame = self.bounds;
    CGFloat width = _innerCircleScale > 0 ? (frame.size.width*(1-MIN(_innerCircleScale, 1))) : frame.size.width / 3;
    self.innerCircleLayer.frame = CGRectInset(frame, width, width);
    UIBezierPath *innerPath = [UIBezierPath bezierPathWithOvalInRect:self.innerCircleLayer.bounds];
    self.innerCircleLayer.path = innerPath.CGPath;

}

- (CAShapeLayer *)outlineLayer
{
    if (_outlineLayer == nil) {
        _outlineLayer = [[CAShapeLayer alloc] init];
        _outlineLayer.strokeColor = self.nodeColor.CGColor;
        _outlineLayer.lineWidth = 1.0f;
        _outlineLayer.fillColor  = [UIColor clearColor].CGColor;
    }
    return _outlineLayer;
}

- (CAShapeLayer *)innerCircleLayer
{
    if (_innerCircleLayer == nil) {
        _innerCircleLayer = [[CAShapeLayer alloc] init];
        _innerCircleLayer.strokeColor = [UIColor clearColor].CGColor;
        _innerCircleLayer.lineWidth = 1.0f;
        _innerCircleLayer.fillColor  = self.nodeColor.CGColor;
    }
    return _innerCircleLayer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
