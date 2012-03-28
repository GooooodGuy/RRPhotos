//
//  RNModel.h
//  RRSpring
//
//  Created by hai zhang on 3/6/12.
//  Copyright (c) 2012 RenRen.com. All rights reserved.
//

#import <Foundation/Foundation.h>

// model协议，用于viewController回调
@class RNModel;
@protocol RNModelDelegate <NSObject>

@optional
// 开始
- (void)modelDidStartLoad:(RNModel *)model;
// 完成
- (void)modelDidFinishLoad:(RNModel *)model;
// 错误处理
- (void)model:(RNModel *)model didFailLoadWithError:(RCError *)error;
// 取消
- (void)modelDidCancelLoad:(RNModel *)model;


@end


#pragma mark - RNModel
@interface RNModel : NSObject {
    // 网络请求的必要参数
    NSMutableDictionary *_query;
    // 网络请求的方法名
    NSString *_method;
    // 批处理
    NSMutableArray *_delegates;
    // 网络请求qequest对象
    RCBaseRequest *_request;
    // 返回数据为字典
    NSDictionary *_resultDic;
    // 返回数据为数组
    NSArray *_resultAry;
    // is load more
    BOOL _isMore;
}


/*
 * 发送网络请求
 *
 * @more 是否加载更多
 */
- (void)load:(BOOL)more;


@property (nonatomic, retain) NSMutableDictionary *query;
@property (nonatomic, copy) NSString *method;
@property (nonatomic, retain) NSMutableArray *delegates;
@property (nonatomic, retain) RCBaseRequest *request;
@property (nonatomic, retain) NSDictionary *resultDic;
@property (nonatomic, retain) NSArray *resultAry;
@property (nonatomic, assign) BOOL isMore;

@end
