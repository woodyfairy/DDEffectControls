//
//  WaveView.m
//  HavalConnect
//
//  Created by 吴冬炀 on 2018/6/7.
//  Copyright © 2018年 mengy. All rights reserved.
//

#import "WaveView.h"

@interface WaveView()
@property(nonatomic, assign) double startTime;
@property(nonatomic, strong) dispatch_source_t timer;

@property (nonatomic, assign) float waveCenterY;
@property (nonatomic, assign) float waveHeight;
@property (nonatomic, assign) float waveFrequency;//每秒几个波形
@property (nonatomic, assign) float waveMoveSpeed;//每秒移动几个像素

@end

@implementation WaveView
-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        //timer
        _waveCenterY = 20;
        _waveHeight = 10;
        _waveFrequency = 0.45;
        _waveMoveSpeed = 180;
        _colorBack = [UIColor colorWithRed:192.f/255.f green:224.f/255.f blue:1 alpha:1];//[UIColor colorWithRed:72.f/255.f green:164.f/255.f blue:246.f/255.f alpha:1];
        _colorFront = [UIColor colorWithRed:105.f/255.f green:183.f/255.f blue:253.f/255.f alpha:1];
        
        _startTime = [[NSDate date] timeIntervalSince1970];
        
        dispatch_queue_t queue = dispatch_get_main_queue();
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        
        uint64_t intervel = (uint64_t)(17.0f * NSEC_PER_MSEC);
        
        dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, intervel);
        dispatch_source_set_timer(_timer, start, intervel, 0);
        
        dispatch_source_set_event_handler(_timer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.superview) {
                    [self setNeedsDisplay];
                }else{
                    dispatch_source_cancel(self.timer);
                }
            });
        });
        
        dispatch_resume(_timer);
        
    }
    return self;
}
-(void)dealloc{
    NSLog(@"dealloc");
}

-(void)drawRect:(CGRect)rect{
    double time = [[NSDate date] timeIntervalSince1970] - _startTime;
    
    //底色
//    [[UIColor clearColor] setFill];
//    UIRectFill(rect);
    
    int width = self.bounds.size.width;
    int height = self.bounds.size.height;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //第一个波
    //[[UIColor colorWithRed:72.f/255.f green:164.f/255.f blue:246.f/255f alpha:1] setFill];
    CGContextBeginPath(ctx);
    
    CGContextMoveToPoint(ctx, width, height);
    CGContextAddLineToPoint(ctx, 0, height);
    for (int x = 0; x <= width; x ++) {
        float preTime = time - x / _waveMoveSpeed;
        float y = self.bounds.size.height - _waveCenterY - sinf(preTime * M_PI * 2 * _waveFrequency) * _waveHeight;
        CGContextAddLineToPoint(ctx, x, y);
    }
    CGContextClosePath(ctx);
    //CGContextSetRGBFillColor(ctx, 72.f/255.f, 164.f/255.f, 246.f/255.f, 1);
    [_colorBack setFill];
    CGContextFillPath(ctx);
    
    //第二个波
    CGContextBeginPath(ctx);
    
    CGContextMoveToPoint(ctx, width, height);
    CGContextAddLineToPoint(ctx, 0, height);
    for (int x = 0; x <= width; x ++) {
        float preTime = time - x / (_waveMoveSpeed + 50) + 0.2f;
        float y = self.bounds.size.height - _waveCenterY - sinf(preTime * M_PI * 2 * _waveFrequency) * _waveHeight;
        CGContextAddLineToPoint(ctx, x, y);
    }
    CGContextClosePath(ctx);
    //CGContextSetRGBFillColor(ctx, 105.f/255.f, 183.f/255.f, 253.f/255.f, 1);
    [_colorFront setFill];
    CGContextFillPath(ctx);
    
}

@end
