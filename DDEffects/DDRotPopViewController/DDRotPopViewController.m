//
//  RotPopViewController.m
//  RotPopView
//
//  Created by 吴冬炀 on 2018/5/11.
//  Copyright © 2018年 吴冬炀. All rights reserved.
//

#import "DDRotPopViewController.h"

@interface DDRotPopViewController ()
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *containerBackView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageBotCenter;
@property (weak, nonatomic) IBOutlet UIImageView *backImageBotLeft;
@property (weak, nonatomic) IBOutlet UIImageView *backImageBotRight;
@property (weak, nonatomic) IBOutlet UIImageView *backImageTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property (assign, nonatomic) float initHeight;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) UIWindow *window;//以window来展示
@property (assign, nonatomic) float animTime;

@property (strong, nonatomic) UIView *contentView;//显示的内容

@end


@implementation DDRotPopViewController
-(instancetype)initWithView:(UIView *)view height:(float)height{
    if ([super init]) {
        self.contentView = view;
        self.initHeight = height;
        self.animTime = 0.6f;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.backImageBotLeft.image = [[UIImage imageNamed:@"backImgBotLeft"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 18, 55, 1) resizingMode:UIImageResizingModeStretch];
    self.backImageBotRight.image = [[UIImage imageNamed:@"backImgBotRight"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 55, 18) resizingMode:UIImageResizingModeStretch];
    self.backImageTop.image = [[UIImage imageNamed:@"backImgTop"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 50, 1, 50) resizingMode:UIImageResizingModeStretch];
    
    self.height.constant = self.initHeight;
    
    if (self.contentView) {
        [self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.containerView addSubview:self.contentView];
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        NSLayoutConstraint *bot = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
        [self.containerView addConstraints:@[top, bot, left, right]];
    }
    
    CGAffineTransform rot = CGAffineTransformMakeRotation(M_PI * 0.95f);
    self.containerBackView.transform = rot;
}
-(void)viewDidAppear:(BOOL)animated{
    float anchorPointY = (self.containerBackView.bounds.size.height - 17)/self.containerBackView.bounds.size.height;
    self.containerBackView.layer.anchorPoint = CGPointMake(0.5f, anchorPointY);
}
-(void)show{
    self.window = [[UIWindow alloc] init];
    self.window.rootViewController = self;
    self.window.backgroundColor = [UIColor clearColor];
    self.window.hidden = NO;
    
    
    [UIView animateWithDuration:self.animTime * 0.7f animations:^{
        CGAffineTransform rot = CGAffineTransformIdentity;
        self.containerBackView.transform = rot;
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:self.animTime * 0.1f animations:^{
            CGAffineTransform rot = CGAffineTransformMakeRotation(-0.03f);
            self.containerBackView.transform = rot;
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:self.animTime * 0.2f animations:^{
                CGAffineTransform rot = CGAffineTransformIdentity;
                self.containerBackView.transform = rot;
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            }completion:^(BOOL finished) {
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
                [self.backView addGestureRecognizer:tap];
                UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
                [self.containerBackView addGestureRecognizer:tap2];
                UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
                [self.containerView addGestureRecognizer:tap3];
            }];
        }];
    }];
    [UIView animateWithDuration:self.animTime animations:^{
        self.backView.alpha = 0.1f;
    }];
    //NSLog(@"windows:%ld", [[UIApplication sharedApplication] windows].count);
}
-(void)hide{
    [UIView animateWithDuration:self.animTime * 0.7f animations:^{
        CGAffineTransform rot = CGAffineTransformMakeRotation(M_PI * 0.95f);
        self.containerBackView.transform = rot;
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    }];
    [UIView animateWithDuration:self.animTime * 0.7f animations:^{
        self.backView.alpha = 0;
    } completion:^(BOOL finished) {
        self.window.hidden = YES;
        self.window = nil;
        //NSLog(@"windows:%ld", [[UIApplication sharedApplication] windows].count);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
