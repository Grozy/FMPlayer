//
//  ViewController.m
//  Sad
//
//  Created by 孙国志 on 16/1/8.
//  Copyright (c) 2016年 grozy. All rights reserved.
//

#import "ViewController.h"
#import "WXApi.h"
#import "AFNetworking.h"
#import "WXConst.h"
#import "MFMOAuth.h"

@interface ViewController ()
{

}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat kGap = 10.f;
    CGFloat kHeight = 44.f;
    button.frame = CGRectMake(kGap, CGRectGetHeight(self.view.frame) - kHeight - kGap, CGRectGetWidth(self.view.frame) - 2 * kGap, kHeight);
    button.backgroundColor = [UIColor blueColor];
    [button addTarget:self action:@selector(sendAuthRequest) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WX
-(void)sendAuthRequest
{
    [[MFMOAuth sharedOAuth] signInWithNavigationController:self];
}
#pragma mark - token

@end
