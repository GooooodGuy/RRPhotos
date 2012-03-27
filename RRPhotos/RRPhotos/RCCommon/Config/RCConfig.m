//
//  RCConfig.m
//  RenrenCore
//
//  Created by Sun Cloud on 6/1/11.
//  Copyright 2011 www.renren.com. All rights reserved.
//

#import "RCConfig.h"
#import "UIDevice+UIDeviceExt.h"
#import "NSString+NSStringEx.h"

static RCConfig *_globalConfig = nil;
@implementation RCConfig

@synthesize opApiKey = _opApiKey;
@synthesize opApiUrl = _opApiUrl;
@synthesize opAppId = _opAppId;
@synthesize mApiUrl = _mApiUrl;
@synthesize opSecretKey = _opSecretKey;
@synthesize opLoginUrl = _opLoginUrl;
@synthesize clientName = _clientName;
@synthesize version = _version;
@synthesize fromType = _fromType;
@synthesize fromID = _fromID;
@synthesize model = _model;
@synthesize clientInfoJSONString = _clientInfoJSONString;
@synthesize imgConvertUrl = _imgConvertUrl;
@synthesize imageCachePath = _imageCachePath;
@synthesize emotionsPath = _emotionsPath;
@synthesize databasePath = _databasePath;
@synthesize pubdate = _pubdate;
@synthesize configFilePath = _configFilePath;
@synthesize registerUrl = _registerUrl;

@synthesize httpTimeout = _httpTimeout;
@synthesize chatHostUrl = _chatHostUrl;
@synthesize findPeopleUrl = _findPeopleUrl;
@synthesize appId = _appId;
@synthesize appStoreId = _appStoreId;

@synthesize appHomepageUrl=_appHomepageUrl;
@synthesize dataVersion = _dataVersion; // 数据库文件
@synthesize fromPolistHtf = _fromPolistHtf;
@synthesize fromMinifeedHtf = _fromMinifeedHtf;
@synthesize fromNewsfeedHtf = _fromNewsfeedHtf;
@synthesize fromHomeListHtf = _fromHomeListHtf;
@synthesize fromStatusMinifeedHtf = _fromStatusMinifeedHtf;
@synthesize fromStatusNewsfeedHtf = _fromStatusNewsfeedHtf;

@synthesize chatServerVersion = _chatServerVersion;

- (void)dealloc
{
    [_appId release];
    [_appStoreId release];
    [_opApiKey release];
    [_opApiUrl release];
    [_opAppId release];
    [_mApiUrl release];
    [_opSecretKey release];
    [_opLoginUrl release];
    [_clientName release];
    [_version release];
    [_fromType release];
    [_fromID release];
    [_model release];
    [_clientInfoJSONString release];
    [_imgConvertUrl release];
    [_imageCachePath release];
    [_emotionsPath release];
    [_databasePath release];
    [_pubdate release];
    [_configFilePath release];
    [_registerUrl release];
    [_chatHostUrl release];
    [_findPeopleUrl release];
    [_fromPolistHtf release];
	[_fromMinifeedHtf release];
	[_fromNewsfeedHtf release];
	[_fromHomeListHtf release];
	[_fromStatusMinifeedHtf release];
	[_fromStatusNewsfeedHtf release];
    self.chatServerVersion = nil;
    
    [super dealloc];
}

