//
//  TEFirstAnimationViewController.m
//  Trafficeye_new
//
//  Created by zc on 14-1-27.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import "TEFirstAnimationViewController.h"
#import "TEPersistenceHandler.h"
#import "TESetHomePageViewController.h"

@interface TEFirstAnimationViewController ()

@end

@implementation TEFirstAnimationViewController
@synthesize image = _image;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    int length = 568;
    NSString* imageName = @"bg_640x1136.jpg";
    if(iPhone5){
        length = 568;
        imageName = @"bg_640x1136.jpg";
    }else{
        length = 480;
        imageName = @"bg_640x960.jpg";
    }
    
    UIImageView *dimage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, length)];
    self.image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, length)];
    
//    UIImageView *dimage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 480, length/8*12)];
//    self.image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 480, length/8*12)];
    
    
    self.image.image = [UIImage imageNamed:imageName];
    dimage.clipsToBounds = YES;
    [dimage addSubview:_image];
    [self.view addSubview:dimage];
    
    float ypositon;
    int titleHight;
    NSString* titleImageName;
    if(iPhone5){
        ypositon = 482.5;
        titleHight = 57;
        titleImageName = @"title_640x114.png";
    }else{
        ypositon = 408;
        titleHight = 48;
        titleImageName = @"title_640x96.png";
    }
    UIImageView *titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, ypositon, 320, titleHight)];
    titleImage.image = [UIImage imageNamed:titleImageName];
    [self.view addSubview:titleImage];
    
    self.image.alpha = 0;
    [self initAppWhileAnimation];
    [self outTiemTwo];
}
- (void)initAppWhileAnimation{
    //初始化为一些变量赋值
    [[TEAppDelegate getApplicationDelegate] initVar];
    //用户登录
    [[TEAppDelegate getApplicationDelegate] tryLogin];
}
-(void)outTiemTwo{
    [UIView beginAnimations:@"show" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:5.0];
    int length = 568;
    if(iPhone5){
        length = 568;
    }else{
        length = 480;
    }
//    self.image.frame = CGRectMake(-40, -(length/8), 400, length/8*10);
    self.image.frame = CGRectMake(0, 0, 400, length/8*10);
    self.image.alpha = 1;
    [UIView commitAnimations];
}
- (void)initAfterAnimation{
    [[TEAppDelegate getApplicationDelegate] afterAnimation];
}
-(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    NSLog(@"动画结束！！！！！！");
    [self performSelector:@selector(initAfterAnimation) withObject:nil afterDelay:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}


@end
