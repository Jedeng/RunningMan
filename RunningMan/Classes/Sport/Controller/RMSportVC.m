//
//  RMSportVC.m
//  RunningMan
//
//  Created by 纵使寂寞开成海 on 16/1/15.
//  Copyright © 2016年 WindManTeam. All rights reserved.
//

#import "RMSportVC.h"
#import "BMapKit.h"
#import "RMXMPPTool.h"
#import "UIBarButtonItem+Item.h"
#import "UIViewController+MMDrawerController.h"

@interface RMSportVC ()<BMKMapViewDelegate,BMKLocationServiceDelegate>

@property (strong, nonatomic) BMKMapView *mapView;
/** 百度地图位置服务 */
@property (nonatomic, strong) BMKLocationService *locationService;

@end

@implementation RMSportVC
#pragma mark - 懒加载

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /** 初始化地图 */
    self.mapView = [BMKMapView new];
    self.mapView.frame = self.view.bounds;
    [self.view insertSubview:self.mapView atIndex:0];
    
    [self setLocationService];
    [self setMapViewProperty];
    self.mapView.delegate          = self;
    self.locationService.delegate = self;

    
    /** 启动定位服务 */
    [self.locationService startUserLocationService];
    
    [self setupRightBarBtn];
}


#pragma mark -
/** 自定义位置服务初始化 */
- (void) setLocationService
{
    self.locationService = [[BMKLocationService alloc]init];
    /** 过滤器,几米定位一次 */
    [BMKLocationService setLocationDistanceFilter:5];
    /** 设置精确度 */
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyBest];
}
/** 百度地图 View 的属性设置 */
- (void) setMapViewProperty
{
    /** 最重要的几个属性 */
    self.mapView.showsUserLocation       = YES;
    self.mapView.userTrackingMode        = BMKUserTrackingModeNone;
    self.mapView.rotateEnabled               = NO;
    self.mapView.showMapScaleBar        = YES;
    self.mapView.mapScaleBarPosition    = CGPointMake(self.view.frame.size.width - 100,
                                                                                      self.view.frame.size.height - 100);
    
    /** 定位图层的自定义设置 */
    BMKLocationViewDisplayParam *displayPara = [BMKLocationViewDisplayParam new];
    displayPara.isAccuracyCircleShow     = NO;
    displayPara.isRotateAngleValid          = YES;
    displayPara.locationViewOffsetX        = 0;
    displayPara.locationViewOffsetX        = 0;
    
    [self.mapView updateLocationViewWithParam:displayPara];
    
}

- (void) setupRightBarBtn
{
    XMPPvCardTemp *vCard = [RMXMPPTool sharedRMXMPPTool].xmppvCard.myvCardTemp;

    UIImage *headerImage = [[UIImage alloc]init];
    if (vCard.photo) {
        headerImage = [UIImage imageWithData:vCard.photo];
    }
    else
    {
        headerImage = [UIImage imageNamed:@"headImage"];
    }
    
    UIBarButtonItem *item = [UIBarButtonItem itemWithImage: headerImage
                                                 highImage: nil
                                                    target: self
                                                    action: @selector(myPofilesBtn)
                                          forControlEvents: UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = item;
}
- (void) myPofilesBtn
{
    [[self mm_drawerController] toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
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
