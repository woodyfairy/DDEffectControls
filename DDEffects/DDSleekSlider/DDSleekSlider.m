//
//  DDSleekSlider.m
//  DDEffects
//
//  Created by 吴冬炀 on 2018/5/11.
//  Copyright © 2018年 吴冬炀. All rights reserved.
//

#import "DDSleekSlider.h"
@interface DDSleekSlider()
@property (assign, nonatomic) float inset;
@property (assign, nonatomic) CGPoint touchStartPos;
@property (assign, nonatomic) CGPoint touchStartThumbPos;
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;
@property (strong, nonatomic) UIView *thumbView;

//动画相关
@property (assign, nonatomic) float animTime;
@property (assign, nonatomic) float animFrameTime;
@property (assign, nonatomic) float animCurrentTime;
@property (assign, nonatomic) float startValue;
@property (assign, nonatomic) float targetValue;
@property (strong, nonatomic) NSTimer *timerForAnim;
@end

@implementation DDSleekSlider
-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self initData];
        _thumbHeight = frame.size.height;
    }
    return self;
}
-(instancetype)init{
    if ([super init]) {
        [self initData];
    }
    return self;
}
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _thumbHeight = frame.size.height;
    [self resetThumbView];
}
-(void)initData{
    self.backgroundColor = [UIColor clearColor];
    _min = 0;
    _max = 1;
    _value = 0;
    _color = [UIColor lightGrayColor];
    _barHeight = 14;
    _thumbHeight = 40;
    _thumbWidth = 80;
    _inset = _thumbWidth/2 + _barHeight/2;
    _type = TopSide;
    _accuracy = NO;
    _thumbView = [[UIView alloc] init];
    _thumbView.backgroundColor = [UIColor clearColor];
    [self addSubview:_thumbView];
    [self resetThumbView];
    //[_thumbView setBackgroundColor:[[UIColor greenColor] colorWithAlphaComponent:0.5f]];//test
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureHandler:)];
    [_thumbView addGestureRecognizer: _panGesture];
}
-(void)resetThumbView{
    float valueX = [self getValueX];
    float sizeX = MAX(40, _thumbWidth);
    float sizeY = MAX(40, _thumbHeight);
    [_thumbView setFrame:CGRectMake(valueX - sizeX/2, self.bounds.size.height/2 - sizeY/2, sizeX, sizeY)];
}
-(void)setMin:(float)min{
    if (_min >= _max) {
        NSLog(@"error: _min >= _max");
        return;
    }
    _min = min;
    [self resetThumbView];
    [self refresh];
}
-(void)setMax:(float)max{
    if (_max <= _min) {
        NSLog(@"error: _max <= _min");
        return;
    }
    _max = max;
    [self resetThumbView];
    [self refresh];
}
-(void)setValue:(float)value{
    if (value != _value) {
        _value = value;
        [self resetThumbView];
        [self refresh];
        if (self.delegate && [self.delegate respondsToSelector:@selector(DDSleekSliderDelegateValueChanged:)]) {
            [self.delegate DDSleekSliderDelegateValueChanged:_value];
        }
    }
}
-(void)setColor:(UIColor *)color{
    _color = color;
    [self refresh];
}
-(void)setBarHeight:(float)barHeight{
    _barHeight = barHeight;
    _inset = _thumbWidth/2 + _barHeight/2;
    [self resetThumbView];
    [self refresh];
}
-(void)setThumbHeight:(float)thumbHeight{
//    _thumbHeight = thumbHeight;
//    [self refresh];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, thumbHeight);
}
-(void)setThumbWidth:(float)thumbWidth{
    _thumbWidth = thumbWidth;
    _inset = _thumbWidth/2 + _barHeight/2;
    [self resetThumbView];
    [self refresh];
}
-(void)setType:(enum DDSleekSliderShowType)type{
    _type = type;
    [self refresh];
}
-(void)handlePanGestureHandler:(UIPanGestureRecognizer *)gesture{
    //先停止所有动画
    if (_timerForAnim) {
        [_timerForAnim invalidate];
        _timerForAnim = nil;
    }
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _touchStartPos = [gesture translationInView:self];
        _touchStartThumbPos = _thumbView.center;
    }else if (gesture.state == UIGestureRecognizerStateChanged){
        CGPoint pos = [gesture translationInView:self];
        //NSLog(@"pos:%@", NSStringFromCGPoint(pos));
        float deltaX = pos.x - _touchStartPos.x;
        if (_accuracy) {
            float delatY = fabs(pos.y - _touchStartPos.y) - 20;//20只内不算
            delatY = MAX(delatY, 0);
            deltaX = deltaX * pow(0.997f, delatY);//偏离越多，位移越小，微调
        }
        float newX = _touchStartThumbPos.x + deltaX;
        if (newX < _inset) {
            newX = _inset;
        }
        if (newX > self.bounds.size.width - _inset) {
            newX = self.bounds.size.width - _inset;
        }
        BOOL testAnim = NO;
        if (testAnim) {
            __block DDSleekSlider *this = self;
            [UIView animateWithDuration:0.1f animations:^{
                [UIView setAnimationBeginsFromCurrentState:YES];
                this.thumbView.center = CGPointMake(newX, this.thumbView.center.y);
            }];
        }else{
            _thumbView.center = CGPointMake(newX, _thumbView.center.y);
        }
        
        
        float newValue = _min + (newX - _inset)/(self.bounds.size.width - _inset*2) * (_max - _min);
        if (newValue < _min) {
            newValue = _min;
        }
        if (newValue > _max) {
            newValue = _max;
        }
        _value = newValue;
        if (self.delegate && [self.delegate respondsToSelector:@selector(DDSleekSliderDelegateValueChanged:)]) {
            [self.delegate DDSleekSliderDelegateValueChanged:_value];
        }
        //NSLog(@"value:%f", _value);
        [self refresh];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self refresh];
}
-(void)refresh{
    [self setNeedsDisplay];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, _color.CGColor);
    float center = self.bounds.size.height/2;
    float width = self.bounds.size.width;
    
    float valueX = [self getValueX];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake( _barHeight/2, center - _barHeight/2)];
    if (_type == FullSide || _type == TopSide) {
        [path addLineToPoint:CGPointMake(valueX - _thumbWidth/2, center - _barHeight/2)];
        [path addCurveToPoint:CGPointMake(valueX, center - _thumbHeight/2) controlPoint1:CGPointMake(valueX - _thumbWidth/4, center - _barHeight/2) controlPoint2:CGPointMake(valueX - _thumbWidth/4, center - _thumbHeight/2)];
        [path addCurveToPoint:CGPointMake(valueX + _thumbWidth/2, center - _barHeight/2) controlPoint1:CGPointMake(valueX + _thumbWidth/4, center - _thumbHeight/2) controlPoint2:CGPointMake(valueX + _thumbWidth/4, center - _barHeight/2)];
        
    }
    [path addLineToPoint:CGPointMake(width - _inset, center - _barHeight/2)];
    [path addArcWithCenter:CGPointMake(width - _barHeight/2, center) radius:_barHeight/2 startAngle:-M_PI/2 endAngle:M_PI/2 clockwise:YES];
    if (_type == FullSide || _type == BotSide) {
        [path addLineToPoint:CGPointMake(valueX + _thumbWidth/2, center + _barHeight/2)];
        [path addCurveToPoint:CGPointMake(valueX, center + _thumbHeight/2) controlPoint1:CGPointMake(valueX + _thumbWidth/4, center + _barHeight/2) controlPoint2:CGPointMake(valueX + _thumbWidth/4, center + _thumbHeight/2)];
        [path addCurveToPoint:CGPointMake(valueX - _thumbWidth/2, center + _barHeight/2) controlPoint1:CGPointMake(valueX - _thumbWidth/4, center + _thumbHeight/2) controlPoint2:CGPointMake(valueX - _thumbWidth/4, center + _barHeight/2)];
    }
    
    [path addLineToPoint:CGPointMake(_barHeight/2, center + _barHeight/2)];
    [path addArcWithCenter:CGPointMake(_barHeight/2, center) radius:_barHeight/2 startAngle:M_PI/2 endAngle:-M_PI/2 clockwise:YES];
    
    [self.color set];
    [path fill];
    //CGContextFillPath(context);
}

-(float)getValueX{
    float x = _inset + (self.bounds.size.width - _inset*2) * _value/(_max - _min);
    return x;
}
-(float)getMinX{
    return _inset;
}
-(float)getMaxX{
    return self.bounds.size.width - _inset;
}

#pragma -mark- 动画表现
-(void)setValueWithAnimation:(float)value aminTime:(float)time{
    _animTime = time;
    _animFrameTime = 1.f / 60.f;
    _animCurrentTime = 0;
    _startValue = _value;
    _targetValue = value;
    if (_timerForAnim) {
        [_timerForAnim invalidate];
        _timerForAnim = nil;
    }
    
    _timerForAnim = [NSTimer timerWithTimeInterval:_animFrameTime target:self selector:@selector(animUpdate) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer: _timerForAnim forMode:NSRunLoopCommonModes];
}
-(void)animUpdate{
    _animCurrentTime += _animFrameTime;
    if (_animCurrentTime >= _animTime) {
        [self setValue:_targetValue];
        [_timerForAnim invalidate];
        _timerForAnim = nil;
    }else{
        float persent = -cos(_animCurrentTime/_animTime*M_PI) * 0.5f + 0.5f;
        [self setValue:_startValue + (_targetValue - _startValue) * persent];
    }
}

@end
