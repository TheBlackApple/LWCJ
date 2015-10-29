//
//  TaskModel.h
//  路网采集
//
//  Created by Charles Leo on 14/10/20.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface TaskModel : NSObject

@property (strong,nonatomic) NSString * mLayer;//类型
@property (strong,nonatomic) NSString * mName;//要素名称
@property (strong,nonatomic) NSString * mLineName;//路线名称
@property (strong,nonatomic) NSString * mDeadLine;//截止日期
@property (strong,nonatomic) NSString * mCode;//要素代码
@property (strong,nonatomic) NSString * mPos;//中心桩号
@property (strong,nonatomic) NSString * mLineCode;//路线代码
@property (strong,nonatomic) NSString * mId; //任务编号
@property (strong,nonatomic) NSString * mType; //0-沿线设施 1-主要构造物 2-路线

@property (strong,nonatomic) NSString * mGatherTime;//采集时间
@property (strong,nonatomic) NSString * mGather;//采集人
@property (strong,nonatomic) NSString * mState;//1-未采集 2-已采集 3-重采 4- 被退回
@property (strong,nonatomic) NSData * mImageData;//图片
@property (strong,nonatomic) NSData * mShape;//空间数据
@property (strong,nonatomic) NSString * mStartPos;//起点桩号
@property (strong,nonatomic) NSString * mEndPos;//终点桩号
@property (strong,nonatomic) NSString * mAuditState;//0-未上报1-已上报 2-审核通过 3-审核未通过
@property (strong,nonatomic) NSString * mAuditExplain;//审核未通过原因
@property (strong,nonatomic) NSString * mAddress;//地址
@property (assign,nonatomic) double  mPtx;//当前经度
@property (assign,nonatomic) double  mPty;//当前维度


@end
