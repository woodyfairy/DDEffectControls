//
//  DDAnimNumberLabel.m
//  DDEffects
//
//  Created by 吴冬炀 on 2018/5/14.
//  Copyright © 2018年 吴冬炀. All rights reserved.
//

#import "DDAnimNumberLabel.h"

@protocol DDAnimNumberLabelDelegate<NSObject>
-(void)DDAnimNumberLabelAnimDone:(DDAnimNumberLabel *)label;
@end

@interface DDAnimNumberLabel()<DDAnimNumberLabelDelegate>
@property (assign, nonatomic) float animTime;
@property (assign, nonatomic) float upOffsetX;
@property (assign, nonatomic) float upScale;
@property (assign, nonatomic) float downOffsetX;
@property (assign, nonatomic) float downScale;
@property (strong, nonatomic) NSMutableArray *arrayAnimLabels;
@property (assign, nonatomic) double lastChangeTime;
@property (assign, nonatomic) int targetNumber;

//动画相关
//@property (assign, nonatomic) CGAffineTransform targetTransform;
@property (assign, nonatomic) float originalAlpha;
@property (assign, nonatomic) float targetAlpha;
@property (assign, nonatomic) float originalOffset;
@property (assign, nonatomic) float targetOffset;
@property (assign, nonatomic) float originalScale;
@property (assign, nonatomic) float targetScale;
@property (assign, nonatomic) double startAnimTime;
@property (strong, nonatomic) NSTimer *timerForAnim;
@property (weak, nonatomic) id<DDAnimNumberLabelDelegate> delegate;
@end

@implementation DDAnimNumberLabel
-(instancetype)init{
    if ([super init]) {
        [self initData];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self initData];
    }
    return self;
}
-(void)initData{
    _animTime = .25f;//主label中为默认动画时间，在分label中为单独的动画时间
    _upOffsetX = -150;
    _upScale = 2;
    _downOffsetX = 100;
    _downScale = 0.5f;
    _arrayAnimLabels = [NSMutableArray array];
    _lastChangeTime = 0;
    self.textAlignment = NSTextAlignmentCenter;
    self.numberOfLines = 1;
    self.adjustsFontSizeToFitWidth = YES;
    self.minimumScaleFactor = 0.5f;
    self.font = [UIFont boldSystemFontOfSize:60];
    self.textColor = [UIColor colorWithRed:0.6f green:0.8f blue:1.0f alpha:0.8f];
}

-(void)setText:(NSString *)text{
    int num = [text intValue];
    [super setText:[NSString stringWithFormat:@"%d", num]];
}
-(void)setNumber:(int)number{
    if (self.superview == nil) {
        [super setText:[NSString stringWithFormat:@"%d", number]];
        return;
    }
    int currentNum = [self.text intValue];
    if (number == currentNum) {
        return;
    }
    _targetNumber = number;
    double time = [NSDate date].timeIntervalSinceReferenceDate - _lastChangeTime;
    _lastChangeTime = [NSDate date].timeIntervalSinceReferenceDate;
    time = MIN(time, _animTime);
    //time = MAX(time, 0.05f);
    bool haveNowNumber = NO;
    for (NSInteger i = self.arrayAnimLabels.count - 1; i >= 0; i --) {
        DDAnimNumberLabel *label = self.arrayAnimLabels[i];
        float timePercent = ([NSDate date].timeIntervalSinceReferenceDate - label.startAnimTime)/label.animTime;
        //NSLog(@"percent:%f", timePercent);
        if (timePercent > 0.02f) {
            label.originalAlpha = label.originalAlpha + (label.targetAlpha - label.originalAlpha) * timePercent;
            label.originalScale = label.originalScale + (label.targetScale - label.originalScale) * timePercent;
            label.originalOffset = label.originalOffset + (label.targetOffset - label.originalOffset) * timePercent;
            label.animTime = time * (1- timePercent);
            [label startAnim];
            if (label.text.integerValue == self.text.integerValue) {
                if (label.targetAlpha == 0) {
                    haveNowNumber = YES;
                }else{
                    [label.timerForAnim invalidate];
                    [label removeFromSuperview];
                    [self.arrayAnimLabels removeObject:label];
                }
            }
        }else{
            [label.timerForAnim invalidate];
            [label removeFromSuperview];
            [self.arrayAnimLabels removeObject:label];
        }
    }
    //__block DDAnimNumberLabel *this = self;
    if (number > currentNum) {
        self.hidden = YES;
        if (haveNowNumber == NO) {
            DDAnimNumberLabel *now = [self copy];
            [self.superview addSubview:now];
            [self.arrayAnimLabels addObject:now];
            now.originalAlpha = 1;
            now.originalScale = 1;
            now.originalOffset = 0;
            now.targetAlpha = 0;
            now.targetScale = _upScale;
            now.targetOffset = _upOffsetX;
            now.delegate = self;
            [now startAnim];
        }
        
        DDAnimNumberLabel *next = [self copy];
        next.text = [NSString stringWithFormat:@"%d", number];
        [self.superview insertSubview:next belowSubview:self];
        [self.arrayAnimLabels addObject:next];
        next.originalAlpha = 0;
        next.originalScale = _downScale;
        next.originalOffset = _downOffsetX;
        next.targetAlpha = 1;
        next.targetScale = 1;
        next.targetOffset = 0;
        next.delegate = self;
        [next startAnim];
        
    }else if (number < currentNum){
        self.hidden = YES;
        DDAnimNumberLabel *next = [self copy];
        next.text = [NSString stringWithFormat:@"%d", number];
        [self.superview addSubview:next];
        [self.arrayAnimLabels addObject:next];
        next.originalAlpha = 0;
        next.originalScale = _upScale;
        next.originalOffset = _upOffsetX;
        next.targetAlpha = 1;
        next.targetScale = 1;
        next.targetOffset = 0;
        next.delegate = self;
        [next startAnim];
        
        if (haveNowNumber == NO) {
            DDAnimNumberLabel *now = [self copy];
            [self.superview insertSubview:now belowSubview:self];
            [self.arrayAnimLabels addObject:now];
            now.originalAlpha = 1;
            now.originalScale = 1;
            now.originalOffset = 0;
            now.targetAlpha = 0;
            now.targetScale = _downScale;
            now.targetOffset = _downOffsetX;
            now.delegate = self;
            [now startAnim];
        }
    }
    [super setText:[NSString stringWithFormat:@"%d", number]];
}


