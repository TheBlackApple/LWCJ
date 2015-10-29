//
//  StructureCollectionViewController.h
//  路网采集
//
//  Created by Cecilia on 14-3-31.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "BaseViewController.h"
#import "BMKMapView.h"
#import "ASIHTTPRequest.h"
#import "baiduToWGS84.h"

@class baiduToWGS84;

@interface StructureCollectionViewController : BaseViewController<BMKMapViewDelegate,ASIHTTPRequestDelegate>
{
    
    BMKMapView *mapView;
    NSTimer *timer;
    
}

@end