- (id)init {
    self = [super init]; 
    if (self) {
       // self.opApiKey = @"04ada73d2e1040d3a0cb0d9c4f8daadb"; // 3.0 
        self.opApiKey = @"982f1025964b461099ac889453b700d1";   // iPhone 4.0 2011-08-08
        self.opApiUrl = @"http://m3.api.renren.com/restserver.do";
        
        //self.mApiUrl = @"http://mc1.test.renren.com/api";//开发服务器
        //self.mApiUrl = @"http://m1.apis.tk/api";
        //self.mApiUrl = @"http://stage.apis.tk/api"; // 定版服务器
        self.mApiUrl = @"http://api.m.renren.com/api";//正式服务器
        //self.mApiUrl = @"http://mc1.test.renren.com/api";
        //self.opSecretKey = @"6f67620dddb24c668607d8cbf1f37a85";
        self.opSecretKey = @"91110a41072e4d0bac3ac05a547f3ece"; // iPhone 4.0 2011-08-08
        
        //self.opLoginUrl = @"http://stage.apis.tk/api";
        self.opLoginUrl = @"http://login.api.renren.com/CL.do";
        //self.opLoginUrl = @"http://m1.apis.tk/api";
        
       // self.clientName = @"xiaonei_iPad";
       // self.version = @"1.0.0";
       // self.fromType = @"2000505";
        self.fromType = @"9100301";
        self.fromID = self.fromType;
       // self.model = @"iPad";
       // self.pubdate = @"20101223";
        self.pubdate = @"20111101";
        self.imgConvertUrl = @"http://ic.m.renren.com";
        
        self.version = @"4.0.1"; // 版本号必须保持三位的格式
        self.clientName = @"xiaonei_iphone";
        self.model = @"iphone";
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];
        // 图片缓存的路径
        self.imageCachePath = [docDir stringByAppendingPathComponent:@"imageCache"];
        
        // Path for cache database file
        self.databasePath = [docDir stringByAppendingPathComponent:@"cachedb.sql"];
        
        // 数据版本
        self.dataVersion = 1;
        
        self.configFilePath = [docDir stringByAppendingPathComponent:@"renren.plist"];
        // 表情路径
        self.emotionsPath = [docDir stringByAppendingPathComponent:@"emotions"];
        
        self.httpTimeout = 45;
        // 线上聊天服务
        //self.chatHostUrl = @"talk.m.renren.com";//@"111.13.4.34";////@"talk.apis.tk";//@"123.125.47.15";
        // 测试聊天服务
        self.chatHostUrl = @"talk.apis.tk";
        
        self.findPeopleUrl = @"http://mt.renren.com/client/search";// 搜索好友地址
        
        self.appHomepageUrl = @"http://3gapp.renren.com/access"; // 正式应用新域名
        
        /*
         报到poilist进入POI终端页：htf=184
         报到产生的个人主页的新鲜事(minifeed)进入POI终端页：htf=185
         报到产生的新鲜事（newsfeed）进入POI终端页：htf=186
         位置首页附近好友的feed进入POI终端页：htf=187
         状态带位置产生的个人主页的新鲜事(minifeed)进入POI终端页：htf=194
         状态带位置产生的新鲜事(newsfeed)进入POI终端页：htf=195
         */
        self.fromPolistHtf = @"184";
        self.fromMinifeedHtf = @"185";
        self.fromNewsfeedHtf = @"186";
        self.fromHomeListHtf = @"187";
        self.fromStatusMinifeedHtf = @"194";
        self.fromStatusNewsfeedHtf = @"195";
        
        // 聊天服务器版本
        self.chatServerVersion = @"5";
        
    }
    return self;
}
- (NSString *)userAgent {
    return [NSString stringWithFormat:@"%@%@", self.clientName, self.version];
}
- (NSString *)udid {
    UIDevice *device = [UIDevice currentDevice];
    NSString *udid = device.uniqueIdentifier;

    if (!udid) {
        udid = [[device macaddress] md5];
    }
    if (!udid) {
        udid = @"";
    }
    return udid;
}
- (NSString *)clientInfoJSONString {
    UIDevice *device = [UIDevice currentDevice];
	if([device.model hasPrefix:@"iPad"])
    {
        return [NSString stringWithFormat:@"{\"model\":\"%@\", \"os\":\"%@%@\", \"uniqid\":\"%@\", \"screen\":\"768x1024\", \"font\":\"system 12\", \"ua\":\"%@\", \"from\":\"%@\", \"version\":\"%@\"}",
                device.model, device.systemName, device.systemVersion, [self udid], [self userAgent], self.fromID, self.version];
    }
	return [NSString stringWithFormat:@"{\"model\":\"%@\", \"os\":\"%@%@\", \"uniqid\":\"%@\", \"screen\":\"320x480\", \"font\":\"system 12\", \"ua\":\"%@%@\", \"from\":\"%@\", \"version\":\"%@\"}",
			device.model, device.systemName, device.systemVersion, [self udid], self.clientName, self.version, self.fromID, self.version];

}
+ (RCConfig* )globalConfig {
    if(!_globalConfig) {
        _globalConfig = [[RCConfig alloc] init];
    }
    
    return _globalConfig;
    
}
+ (void)setGlobalConfig:(RCConfig *)config {
    if (_globalConfig != config) {
        [_globalConfig release];
        _globalConfig = [config retain];
    }
}
@end
