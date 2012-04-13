//
//  RNPageModel.h
//  RRSpring
//
//  Created by sheng siglea on 4/6/12.
//  Copyright (c) 2012 RenRen.com. All rights reserved.
//

#import "RNModel.h"

@interface RNPageModel : RNModel{
    /**
     * 分页列表数据项
     */
	NSMutableArray* _items;	
	/**
	 * 表示每一页大小.
	 */
	NSInteger _pageSize;
	/**
	 * 表示当前页索引.
	 */
	NSInteger _currentPageIndex;
    /**
     * 数据总数
     */
    NSInteger _totalItem;
    /**
     * 总页数
     */
    NSInteger _totalPage;
}

@property (nonatomic, retain) NSMutableArray* items;
@property (nonatomic, assign)NSInteger pageSize;
@property (nonatomic, assign)NSInteger currentPageIndex;
@property (nonatomic, assign,readonly)NSInteger totalPage;
@property (nonatomic, assign) NSInteger totalItem;

@end
