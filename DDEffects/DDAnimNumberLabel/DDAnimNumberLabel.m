//
//  DDAnimNumberLabel.m
//  DDEffects
//
//  Created by 吴冬炀 on 2018/5/14.
//  Copyright © 2018年 吴冬炀. All rights reserved.
//

#import "DDAnimNumberLabel.h"

@implementation DDAnimNumberLabel

-(void)setText:(NSString *)text{
    int num = [text intValue];
    [super setText:[NSString stringWithFormat:@"%d", num]];
}
-(void)setNumber:(int)number{
    int currentNum = [self.text intValue];
    [super setText:[NSString stringWithFormat:@"%d", number]];
}

@end
