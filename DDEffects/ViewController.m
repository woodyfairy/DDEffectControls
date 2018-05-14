//
//  ViewController.m
//  RotPopView
//
//  Created by 吴冬炀 on 2018/5/11.
//  Copyright © 2018年 吴冬炀. All rights reserved.
//

#import "ViewController.h"
#import "DDRotPopViewController.h"
#import "DDSleekSlider.h"
#import "DDAnimNumberLabel.h"

@interface ViewController ()<DDSleekSliderDelegate>
@property (nonatomic, strong) DDSleekSlider *slider;
@property (nonatomic, strong) DDAnimNumberLabel *animLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    float width = [UIScreen mainScreen].bounds.size.width;
    //float height = self.view.bounds.size.height;
    
    self.homeBtnView.clipsToBounds = YES;
    self.homeBtnView.layer.cornerRadius = self.homeBtnView.bounds.size.height/2;
    
    self.animLabel = [[DDAnimNumberLabel alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    self.animLabel.center = CGPointMake(width/2, 70);
    [self.view addSubview:self.animLabel];
    
    self.slider = [[DDSleekSlider alloc] initWithFrame:CGRectMake(10, 100, width - 20, 40)];
    self.slider.min = 0;
    self.slider.max = 20;
    self.slider.value = 0;
    [self.view addSubview:self.slider];
    self.slider.delegate = self;
    self.slider.color = [UIColor colorWithRed:0.6 green:0.8 blue:1 alpha:0.8f];
    //self.slider.backgroundColor = [UIColor redColor];
    self.animLabel.text = [NSString stringWithFormat:@"%d", (int)self.slider.value];
    
    UIButton *buton = [UIButton buttonWithType:UIButtonTypeCustom];
    [buton setFrame:CGRectMake(10, self.slider.frame.origin.y + self.slider.frame.size.height + 10, 80, 40)];
    [buton setTitle:@"To:0" forState:UIControlStateNormal];
    buton.backgroundColor = [UIColor lightGrayColor];
    buton.clipsToBounds = YES;
    buton.layer.cornerRadius = 5;
    [self.view addSubview:buton];
    [buton addTarget:self action:@selector(tap1) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *buton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [buton2 setFrame:CGRectMake(width - 90, self.slider.frame.origin.y + self.slider.frame.size.height + 10, 80, 40)];
    [buton2 setTitle:@"To:MAX" forState:UIControlStateNormal];
    buton2.backgroundColor = [UIColor lightGrayColor];
    buton2.clipsToBounds = YES;
    buton2.layer.cornerRadius = 5;
    [self.view addSubview:buton2];
    [buton2 addTarget:self action:@selector(tap2) forControlEvents:UIControlEventTouchUpInside];
}
-(void)tap1{
    [self.slider setValueWithAnimation:0 aminTime:0.25f];
}
-(void)tap2{
    [self.slider setValueWithAnimation:self.slider.max aminTime:0.25f];
}
-(void)DDSleekSliderDelegateValueChanged:(float)value{
    [self.animLabel setNumber:(int)value];
}


- (IBAction)clickHomeBtn:(id)sender {
    UIView *view = [[UIView alloc] init];
    //view.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5f];
    DDRotPopViewController *vc = [[DDRotPopViewController alloc] initWithView:view height:300];
    [vc show];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
