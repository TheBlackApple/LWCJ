//
//  AppDelegate.m
//  路网采集
//
//  Created by hdsx-mac-mini on 14-3-31.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "DataCollectionViewController.h"
#import "DataManageViewController.h"
#import "SettingViewController.h"
#import "TaskViewController.h"
#import "MainViewController.h"


@implementation AppDelegate
@synthesize tabBarC;
@synthesize centerStake;
@synthesize structureStyle;
@synthesize dropSaveCount;
@synthesize lineSaveCount;
@synthesize dropNameTf;
@synthesize dropNumTf;
@synthesize rodeStyleTf;
@synthesize dropArray;
@synthesize lineArray;
@synthesize currentTask;
@synthesize isLinePoint;
@synthesize collectType;
@synthesize managedObjetContext =_managedObjetContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStroeCoordinator = _persistentStroeCoordinator;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [mapManager start:mapKey generalDelegate:self];
    if(!ret)
    {
        NSLog(@"manager start failed!");
    }
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"alreadyLogin"];
    
    tabBarC =[[UITabBarController alloc]init];
    tabBarC.delegate = self;
    
    DataCollectionViewController *dcvc = [[DataCollectionViewController alloc]init];
    DataManageViewController *dmvc = [[DataManageViewController alloc]init];
    
    //SettingViewController *svc = [[SettingViewController alloc]init];
    TaskViewController * taskView = [[TaskViewController alloc]init];
    
    UINavigationController *dcvcNav = [[UINavigationController alloc]initWithRootViewController:dcvc];
    
    UINavigationController *dmvcNav =[[UINavigationController alloc]initWithRootViewController:dmvc];
    UINavigationController *svcNav = [[UINavigationController alloc]initWithRootViewController:taskView];
    dmvcNav.tabBarItem = [dmvcNav.tabBarItem initWithTitle:@"数据管理" image:[UIImage imageNamed:@"数据管理"] selectedImage:[UIImage imageNamed:@"数据管理选中"]];
    dcvcNav.tabBarItem = [dcvcNav.tabBarItem initWithTitle:@"数据采集" image:[UIImage imageNamed:@"数据采集"] selectedImage:[UIImage imageNamed:@"数据采集选中"]];
    svcNav.tabBarItem = [svcNav.tabBarItem initWithTitle:@"任务列表" image:[UIImage imageNamed:@"任务列表"] selectedImage:[UIImage imageNamed:@"系统设置选中"]];
    
    NSArray *tabBarArray = [[NSArray alloc]initWithObjects:svcNav,dcvcNav,dmvcNav, nil];
    tabBarC.viewControllers = tabBarArray;
    [tabBarC.tabBar setBackgroundColor:[UIColor cyanColor]];
    //[tabBarC.tabBar setBackgroundImage:[UIImage imageNamed:@""]];
    
    //主页
    MainViewController * mainView = [[MainViewController alloc]init];
    MLNavigationController * navCtrl = [[MLNavigationController alloc]initWithRootViewController:mainView];
