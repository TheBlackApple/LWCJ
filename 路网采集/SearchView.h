//
//  SearchView.h
//  路网采集
//
//  Created by Charles Leo on 14-10-16.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchView;
@protocol SearchViewDelegate <NSObject>

-(void)searchView:(SearchView *)search text:(NSString *)text;

@end
@interface SearchView : UIView <UITextFieldDelegate>
@property (assign,nonatomic) id<SearchViewDelegate> delegate;
@end
