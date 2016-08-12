//
//  ViewController.m
//  LZXGaoDeMapDemo
//
//  Created by WH on 15-11-30.
//  Copyright (c) 2015年 小草. All rights reserved.
//

#import "ViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

@interface ViewController ()<MAMapViewDelegate,UIGestureRecognizerDelegate,AMapLocationManagerDelegate>
{
    MAMapView *_mapView;
}
@property (nonatomic)NSInteger index;
@property (nonatomic,strong)AMapLocationManager *locMgr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    //设置 显示图区域
    self.index=1;
    _mapView.zoomLevel=3;
    UILongPressGestureRecognizer *Lpress =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(LongPressClick:)];
    Lpress.delegate=self;
    Lpress.minimumPressDuration=1.0;
    Lpress.allowableMovement=50;
    [_mapView addGestureRecognizer:Lpress];
    _mapView.region = MACoordinateRegionMake(CLLocationCoordinate2DMake(34.77274899, 113.67591140), MACoordinateSpanMake(0.01, 0.01));
    
    _mapView.delegate = self;
    _mapView.mapType = MAMapTypeStandard;
    UIButton *button =[[UIButton alloc]initWithFrame:CGRectMake(0, 100, 100, 100)];
    button.backgroundColor =[UIColor redColor];
    [_mapView addSubview:button];
    [button addTarget:self action:@selector(startlocation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_mapView];
    
   // [self createAnnotation];
}
- (void)vtn:(UIButton *)button
{
    _mapView.zoomLevel+=self.index;
    if (self.index<17) {
        self.index++;
    }
    NSLog(@"+++%ld",self.index);
}
#pragma mark- 长按时间相应
-(void)LongPressClick:(UILongPressGestureRecognizer *)gestureRecognizer
{
    
    CGPoint touchPoint = [gestureRecognizer locationInView:_mapView];
 
    CLLocationCoordinate2D touchMapCoordinate = [_mapView convertPoint:touchPoint toCoordinateFromView:_mapView];
//     _mapView.region = MACoordinateRegionMake(touchMapCoordinate, MACoordinateSpanMake(0.01, 0.01));
    [self createAnnotationwithcoordinate:touchMapCoordinate];
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
#pragma mark - 大头针
- (void)createAnnotationwithcoordinate:(CLLocationCoordinate2D)cooordinate {
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
   // pointAnnotation.coordinate = CLLocationCoordinate2DMake(34.77274892, 113.67591140);
    pointAnnotation.coordinate=cooordinate;
    pointAnnotation.title = @"小草";
    pointAnnotation.subtitle = @"小小草";
    [_mapView addAnnotation:pointAnnotation];
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.canShowCallout= YES; //设置气泡可以弹出,默认为 NO
        annotationView.animatesDrop = YES; //设置标注动画显示,默认为 NO
        annotationView.draggable = YES; //设置标注可以拖动,默认为 NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}
#pragma  mark - POI
- (AMapLocationManager *)locMgr {
    if (!_locMgr) {
        _locMgr = [[AMapLocationManager alloc] init];
        _locMgr.delegate = self;
        
        // 定位精度
        _locMgr.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        // 距离过滤器，当移动距离小于这个值时不会收到回调
        //        _locMgr.distanceFilter = 50;
    }
    return _locMgr;
}
-(void)startlocation:(UIButton *)button
{
    [self.locMgr startUpdatingLocation];
   
}
-(void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
   
        NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    if (location) {
        [self.locMgr stopUpdatingLocation];
    }
           [_locMgr stopUpdatingLocation];
}
@end
