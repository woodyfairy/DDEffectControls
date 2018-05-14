//
//  DDSleekSlider.h
//  DDEffects
//
//  Created by 吴冬炀 on 2018/5/11.
//  Copyright © 2018年 吴冬炀. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDSleekSliderDelegate<NSObject>
-(void)DDSleekSliderDelegateValueChanged:(float) value;
@end

typedef NS_ENUM(NSInteger, DDSleekSliderShowType){
    FullSide,
    TopSide,
    BotSide,
};

@interface DDSleekSlider : UIView
@property (assign, nonatomic) id<DDSleekSliderDelegate> delegate;
@property (assign, nonatomic) float min, max, value;
@property (strong, nonatomic) UIColor *color;
@property (assign, nonatomic) float barHeight, thumbHeight, thumbWidth;//UI
@property (assign, nonatomic) DDSleekSliderShowType type;
@property (assign, nonatomic) BOOL accuracy;//根据y距离提高精度

-(void)setValueWithAnimation:(float)value aminTime:(float)time;

//获取对应值的x坐标
-(float)getValueX;
-(float)getMinX;
-(float)getMaxX;

@end
