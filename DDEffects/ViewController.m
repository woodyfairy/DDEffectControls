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

@interface ViewController ()
@property (nonatomic, strong) DDSleekSlider *slider;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.homeBtnView.clipsToBounds = YES;
    self.homeBtnView.layer.cornerRadius = self.homeBtnView.bounds.size.height/2;
    
    float width = self.view.bounds.size.width;
    //float height = self.view.bounds.size.height;
    self.slider = [[DDSleekSlider alloc] initWithFrame:CGRectMake(10, 100, width - 20, 40)];
    self.slider.min = 0;
    self.slider.max = 100;
    self.slider.value = 50;
    [self.view addSubview:self.slider];
    //self.slider.backgroundColor = [UIColor redColor];
    
    UIButton *buton = [UIButton buttonWithType:UIButtonTypeCustom];
    [buton setFrame:CGRectMake(10, self.slider.frame.origin.y + self.slider.frame.size.height + 10, 80, 40)];
    [buton setTitle:@"To:0" forState:UIControlStateNormal];
    buton.backgroundColor = [UIColor lightGrayColor];
    buton.clipsToBounds = YES;
    buton.layer.cornerRadius = 5;
    [self.view addSubview:buton];
    [buton addTarget:self action:@selector(tap1) forControlEvents:UIControlEventTouchUpInside];
}
-(void)tap1{
    [self.slider setValueWithAnimation:0 aminTime:0.25f];
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
