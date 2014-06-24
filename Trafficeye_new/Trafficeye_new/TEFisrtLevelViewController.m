//
//  TEFisrtLevelViewController.m
//  Trafficeye_new
//
//  Created by 张 驰 on 13-6-17.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import "TEFisrtLevelViewController.h"
#import "TEReportEventViewController.h"
#import "TETimeLineViewController.h"

@interface TEFisrtLevelViewController ()

@end

@implementation TEFisrtLevelViewController
@synthesize cameraPicker;
@synthesize selectedEventType;
@synthesize viewArray;
@synthesize view_toolbar;

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    int y_toolbar = iPhone5?(503+IOS7OFFSIZE):(415+IOS7OFFSIZE);
    self.view_toolbar = [[UIView alloc]initWithFrame:CGRectMake(0, y_toolbar, 320, 45)];
    self.view_toolbar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.view_toolbar];
    
    UIButton *button_showLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_showLeft setBackgroundImage:[UIImage imageNamed:@"navi_menu.png"] forState:UIControlStateNormal];
    [button_showLeft setBackgroundImage:[UIImage imageNamed:@"navi_menu_pressed.png"] forState:UIControlStateHighlighted];
    button_showLeft.frame=CGRectMake(0, 0, 45, 45);
    [button_showLeft addTarget:self action:@selector(showLeft:) forControlEvents:UIControlEventTouchUpInside];
    [self.view_toolbar addSubview:button_showLeft];
    UIButton *button_report = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_report setBackgroundImage:[UIImage imageNamed:@"report.png"] forState:UIControlStateNormal];
    [button_report setBackgroundImage:[UIImage imageNamed:@"report_pressed.png"] forState:UIControlStateHighlighted];
    button_report.frame=CGRectMake(115, 5, 90, 35);
    [button_report addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view_toolbar addSubview:button_report];
    
    UIButton *button_showRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_showRight setBackgroundImage:[UIImage imageNamed:@"navi_sns.png"] forState:UIControlStateNormal];
    [button_showRight setBackgroundImage:[UIImage imageNamed:@"navi_sns_pressed.png"] forState:UIControlStateHighlighted];
    button_showRight.frame=CGRectMake(275, 0, 45, 45);
    [button_showRight addTarget:self action:@selector(showRight:) forControlEvents:UIControlEventTouchUpInside];
    [self.view_toolbar addSubview:button_showRight];
