//
//  JJSwipeLockView.m
//  JJSwipeLockViewDemo
//
//  Created by xujun on 16/9/1.
//  Copyright © 2016年 xujun. All rights reserved.
//

#import "JJSwipeLockView.h"
#import "JJSwipeLockNodeView.h"

#define kUsePanGestureRecognizer 0


@interface JJSwipeLockView()
@property (nonatomic, strong) NSMutableArray<JJSwipeLockNodeView *> *nodeArray;
@property (nonatomic, strong) NSMutableArray<JJSwipeLockNodeView *> *selectedNodeArray;
@property (nonatomic, strong) CAShapeLayer *polygonalLineLayer;
@property (nonatomic, strong) UIBezierPath *polygonalLinePath;
@property (nonatomic, strong) NSMutableArray<NSValue *> *pointArray;

@property (nonatomic) JJSwipeLockState viewState;
///行数 默认3
@property (nonatomic, assign) NSUInteger colCount;

@end

@implementation JJSwipeLockView


- (void)initliazer
{
    [self.layer addSublayer:self.polygonalLineLayer];

    _colCount = 3;
    CGFloat count = self.colCount*self.colCount;
    _nodeArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 1; i <= count; ++i) {
        JJSwipeLockNodeView *nodeView = [JJSwipeLockNodeView new];
        [_nodeArray addObject:nodeView];
        nodeView.tag = i;
        [self addSubview:nodeView];
    }
    
    _selectedNodeArray = [NSMutableArray arrayWithCapacity:count];
    _pointArray = [NSMutableArray array];
    
    _showLine = YES;
    self.nodeColor = [UIColor colorWithRed:0 green:170/255.0 blue:1 alpha:1];
    self.nodeSelectedColor = [UIColor colorWithRed:0 green:170/255.0 blue:1 alpha:1];
    self.nodeWarningColor = [UIColor redColor];
    
#if kUsePanGestureRecognizer
    UIPanGestureRecognizer *panRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:panRec];
#endif
    self.viewState = JJSwipeLockStateNormal;
    [self cleanNodes];
    

//    [self setLockPassword:@"2#4#5"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initliazer];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initliazer];
    }
    return self;
}
#pragma mark - 设置项
- (void)setNodeColor:(UIColor *)nodeColor
{
    _nodeColor = nodeColor;
    [_nodeArray enumerateObjectsUsingBlock:^(JJSwipeLockNodeView *obj, NSUInteger idx, BOOL *stop) {
        obj.nodeColor = nodeColor;
    }];
}

- (void)setNodeSelectedColor:(UIColor *)nodeSelectedColor
{
    _nodeSelectedColor = nodeSelectedColor;
    [_nodeArray enumerateObjectsUsingBlock:^(JJSwipeLockNodeView *obj, NSUInteger idx, BOOL *stop) {
        obj.nodeSelectedColor = nodeSelectedColor;
    }];
    self.viewState = _viewState;
}

- (void)setNodeWarningColor:(UIColor *)nodeWarningColor
{
    _nodeWarningColor = nodeWarningColor;
    [_nodeArray enumerateObjectsUsingBlock:^(JJSwipeLockNodeView *obj, NSUInteger idx, BOOL *stop) {
        obj.nodeWarningColor = nodeWarningColor;
    }];
}

- (void)setInnerCircleScale:(CGFloat)innerCircleScale
{
    _innerCircleScale = innerCircleScale;
    [_nodeArray enumerateObjectsUsingBlock:^(JJSwipeLockNodeView *obj, NSUInteger idx, BOOL *stop) {
        obj.innerCircleScale = innerCircleScale;
    }];
}

#pragma mark - 密码

- (NSString *)lockPassword
{
    return [self lockPasswordWithSep:kJJSwipeLockViewPasswordSep];
}

- (NSString *)lockPasswordWithSep:(NSString *)sep
{
    NSMutableArray *pwdAray = [NSMutableArray new];
    for(JJSwipeLockNodeView *nodeView in self.selectedNodeArray){
        NSString *index = [@(nodeView.tag) stringValue];
        [pwdAray addObject:index];
    }
    return [pwdAray componentsJoinedByString:sep?:@""];
}

- (void)setLockPassword:(NSString *)lockPassword
{
    if (self.frame.size.width == 0 || self.frame.size.height == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self _setLockPassword:lockPassword];
        });
    }
    else {
        [self _setLockPassword:lockPassword];
    }
}

- (void)_setLockPassword:(NSString *)lockPassword
{
    [self cleanNodes];
    NSArray *pwdArray = [lockPassword componentsSeparatedByString:kJJSwipeLockViewPasswordSep];
    for (NSString *pwd in pwdArray) {
        NSInteger tag = pwd.integerValue;
        JJSwipeLockNodeView *view = [self findJJSwipeLockNodeViewTag:tag];
        [self addSelectedNode:view needDeleteLastLine:NO];
    }
}

