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
