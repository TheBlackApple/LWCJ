//
//  AppDelegate.h
//  路网采集
//
//  Created by hdsx-mac-mini on 14-3-31.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "BMKMapManager.h"
#import "MLNavigationController.h"
#import <CoreData/CoreData.h>
#import "TaskEvent.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate,BMKGeneralDelegate>
{
    
    BMKMapManager *mapManager;
    
}


@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) MLNavigationController * navCtrl;
@property (strong, nonatomic) UITabBarController *tabBarC;
@property (retain ,nonatomic) NSString *centerStake;    //中心桩号
@property (retain ,nonatomic) NSString *structureStyle; //建筑物类型
@property (assign ,nonatomic) int dropSaveCount;        //点状采集已保存的个数
@property (assign ,nonatomic) int lineSaveCount;        //线状采集已保存的个数
@property (assign ,nonatomic) BOOL isLinePoint;
@property (retain ,nonatomic) NSString *dropNumTf;      //点状编码数字
@property (retain ,nonatomic) NSString *dropNameTf;     //点状名称
@property (retain ,nonatomic) NSString *beginStake;     //起点桩号
@property (retain ,nonatomic) NSString *endStake;       //止点桩号
@property (retain ,nonatomic) NSString *rodeStyleTf;    //路线类型
@property (retain ,nonatomic) NSArray *dropArray;       //点状数据数组
@property (retain ,nonatomic) NSArray *lineArray;       //线状数据数组
@property (strong,nonatomic) TaskEvent * currentTask;   //当前任务
@property (assign,nonatomic) BOOL isSelect;             //是否选择任务
@property (strong,nonatomic) NSString * collectType;    //采集类型:采点,采线
@property (strong,nonatomic,readonly) NSManagedObjectContext * managedObjetContext;
@property (strong,nonatomic,readonly) NSManagedObjectModel * managedObjectModel;
@property (strong,nonatomic,readonly) NSPersistentStoreCoordinator * persistentStroeCoordinator;



- (void)saveContext;
- (NSURL *)applicationDocumentDirectory;

@end
