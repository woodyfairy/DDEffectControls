//
//  UILabel+Copy.m
//  DDEffects
//
//  Created by 吴冬炀 on 2018/5/14.
//  Copyright © 2018年 吴冬炀. All rights reserved.
//

#import "UILabel+Copy.h"

@implementation UILabel(Copy)
-(instancetype)copy{
    UILabel *label = [[UILabel alloc] initWithFrame:self.frame];
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
    //... add others if need
    return label;
}

@end
