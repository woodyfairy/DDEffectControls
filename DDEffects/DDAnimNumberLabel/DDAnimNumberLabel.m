//
//  DDAnimNumberLabel.m
//  DDEffects
//
//  Created by 吴冬炀 on 2018/5/14.
//  Copyright © 2018年 吴冬炀. All rights reserved.
//

#import "DDAnimNumberLabel.h"
//#import "UILabel+Copy.h"

@interface DDAnimNumberLabel()
@property (assign, nonatomic) float animTime;
@property (assign, nonatomic) float upOffsetX;
@property (assign, nonatomic) float upScale;
@property (assign, nonatomic) float downOffsetX;
@property (assign, nonatomic) float downScale;
@property (strong, nonatomic) NSMutableArray *arrayAnimLabels;
@property (assign, nonatomic) double lastChangeTime;
@property (assign, nonatomic) int targetNumber;
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
    _animTime = .2f;
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
    time = MAX(time, 0.06f);
    __block DDAnimNumberLabel *this = self;
    if (number > currentNum) {
        self.hidden = YES;
        UILabel *now = [self copy];
        [self.superview addSubview:now];
        [self.arrayAnimLabels addObject:now];
        UILabel *next = [self copy];
        next.text = [NSString stringWithFormat:@"%d", number];
        [self.superview insertSubview:next belowSubview:self];
        [self.arrayAnimLabels addObject:next];
        CGAffineTransform downTrans = CGAffineTransformMakeScale(this.downScale, this.downScale);
        downTrans = CGAffineTransformConcat(downTrans, CGAffineTransformMakeTranslation(this.downOffsetX, 0));
        next.transform = downTrans;
        next.alpha = 0;
        [UIView animateWithDuration:time animations:^{
            CGAffineTransform upTrans = CGAffineTransformMakeScale(this.upScale, this.upScale);
            upTrans = CGAffineTransformConcat(upTrans, CGAffineTransformMakeTranslation(this.upOffsetX, 0));
            now.transform = upTrans;
            now.alpha = 0;
            
            next.transform = CGAffineTransformIdentity;
            next.alpha = 1;
        }completion:^(BOOL finished) {
            [now removeFromSuperview];
            [next removeFromSuperview];
            [this.arrayAnimLabels removeObject:now];
            [this.arrayAnimLabels removeObject:next];
            if (this.arrayAnimLabels.count == 0) {
                this.text = [NSString stringWithFormat:@"%d", this.targetNumber];
                this.hidden = NO;
            }
        }];
    }else if (number < currentNum){
        self.hidden = YES;
        UILabel *next = [self copy];
        next.text = [NSString stringWithFormat:@"%d", number];
        [self.superview addSubview:next];
        [self.arrayAnimLabels addObject:next];
        CGAffineTransform upTrans = CGAffineTransformMakeScale(this.upScale, this.upScale);
        upTrans = CGAffineTransformConcat(upTrans, CGAffineTransformMakeTranslation(this.upOffsetX, 0));
        next.transform = upTrans;
        next.alpha = 0;
        
        UILabel *now = [self copy];
        [self.superview insertSubview:now belowSubview:self];
        [self.arrayAnimLabels addObject:now];
        [UIView animateWithDuration:time animations:^{
            next.transform = CGAffineTransformIdentity;
            next.alpha = 1;
            
            CGAffineTransform downTrans = CGAffineTransformMakeScale(this.downScale, this.downScale);
            downTrans = CGAffineTransformConcat(downTrans, CGAffineTransformMakeTranslation(this.downOffsetX, 0));
            now.transform = downTrans;
            now.alpha = 0;
        }completion:^(BOOL finished) {
            [now removeFromSuperview];
            [next removeFromSuperview];
            [this.arrayAnimLabels removeObject:now];
            [this.arrayAnimLabels removeObject:next];
            if (this.arrayAnimLabels.count == 0) {
                this.text = [NSString stringWithFormat:@"%d", this.targetNumber];
                this.hidden = NO;
            }
        }];
    }
    [super setText:[NSString stringWithFormat:@"%d", number]];
}

@end