//    button_showRight.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)showLeft:(id)sender {
    DDMenuController *menuController = [TEAppDelegate getApplicationDelegate].menuController;
    [menuController showLeftController:YES];
    
}
- (void)showRight:(id)sender {
    //判断是否登录，没有登录则让登录
    if([TEAppDelegate getApplicationDelegate].isLogin == 0){
        UIAlertView* alert =[[UIAlertView alloc] initWithTitle:nil message:@"请先登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        NSArray* array = [TEAppDelegate getApplicationDelegate].navControllers;
        DDMenuController *menuController = (DDMenuController*)[TEAppDelegate getApplicationDelegate].menuController;
        [menuController setRootController:[array objectAtIndex:INDEX_PAGE_USER] animated:YES];
        return;
    }
    TETimeLineViewController* timeLineVC = [[TETimeLineViewController alloc]init];
    [self.navigationController pushViewController:timeLineVC animated:YES];
}
- (void)takePhoto{
    self.cameraPicker=[[UIImagePickerController alloc]init];
    self.cameraPicker.sourceType=UIImagePickerControllerSourceTypeCamera;//选取摄像头作为来源
    [self.cameraPicker setDelegate:self];
    self.cameraPicker.showsCameraControls=NO;
    UIView *overLayView=[[UIView alloc]initWithFrame:self.view.bounds];
    overLayView.backgroundColor = [UIColor clearColor];
    int offsize = -20;
    if(IOS7){
        UIView *statusbar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
        statusbar.backgroundColor = [UIColor whiteColor];
        [overLayView addSubview:statusbar];
        offsize = 0;
    }
    UIView *topbar = [[UIView alloc]initWithFrame:CGRectMake(0, 20+offsize, 320, 45)];
    UIImage* img =[UIImage imageNamed:@"bar.png"];
    [topbar setBackgroundColor:[UIColor colorWithPatternImage:img]];
    
    UILabel* label_title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
    label_title.text = @"发布";
    label_title.textColor = [UIColor whiteColor];
    label_title.textAlignment = NSTextAlignmentCenter;
    label_title.font = [UIFont systemFontOfSize: 22];
    [topbar addSubview:label_title];
    
    UIButton *button_close = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_close setBackgroundImage:[UIImage imageNamed:@"icon_close.png"] forState:UIControlStateNormal];
    [button_close setBackgroundImage:[UIImage imageNamed:@"icon_close_pressed.png"] forState:UIControlStateHighlighted];
    [button_close addTarget:self action:@selector(closeClicked) forControlEvents:UIControlEventTouchUpInside];
    button_close.frame = CGRectMake(275, 0, 45, 45);
    [topbar addSubview:button_close];
    
    [overLayView addSubview:topbar];
    int y_view_report = 0;
    if(iPhone5){
        y_view_report = 418;
    }else{
        y_view_report = 330;
    }
    UIView* view_report = [[UIView alloc]initWithFrame:CGRectMake(0, y_view_report+offsize, 320, 105)];
    [view_report setBackgroundColor:[UIColor blackColor]];
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    label.text = @" 选择交通信息类型(滑动显示更多类型)";
    label.backgroundColor = [UIColor whiteColor];
    [view_report addSubview:label];
    UIScrollView* scrollview_content = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, 320, 85)];
    [view_report addSubview:scrollview_content];
    NSArray* pic_name_array = [[NSArray alloc]initWithObjects:
                               @"map_report_street_view.png",
                               @"map_report_2b_driver.png",
                               @"map_report_accident2.png",
                               @"map_report_accident1.png",
                               @"map_report_construction1.png",
                               @"map_report_construction2.png",
                               @"map_report_jam3.png",
                               @"map_report_jam2.png",
                               @"map_report_jam1.png",
                               @"map_report_control2.png",
                               @"map_report_control1.png",nil];
    NSArray* pic_des_array = [[NSArray alloc]initWithObjects:
                              @"街景随拍",
                              @"无良驾驶",
                              @"严重事故",
                              @"轻微事故",
                              @"临时施工",
                              @"长期施工",
                              @"严重拥堵",
                              @"行驶缓慢",
                              @"畅通",
                              @"匝道封闭",
                              @"交通管制",nil];
    int i = 0;
    self.viewArray = [[NSMutableArray alloc]init];
    for (i=0; i<11; i++) {
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(5+65*i, 5, 60, 75)];
        view.layer.cornerRadius = 8;
        view.layer.masksToBounds = YES;
        //给图层添加一个有色边框
        view.layer.borderWidth = 2;
        if(i == 0){
            view.backgroundColor = [UIColor colorWithRed:0.4 green:0.8 blue:1 alpha:1];
        }else{
            view.backgroundColor = [UIColor whiteColor];
        }
        view.layer.borderColor = [[UIColor colorWithRed:0.52 green:0.09 blue:0.07 alpha:1] CGColor];
        [scrollview_content addSubview:view];
        view.tag = i;
        
        [self.viewArray addObject:view];
        
        UIImage *image = [UIImage imageNamed:[pic_name_array objectAtIndex:i]];
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        imageview.image = image;
        [view addSubview:imageview];
        
        UILabel* label_des = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, 60, 20)];
        label_des.text = [pic_des_array objectAtIndex:i];
        label_des.font = [UIFont systemFontOfSize: 13];
        [label_des setTextAlignment:NSTextAlignmentCenter];
        [view addSubview:label_des];
        
        UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEvent:)];
        tapRecognizer.cancelsTouchesInView = NO;
        [view addGestureRecognizer:tapRecognizer];
    }
    [scrollview_content setContentSize:CGSizeMake(720, 75)];
    scrollview_content.showsHorizontalScrollIndicator = YES;
    [overLayView addSubview:view_report];
    
    
    int y_bottomView = 0;
    if(iPhone5){
        y_bottomView = 523;
    }else{
        y_bottomView = 435;
    }
    
    
    UIView* bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, y_bottomView+offsize, 320, 45)];
    [bottomView setBackgroundColor:[UIColor colorWithPatternImage:img]];
    [overLayView addSubview:bottomView];
    
    UIButton *button_album = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_album setBackgroundImage:[UIImage imageNamed:@"report_album.png"] forState:UIControlStateNormal];
    [button_album addTarget:self action:@selector(albumClicked) forControlEvents:UIControlEventTouchUpInside];
    button_album.frame = CGRectMake(5, 5, 35, 35);
    [bottomView addSubview:button_album];
    
    UIButton *button_camera = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_camera setBackgroundImage:[UIImage imageNamed:@"report_camera.png"] forState:UIControlStateNormal];
    [button_camera setBackgroundImage:[UIImage imageNamed:@"report_camera_pressed.png"] forState:UIControlStateHighlighted];
    [button_camera addTarget:self action:@selector(cameraClicked) forControlEvents:UIControlEventTouchUpInside];
    button_camera.frame = CGRectMake(115, 5, 90, 35);
    [bottomView addSubview:button_camera];
    
    
    
    //加上半透明遮盖的view
    if(iPhone5){
        UIView *view_top = [[UIView alloc]initWithFrame:CGRectMake(0, 65+offsize, 320, 16)];
        view_top.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [overLayView addSubview:view_top];
        
        UIView *view_bottom = [[UIView alloc]initWithFrame:CGRectMake(0, 402+offsize, 320, 16)];
        view_bottom.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [overLayView addSubview:view_bottom];
    }
    cameraPicker.cameraOverlayView = overLayView;
    [self presentViewController:self.cameraPicker animated:YES completion:nil];
    
}
- (void)closeClicked{
    [self.cameraPicker dismissViewControllerAnimated:NO completion:^{
        NSLog(@"zcrrr");
    }];
}
- (void)albumClicked{
    [self.cameraPicker dismissViewControllerAnimated:NO completion:^{
        NSLog(@"zcrrr");
    }];
    UIImagePickerController* albumPicker=[[UIImagePickerController alloc]init];
    if(IOS7){
        albumPicker.edgesForExtendedLayout = UIRectEdgeNone;
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
        titleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
        titleLabel.font = [UIFont boldSystemFontOfSize:20];  //设置文本字体与大小
        titleLabel.textColor = [UIColor whiteColor];  //设置文本颜色
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"ddd";  //设置标题
        albumPicker.navigationItem.titleView = titleLabel;
        albumPicker.navigationBar.layer.contents=nil;
    }
    albumPicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    albumPicker.allowsEditing = YES;
    [albumPicker setDelegate:self];
    UIViewController* rootViewController =  [[UIApplication sharedApplication] keyWindow].rootViewController;
    rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    [rootViewController presentViewController:albumPicker animated:YES completion:nil];
}
- (void)cameraClicked{
    [self.cameraPicker takePicture];
}
- (void)tapEvent:(UITapGestureRecognizer*) gesture
{
    int i = 0;
    for (i=0; i<[self.viewArray count]; i++) {
        UIView* view = (UIView*)[self.viewArray objectAtIndex:i];
        view.backgroundColor = [UIColor whiteColor];
    }
    UIView *v = (UIView*)gesture.view;
    [v setBackgroundColor:[UIColor colorWithRed:0.4 green:0.8 blue:1 alpha:1]];
    self.selectedEventType = v.tag;
}
#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image;
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }else{
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    
    
    [picker dismissViewControllerAnimated:NO completion:^{
        NSLog(@"zcrrr");
    }];
    UIImage* eventImage;
    eventImage = [self croppedImage:image];
    
    eventImage = [self image:eventImage rotation:image.imageOrientation];
    NSLog(@"imageOrientation is %i",image.imageOrientation);
    
    //缩放到640*640
    CGSize size = CGSizeMake(640, 640);
    UIGraphicsBeginImageContext(size); //size 为CGSize类型，即你所需要的图片尺寸
    [eventImage drawInRect:CGRectMake(0, 0, 640, 640)]; //newImageRect指定了图片绘制区域
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    NSLog(@"newImage width is %f,height is %f",newImage.size.width,newImage.size.height);
    UIGraphicsEndImageContext();
    
    //保存到硬盘看一下大小
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"test.png"]];   // 保存文件的名称
//    BOOL result = [UIImagePNGRepresentation(newImage)writeToFile: filePath atomically:YES];
    
    
    
    TEReportEventViewController* reportEventVC = [[TEReportEventViewController alloc]init];
    reportEventVC.eventType = self.selectedEventType;
    reportEventVC.eventImage = newImage;
    CLLocationCoordinate2D coordinate = [[[TEAppDelegate getApplicationDelegate].mapview_app userLocation] coordinate];
    NSLog(@"loc lat = %f, loc lon = %f",coordinate.latitude,coordinate.longitude);
    reportEventVC.lat = coordinate.latitude;
    reportEventVC.lon = coordinate.longitude;
    UIViewController* rootViewController =  [[UIApplication sharedApplication] keyWindow].rootViewController;
    rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    [rootViewController presentViewController:reportEventVC animated:YES completion:^(void){NSLog(@"pop reportEventVC");}];
}
- (UIImage *)croppedImage:(UIImage *)image
{
    //    if (image)
    //    {
    //        float min = MIN(image.size.width,image.size.height);
    //        NSLog(@"width is %f,height is %f",image.size.width,image.size.height);
    //        CGRect rectMAX = CGRectMake((image.size.width-min)/2, (image.size.height-min)/2, min, min);
    //
    //        CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rectMAX);
    //
    //        UIGraphicsBeginImageContext(rectMAX.size);
    //        CGContextRef context = UIGraphicsGetCurrentContext();
    //        CGContextDrawImage(context, CGRectMake(0, 0, min, min), subImageRef);
    //        UIImage *viewImage = [UIImage imageWithCGImage:subImageRef];
    //        UIGraphicsEndImageContext();
    //        CGImageRelease(subImageRef);
    //        NSLog(@"after crop width is %f,height is %f",viewImage.size.width,viewImage.size.height);
    //        return viewImage;
    //    }
    //    return nil;
    CGSize size = [image size];
    float min = MIN(size.width,size.height);
    CGRect rect;
    float posX = (size.width   - min) / 2.0f;
    float posY = (size.height  - min) / 2.0f;
    //裁剪也和图片方向有关，下面的转换保证了正方形。
    NSLog(@"width is %f,height is %f",image.size.width,image.size.height);
    if(image.imageOrientation == UIImageOrientationLeft ||
       image.imageOrientation == UIImageOrientationRight)
    {
        rect = CGRectMake(posY, posX,
                          min, min);
        
    }
    else
    {
        rect = CGRectMake(posX, posY,
                          min, min);
    }
    
    
    // Create bitmap image from original image data,
    // using rectangle to specify desired crop area
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage *img = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    NSLog(@"after crop width is %f,height is %f",img.size.width,img.size.height);
    return img;
}


