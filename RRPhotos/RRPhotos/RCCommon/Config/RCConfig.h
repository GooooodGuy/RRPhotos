//
//  RCConfig.h
//  RenrenCore
//
//  Created by Sun Cloud on 6/1/11.
//  Copyright 2011 www.renren.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RRConfigDelegate.h"


@interface RCConfig : NSObject <RRConfigDelegate> {
    // app id
    NSString *_appId;

    /**
     *本应用在appStore的ID
     */
    NSString* _appStoreId;
    
    // Client name.
    NSString *_clientName;
    
    // 3G API URL
    NSString *_mApiUrl;
    
    // Open Platform API Key
    NSString *_opApiKey;
    
    // Open Platform API URL
    NSString *_opApiUrl;
    
    // Open Platform APP ID.
    NSString *_opAppId;
    
    // Open Platform 登录接口地址
    NSString *_opLoginUrl;
    
    // Open Platform Secret Key
    NSString *_opSecretKey;
    // Client version.
    NSString *_version;
    
    // Client fromType.
    NSString *_fromType;
    
    // Client fromID.
    NSString *_fromID;
    
    // Device model.
    NSString *_model;
    
    // Client Info.
    NSString *_clientInfoJSONString;
    
    NSString *_imgConvertUrl;
    
    NSString *_imageCachePath;
    
    NSString *_emotionsPath;
    
    NSString *_databasePath;
    
    NSString *_pubdate;
    NSString *_configFilePath;
    NSString *_registerUrl;
    
    // http请求超时时间
	NSUInteger _httpTimeout;
    NSString* _chatHostUrl;
    
    //搜索好友地址
    NSString *_findPeopleUrl;
    
    NSString *_appHomepageUrl;
    
    NSInteger _dataVersion;
    
    // POI
    NSString* _fromPolistHtf;
	NSString* _fromMinifeedHtf;
	NSString* _fromNewsfeedHtf;
	NSString* _fromHomeListHtf;
	NSString* _fromStatusMinifeedHtf;
	NSString* _fromStatusNewsfeedHtf;
    
    // 聊天服务器版本
    NSString *_chatServerVersion;

}

+ (RCConfig* )globalConfig;
+ (void)setGlobalConfig:(RCConfig *)config;
- (NSString *)userAgent;

/**
 * @return 设备唯一标识。如果UIDevice.uniqueIdentifier不为空，那么返回uniqueIdentifier，否则返回MacAddress的md5。
 */
- (NSString *)udid;
// app id
@property (nonatomic, copy) NSString *appId;
// 本应用在appStore的ID
@property (nonatomic, copy) NSString* appStoreId;
// Open Platform API Key
@property (nonatomic, copy) NSString *registerUrl;
// Open Platform API Key
@property (nonatomic, copy) NSString *configFilePath;

// Open Platform API Key
@property (nonatomic, copy) NSString *pubdate;

// Open Platform API Key
@property (nonatomic, copy) NSString *emotionsPath;

// Open Platform API Key
@property (nonatomic, copy) NSString *imageCachePath;

// Open Platform API Key
@property (nonatomic, copy) NSString *opApiKey;

// Open Platform API URL
@property (nonatomic, copy) NSString *opApiUrl;

// Open Platform APP ID.
@property (nonatomic, copy) NSString *opAppId;

// 3G API URL
@property (nonatomic, copy) NSString *mApiUrl;

// Open Platform Secret Key
@property (nonatomic, copy) NSString *opSecretKey;

// Open Platform 登录接口地址
@property (nonatomic, copy) NSString *opLoginUrl;

// Client name.
@property (nonatomic, copy) NSString *clientName;

// Client version.
@property (nonatomic, copy) NSString *version;

// Client fromType.
@property (nonatomic, copy) NSString *fromType;

// Client fromID.
@property (nonatomic, copy) NSString *fromID;

// Device model.
@property (nonatomic, copy) NSString *model;

// Client Info.
@property (nonatomic, readonly) NSString *clientInfoJSONString;

// 聊天服务器版本
@property (nonatomic, copy) NSString *chatServerVersion;

@property (nonatomic, copy) NSString *imgConvertUrl;
@property (nonatomic, copy) NSString *databasePath;

@property (assign) NSUInteger httpTimeout;
@property (nonatomic, copy) NSString *chatHostUrl;

@property (nonatomic, copy) NSString *findPeopleUrl;
@property (nonatomic, copy) NSString *appHomepageUrl;
@property (nonatomic) NSInteger dataVersion;

@property (nonatomic, copy) NSString* fromPolistHtf;
@property (nonatomic, copy) NSString* fromMinifeedHtf;
@property (nonatomic, copy) NSString* fromNewsfeedHtf;
@property (nonatomic, copy) NSString* fromHomeListHtf;
@property (nonatomic, copy) NSString* fromStatusMinifeedHtf;
@property (nonatomic, copy) NSString* fromStatusNewsfeedHtf;

@end