//    [[navCtrl.navigationBar ap] setBackgroundImage:[UIImage imageNamed:@"nav7"] forBarMetrics:UIBarMetricsDefault];
    self.navCtrl = navCtrl;
     self.window.rootViewController = self.navCtrl;
    NSString *def = [[NSUserDefaults standardUserDefaults] objectForKey:@"first"];
    if (def.length != 0)
    {
//        [[NSUserDefaults standardUserDefaults] setObject:@"first" forKey:@"first"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height)];
//        scroll.pagingEnabled = YES;
//        scroll.delegate = self;
//        scroll.tag = 1000;
//        scroll.showsHorizontalScrollIndicator = NO;
//        scroll.showsVerticalScrollIndicator = NO;
//        [self.window addSubview:scroll];
//        scroll.contentSize = CGSizeMake(320*3, self.window.frame.size.height);
//        for (int i = 0; i < 3; i ++) {
//            
//            UIImageView *image = [[[UIImageView alloc] initWithFrame:CGRectMake(320 * i, 0, self.window.frame.size.width, self.window.frame.size.height)]autorelease];
//            if(is_iphone_5)
//            {
//                image.image = [UIImage imageNamed:[NSString stringWithFormat:@"引导页阿%d",i+1] ];
//            }
//            else
//            {
//                image.image = [UIImage imageNamed:[NSString stringWithFormat:@"引导页%d",i+1] ];
//            }
//            
//            [scroll addSubview:image];
//            if (i == 2) {
//                image.userInteractionEnabled = YES;
//                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//                [btn setImage:[UIImage imageNamed:@"引导页3_03"] forState:UIControlStateNormal];
//                btn.frame = CGRectMake(112,is_iphone_5?480:420, 95, 40);
//                //[btn setImage:[UIImage imageNamed:@"引导页点击"] forState:UIControlStateNormal];
//                //btn.backgroundColor = [UIColor blackColor];
//                [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
//                [image addSubview:btn];
//            }
//            
//        }
    }
    else
    {
        
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        NSString *nameStr = [def objectForKey:@"alreadyLogin"];
        [def synchronize];
        
        if ([nameStr integerValue] == 0)
        {
            LoginViewController *lvc = [[LoginViewController alloc] init];
            MLNavigationController *nav = [[MLNavigationController alloc]initWithRootViewController:lvc];
            self.window.rootViewController = nav;
        }
        else
        {
            self.window.rootViewController = self.navCtrl;
        }
    }

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark -CoreData方法

//保存内容
- (void)saveContext
{
    NSError * error = nil;
    //获取应用的托管对象上下
    NSManagedObjectContext * managedObjectContext = self.managedObjetContext;
    if (managedObjectContext !=nil)
    {
        if ([managedObjectContext hasChanges] &&![managedObjectContext save:&error])
        {
            NSLog(@"保存出错: %@ ,%@",error,[error userInfo]);
            abort();
        }
    }
}

//初始化应用的托管对象上下文
- (NSManagedObjectContext *)managedObjetContext
{
    NSLog(@"AAA");
    // 如果_managedObjectContext已经被初始化过，直接返回该对象
    if (_managedObjetContext != nil)
    {
        return _managedObjetContext;
    }
    // 获取持久化存储协调器
    NSPersistentStoreCoordinator * coordinator = self.persistentStroeCoordinator;
    //如果持久化存储协调器不是nil
    if (coordinator !=nil)
    {
        // 创建NSManagedObjectContext对象
        _managedObjetContext = [[NSManagedObjectContext alloc]init];
        // 为NSManagedObjectContext对象设置持久化存储协调器
        [_managedObjetContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjetContext;
}
//初始化Model
- (NSManagedObjectModel *)managedObjectModel
{
    NSLog(@"BBB");
    // 如果_managedObjectModel已经被初始化过，直接返回该对象
	if (_managedObjectModel != nil) {
		return _managedObjectModel;
	}
    //获取试题模型文件对应的URL
    NSURL * modelURL = [[NSBundle mainBundle]URLForResource:@"MyTaskModel" withExtension:@"momd"];
    NSLog(@"model Url is%@",modelURL);
    // 加载应用的实体模型文件，并初始化NSManagedObjectModel对象
    _managedObjectModel = [[NSManagedObjectModel alloc]initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}
//初始化 NSPersistentStoreCoordinator
- (NSPersistentStoreCoordinator *)persistentStroeCoordinator
{
    NSLog(@"CCC");
    // 如果_persistentStoreCoordinator已经被初始化过，直接返回该对象
	if (_persistentStroeCoordinator != nil) {
		return _persistentStroeCoordinator;
	}
    //获取SQLite数据库文件的存储目录
    NSURL * storeURL = [[self applicationDocumentDirectory] URLByAppendingPathComponent:@"Tasks.sqlite"];
    NSError * error = nil;
    //以持久化对象模型为基础,创建NSPersistentStoreCoordinator对象d
    _persistentStroeCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:self.managedObjectModel];
    //设置持久化存储协调器底层采用SQLite存储机制,如果设置失败记录错误信息
    if (![_persistentStroeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"设置持久化存储失败：%@, %@", error, [error userInfo]);
		abort();
    }
    return _persistentStroeCoordinator;
}
//获取Ducument目录地址
- (NSURL *)applicationDocumentDirectory
{
    NSLog(@"url is %@",NSHomeDirectory());
    return [[[NSFileManager defaultManager]URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject];
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