- (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation

{
    long double rotate = 0.0;
    
    CGRect rect;
    
    float translateX = 0;
    
    float translateY = 0;
    
    float scaleX = 1.0;
    
    float scaleY = 1.0;
    
    
    
    switch (orientation) {
            
        case UIImageOrientationLeft:
            
            rotate = M_PI_2;
            
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            
            translateX = 0;
            
            translateY = -rect.size.width;
            
            scaleY = rect.size.width/rect.size.height;
            
            scaleX = rect.size.height/rect.size.width;
            
            break;
            
        case UIImageOrientationRight:
            
            rotate = 3 * M_PI_2;
            
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            
            translateX = -rect.size.height;
            
            translateY = 0;
            
            scaleY = rect.size.width/rect.size.height;
            
            scaleX = rect.size.height/rect.size.width;
            
            break;
            
        case UIImageOrientationDown:
            
            rotate = M_PI;
            
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            
            translateX = -rect.size.width;
            
            translateY = -rect.size.height;
            
            break;
            
        default:
            
            rotate = 0.0;
            
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            
            translateX = 0;
            
            translateY = 0;
            
            break;
            
    }
    
    
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //做CTM变换
    
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextRotateCTM(context, rotate);
    
    CGContextTranslateCTM(context, translateX, translateY);
    
    
    
    CGContextScaleCTM(context, scaleX, scaleY);
    
    //绘制图片
    
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    
    
    return newPic;
    
}


@end