///暂时不用 viewTag:  防止后期会增加View 导致问题
- (JJSwipeLockNodeView *)findJJSwipeLockNodeViewTag:(NSInteger)tag
{
    __block JJSwipeLockNodeView *view = nil;
    [_nodeArray enumerateObjectsUsingBlock:^(JJSwipeLockNodeView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag == tag) {
            view = obj;
            *stop = YES;
        }
    }];
    return view;
}

#pragma mark - 手势
- (void)touchMoveAtPoint:(CGPoint)touchPoint
{
    NSInteger index = [self indexForNodeAtPoint:touchPoint];
    if (index >= 0) {
        JJSwipeLockNodeView *node = self.nodeArray[index];
        
        if (![self addSelectedNode:node needDeleteLastLine:YES]) {
            [self moveLineWithFingerPosition:touchPoint];
        }
    }
    else {
        [self moveLineWithFingerPosition:touchPoint];
    }
    
    if([_delegate respondsToSelector:@selector(swipeView:didSwipingWithPassword:)]){
        [_delegate swipeView:self didSwipingWithPassword:self.lockPassword];
    }
}

- (void)endFingerTouch
{
    [self removeLastFingerPosition];
    if([_delegate respondsToSelector:@selector(swipeView:didEndSwipeWithPassword:)]){
        self.viewState = [_delegate swipeView:self didEndSwipeWithPassword:self.lockPassword];
    }
    else{
        self.viewState = JJSwipeLockStateSelected;
    }
}

#if kUsePanGestureRecognizer

- (void)pan:(UIPanGestureRecognizer *)rec
{
    if  (rec.state == UIGestureRecognizerStateBegan){
        self.viewState = JJSwipeLockStateNormal;
    }
    
    CGPoint touchPoint = [rec locationInView:self];
    [self touchMoveAtPoint:touchPoint];
    
    if (rec.state == UIGestureRecognizerStateEnded) {
        [self endFingerTouch];
    }
    
}

#else
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    self.viewState = JJSwipeLockStateNormal;
    [self touchMoveAtPoint:[touches.anyObject locationInView:self]];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    [self touchMoveAtPoint:[touches.anyObject locationInView:self]];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self endFingerTouch];
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self endFingerTouch];
}
#endif

- (BOOL)addSelectedNode:(JJSwipeLockNodeView *)nodeView needDeleteLastLine:(BOOL)needDeleteLastLine
{
    if (nodeView && ![self.selectedNodeArray containsObject:nodeView]) {
        nodeView.nodeViewStatus = JJSwipeLockStateSelected;
        [self.selectedNodeArray addObject:nodeView];
        
        [self addLineToNode:nodeView needDeleteLastLine:needDeleteLastLine];
        
        return YES;
    }else{
        return NO;
    }
    
}

- (void)addLineToNode:(JJSwipeLockNodeView *)nodeView needDeleteLastLine:(BOOL)needDeleteLastLine
{
    if (!self.showLine) {
        return;
    }
    
    if(self.selectedNodeArray.count == 1){
        
        //path move to start point
        CGPoint startPoint = nodeView.center;
        [self.polygonalLinePath moveToPoint:startPoint];
        [self.pointArray addObject:[NSValue valueWithCGPoint:startPoint]];
        self.polygonalLineLayer.path = self.polygonalLinePath.CGPath;
        
    }else{
        
        //path add line to point
        if (needDeleteLastLine) {
            [self.pointArray removeLastObject];
        }
        
        CGPoint middlePoint = nodeView.center;
        [self.pointArray addObject:[NSValue valueWithCGPoint:middlePoint]];
        
        [self.polygonalLinePath removeAllPoints];
        CGPoint startPoint = [self.pointArray[0] CGPointValue];
        [self.polygonalLinePath moveToPoint:startPoint];
        
        for (int i = 1; i < self.pointArray.count; ++i) {
            CGPoint middlePoint = [self.pointArray[i] CGPointValue];
            [self.polygonalLinePath addLineToPoint:middlePoint];
        }
        self.polygonalLineLayer.path = self.polygonalLinePath.CGPath;
        
    }

}

- (void)moveLineWithFingerPosition:(CGPoint)touchPoint
{
    if (self.pointArray.count > 0) {
        if (self.pointArray.count > self.selectedNodeArray.count) {
            [self.pointArray removeLastObject];
        }
        [self.pointArray addObject:[NSValue valueWithCGPoint:touchPoint]];
        [self.polygonalLinePath removeAllPoints];
        CGPoint startPoint = [self.pointArray[0] CGPointValue];
        [self.polygonalLinePath moveToPoint:startPoint];
        
        for (int i = 1; i < self.pointArray.count; ++i) {
            CGPoint middlePoint = [self.pointArray[i] CGPointValue];
            [self.polygonalLinePath addLineToPoint:middlePoint];
        }
        self.polygonalLineLayer.path = self.polygonalLinePath.CGPath;
    }
}

