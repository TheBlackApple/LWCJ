//
//  TaskViewController.m
//  路网采集
//
//  Created by Charles Leo on 14-7-25.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "TaskViewController.h"
#import "TaskCell.h"
#import "NewTaskViewController.h"
#import "UnUpLoadViewController.h"
#import "SendBackViewController.h"
#import "HMSegmentedControl.h"

@interface TaskViewController ()
{
    //UIView *segMentCtrl;
    NewTaskViewController * newTaskView ;
    UnUpLoadViewController * unuploadView;
    SendBackViewController * sendBackView;
}
@property (strong,nonatomic) UIViewController * mOldController;
@property (strong,nonatomic) UIViewController * mNewController;
@property (strong,nonatomic) UIImageView * mSelectIndexImage;
@end

@implementation TaskViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"采集大师";
           }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.leftBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn setTitle:@"同步" forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.titleLabel.text = @"任务列表";
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeMenuView];
	//[self makeView];
}
-(void)buttonClick:(UIButton *)sender
{
    

    switch (sender.tag) {
        case 0:
             [self.navigationController popViewControllerAnimated:YES];
            break;
        case 1:
        {
            NSLog(@"点击了右侧按钮");
            if ([self.rightBtn.titleLabel.text isEqualToString:@"同步"]) {
                [newTaskView synchroData];
            }
            else if([self.rightBtn.titleLabel.text isEqualToString:@"全部上传"])
            {
                
            }
            else
            {
                
            }
            
            break;
        }
        default:
            break;
    }
        
}

-(void)makeMenuView
{
    NSArray * array = @[@"新任务",@"未上传",@"被退回"];
    
    HMSegmentedControl *segMentCtrl = [[HMSegmentedControl alloc] initWithSectionTitles:array];
    [segMentCtrl setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 320,44)];
    [segMentCtrl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [segMentCtrl setTag:1];
    [segMentCtrl setSelectionIndicatorMode:HMSelectionIndicatorFillsSegment];
    segMentCtrl.selectedIndex = 0;
    [self.view addSubview:segMentCtrl];

    
    
    newTaskView = [[NewTaskViewController alloc]init];
    [self addChildViewController:newTaskView];
    unuploadView = [[UnUpLoadViewController alloc]init];
    [self addChildViewController:unuploadView];
    sendBackView = [[SendBackViewController alloc]init];
    [self addChildViewController:sendBackView];
    newTaskView.view.frame = CGRectMake(0,segMentCtrl.frame.origin.y + segMentCtrl.frame.size.height, WIDTH, HEIGHT - segMentCtrl.frame.origin.y - segMentCtrl.frame.size.height);
    [self.view addSubview:newTaskView.view];
    self.mOldController = newTaskView;
}
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segCtrl {
	NSLog(@"Selected index %i (via UIControlEventValueChanged)", segCtrl.selectedIndex);
    self.mNewController = [self.childViewControllers objectAtIndex:segCtrl.selectedIndex];
    self.mNewController.view.frame = CGRectMake(0, segCtrl.frame.origin.y + segCtrl.frame.size.height, 320, HEIGHT - segCtrl.frame.origin.y - segCtrl.frame.size.height);
    [self transitionFromViewController:self.mOldController toViewController:self.mNewController duration:0.35 options:UIViewAnimationOptionCurveEaseIn animations:nil completion:nil];
    [segCtrl setTextColor:[UIColor colorWithRed:48/255.0 green:186/255.0 blue:213/255.0 alpha:1]];
    self.mOldController =self.mNewController;
    switch (segCtrl.selectedIndex)
    {
        case 0:
            [self.rightBtn setTitle:@"同步" forState:UIControlStateNormal];
            break;
        case 1:
            [self.rightBtn setTitle:@"全部上传" forState:UIControlStateNormal];
            break;
        case 2:
            [self.rightBtn setTitle:@"重采" forState:UIControlStateNormal];
            break;
        default:
            break;
    }

}
-(void)segCtrlEvent:(UISegmentedControl *)segCtrl
{
    self.mNewController = [self.childViewControllers objectAtIndex:segCtrl.selectedSegmentIndex];
    self.mNewController.view.frame = CGRectMake(0, segCtrl.frame.origin.y + segCtrl.frame.size.height, 320, HEIGHT - segCtrl.frame.origin.y - segCtrl.frame.size.height);
    [self transitionFromViewController:self.mOldController toViewController:self.mNewController duration:0.35 options:UIViewAnimationOptionCurveEaseIn animations:nil completion:nil];
    self.mOldController =self.mNewController;
    switch (segCtrl.selectedSegmentIndex)
    {
        case 0:
            [self.rightBtn setTitle:@"同步" forState:UIControlStateNormal];
            break;
        case 1:
            [self.rightBtn setTitle:@"全部上传" forState:UIControlStateNormal];
            break;
        case 2:
            [self.rightBtn setTitle:@"重采" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (void)makeView
{
    lyhTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    lyhTableView.dataSource = self;
    lyhTableView.delegate = self;
    [self.view addSubview:lyhTableView];
}
#pragma mark - UITableViewDelegate的代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}
#pragma mark - UITableViewDataSource的代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * strID = @"ID";
    TaskCell * cell = [tableView dequeueReusableCellWithIdentifier:strID];
    if (!cell) {
        cell = [[TaskCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
    }
    cell.mTitleLabel.text = @"要素名称:龙王庙桥";
    cell.mCodeLabel.text = @"要素代码:G123456";
    cell.mZHLabel.text = @"中心桩号:1234";
    return cell;
}


#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