-(void)DDAnimNumberLabelAnimDone:(DDAnimNumberLabel *)label{
    [label removeFromSuperview];
    [self.arrayAnimLabels removeObject:label];
    if (self.arrayAnimLabels.count == 0) {
        self.text = [NSString stringWithFormat:@"%d", self.targetNumber];
        self.hidden = NO;
    }
}


-(void)startAnim{
//    if (_animTime < 0.2f) {
//        NSLog(@"time:%f", _animTime);
//    }
    
    __block DDAnimNumberLabel *this = self;
    [self.layer removeAllAnimations];
    self.alpha = self.originalAlpha;
    CGAffineTransform originalTrans = CGAffineTransformMakeScale(self.originalScale, self.originalScale);
    originalTrans = CGAffineTransformConcat(originalTrans, CGAffineTransformMakeTranslation(self.originalOffset, 0));
    self.transform = originalTrans;
    [UIView animateWithDuration:_animTime animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        CGAffineTransform targetTransform = CGAffineTransformMakeScale(self.targetScale, self.targetScale);
        targetTransform = CGAffineTransformConcat(targetTransform, CGAffineTransformMakeTranslation(self.targetOffset, 0));
        this.alpha = this.targetAlpha;
        this.transform = targetTransform;
    }];
    if (_timerForAnim) {
        [_timerForAnim invalidate];
        _timerForAnim = nil;
    }
    _timerForAnim = [NSTimer scheduledTimerWithTimeInterval:_animTime repeats:NO block:^(NSTimer * _Nonnull timer) {
        if (this.delegate && [this.delegate respondsToSelector:@selector(DDAnimNumberLabelAnimDone:)]) {
            [this.delegate DDAnimNumberLabelAnimDone:this];
        }
    }];
}



-(instancetype)copy{
    DDAnimNumberLabel *label = [[DDAnimNumberLabel alloc] initWithFrame:self.frame];
    label.text = self.text;
    label.textColor = self.textColor;
    label.tintColor = self.tintColor;
    label.font = self.font;
    label.backgroundColor = self.backgroundColor;
    label.clipsToBounds = self.clipsToBounds;
    label.textAlignment = self.textAlignment;
    label.numberOfLines = self.numberOfLines;
    label.adjustsFontSizeToFitWidth = self.adjustsFontSizeToFitWidth;
    label.minimumScaleFactor = self.minimumScaleFactor;
    label.animTime = self.animTime;
    
    label.startAnimTime = [[NSDate date] timeIntervalSinceReferenceDate];
    //... add others if need
    return label;
}

@end
