//
//  RNBaseViewController.h
//  RRPhotos
//
//  Created by yi chen on 12-3-27.
//  Copyright (c) 2012年 renren. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface RNBaseViewController : UIViewController {
    RCBaseRequest *_requestAssistant;
}

@property(nonatomic, retain)RCBaseRequest *requestAssistant;
- (id)initWithObjects:(NSArray *)objects;

//发送网络请求
- (void)sendQueryWithDic:(NSDictionary *)dic andMethod:(NSString *)method;
//网络请求成功
- (void)requestDidSucceed:(NSDictionary *)result;
//网络请求失败
- (void)requestDidError:(RCError *)error;

@end
