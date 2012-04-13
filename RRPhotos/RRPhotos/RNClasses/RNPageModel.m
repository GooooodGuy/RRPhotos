//
//  RNPageModel.m
//  RRSpring
//
//  Created by sheng siglea on 4/6/12.
//  Copyright (c) 2012 RenRen.com. All rights reserved.
//

#import "RNPageModel.h"

@implementation RNPageModel

@synthesize items = _items;
@synthesize pageSize = _pageSize;
@synthesize currentPageIndex = _currentPageIndex;
@synthesize totalItem = _totalItem;
@synthesize totalPage = _totalPage;

- (void)dealloc{
    self.items = nil;
    [super dealloc];
}
- (void)load:(BOOL)more {
    if (self.method == nil) {
        return;
    }
    if (more) {
        self.currentPageIndex ++;
    }else {
        self.currentPageIndex = 1;
        self.totalItem = 0;
        [self.items removeAllObjects];
    }
    [_query setObject:[NSNumber numberWithInteger:self.currentPageIndex] forKey:@"page"];
    [_request sendQuery:_query withMethod:_method];
    [self didStartLoad];
}

- (void)didFinishLoad:(id)result{
//    在子类中实现
//    self.result = result;
//    self.totalItem = [result intForKey:@"count" withDefault:0];
//    self.title = [result stringForKey:@"album_name" withDefault:@""];
//    _totalPage = (self.totalItem + self.pageSize - 1)/self.pageSize;  
}
@end