- (void)removeLastFingerPosition
{
    if (self.pointArray.count > 0) {
        if (self.pointArray.count > self.selectedNodeArray.count) {
            [self.pointArray removeLastObject];
        }
        [self.polygonalLinePath removeAllPoints];
        CGPoint startPoint = [self.pointArray[0] CGPointValue];
        [self.polygonalLinePath moveToPoint:startPoint];
        
        for (int i = 1; i < self.pointArray.count; ++i) {
            CGPoint middlePoint = [self.pointArray[i] CGPointValue];
            [self.polygonalLinePath addLineToPoint:middlePoint];
        }
        self.polygonalLineLayer.path = self.polygonalLinePath.CGPath;
        
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat min = MIN(self.bounds.size.width,self.bounds.size.height);
    CGRect frame = self.frame;
    frame.size = CGSizeMake(min, min);
    self.frame = frame;
    
    self.polygonalLineLayer.frame = self.bounds;
    CAShapeLayer *maskLayer = [CAShapeLayer new];
    maskLayer.frame = self.bounds;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.bounds];
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    maskLayer.lineWidth = 1.0f;
    maskLayer.strokeColor = [UIColor blackColor].CGColor;
    maskLayer.fillColor = [UIColor blackColor].CGColor;
    
    CGFloat gapCount = 0.5;

    CGFloat delta   = min / (self.colCount + (self.colCount - 1)*gapCount);
    
    //TODO: here should be more decent
    for (int i = 0; i < self.nodeArray.count; ++i) {
        JJSwipeLockNodeView *nodeView = _nodeArray[i];
        int row = i % self.colCount;
        int column = i / self.colCount;
        CGRect frame = CGRectMake((row+1 + (row)*gapCount)*delta - delta,
                                  (column+1 + (column)*gapCount)*delta - delta,
                                  delta, delta);
        nodeView.frame = frame;
        [maskPath appendPath:[UIBezierPath bezierPathWithOvalInRect:frame]];
    }
    
    maskLayer.path = maskPath.CGPath;
    self.polygonalLineLayer.mask = maskLayer;
}

- (NSInteger)indexForNodeAtPoint:(CGPoint)point
{
    for (int i = 0; i < self.nodeArray.count; ++i) {
        JJSwipeLockNodeView *node = self.nodeArray[i];
        CGPoint pointInNode = [node convertPoint:point fromView:self];
        if ([node pointInside:pointInNode withEvent:nil]) {
            return i;
        }
    }
    return -1;
}

- (void)cleanNodes
{
    for (int i = 0; i < self.nodeArray.count; ++i) {
        JJSwipeLockNodeView *node = self.nodeArray[i];
        node.nodeViewStatus = JJSwipeLockStateNormal;
    }
    
    [self.selectedNodeArray removeAllObjects];
    [self.pointArray removeAllObjects];
    self.polygonalLinePath = [UIBezierPath new];
    self.polygonalLineLayer.strokeColor = self.nodeColor.CGColor;
    self.polygonalLineLayer.path = self.polygonalLinePath.CGPath;
}

- (void)cleanNodesIfNeeded{
    if(self.viewState != JJSwipeLockStateNormal){
        [self cleanNodes];
    }
}

- (void)makeNodesToWarning
{
    for (int i = 0; i < self.selectedNodeArray.count; ++i) {
        JJSwipeLockNodeView *node = self.selectedNodeArray[i];
        node.nodeViewStatus = JJSwipeLockStateWarning;
    }
    self.polygonalLineLayer.strokeColor = self.nodeWarningColor.CGColor;
}

- (CAShapeLayer *)polygonalLineLayer
{
    if (_polygonalLineLayer == nil) {
        _polygonalLineLayer = [[CAShapeLayer alloc] init];
        _polygonalLineLayer.lineWidth = 2.0f;
        _polygonalLineLayer.strokeColor = self.nodeSelectedColor.CGColor;
        _polygonalLineLayer.fillColor = [UIColor clearColor].CGColor;
    }
    return _polygonalLineLayer;
}

- (void)setViewState:(JJSwipeLockState)viewState
{
//    if(_viewState != viewState){
        _viewState = viewState;
        switch (_viewState){
            case JJSwipeLockStateNormal:
                [self cleanNodes];
                break;
            case JJSwipeLockStateWarning:
                [self makeNodesToWarning];
                [self performSelector:@selector(cleanNodesIfNeeded) withObject:nil afterDelay:1];
                break;
            case JJSwipeLockStateSelected:
            default:
                break;
        }
//    }
}


@end
