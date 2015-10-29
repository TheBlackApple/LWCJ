//
//  RoteCollectionViewController.h
//  路网采集
//
//  Created by Cecilia on 14-3-31.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "BaseViewController.h"
#import "BMKMapView.h"

@interface RoteCollectionViewController : BaseViewController<BMKMapViewDelegate,UIAlertViewDelegate>
{
    
    BMKMapView *mapView;
    NSTimer *timer;
    int flag;
    NSMutableArray *locationArray;          //WGS84
    NSMutableArray *locationOriginalArray;  //BD09
}

@end
