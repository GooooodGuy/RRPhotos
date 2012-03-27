//
//  RCMainUser.h
//  RRSpring
//
//  Created by yusheng.wu  on 12-2-20.
//  Copyright (c) 2012年 Renn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCUser.h"

@interface RCMainUser : RCUser<NSCoding> {
	
	BOOL isFirst;
	
	/**
     * 表示登录时填写的登录帐号。
	 */
	NSString* _loginAccount;
	
	/**
     * 表示登录时填写的登录密码。
	 */
    //	NSString* _loginPassword;
	
	/**
     * 表示人人开放平台的ticket。登录人人开放平台成功后获得。
	 */
	NSString* _ticket;
	
	/**
     * 表示3G手机开放平台的ticket。登录3G手机开放平台成功后获得。
	 */
	NSString* _mticket;
	
    /**
     * 表示人人开放平台的session key。登录人人开放平台成功后获得。
     */
	NSString* _sessionKey;
	
    /**
     * 表示3G手机开放平台的session key。登录3G手机开放平台成功后获得。
     */
	NSString* _msessionKey;
	
    /**
     * 表示3G手机开放平台的private secret key。登录3G手机开放平台成功后获得。
     */
	NSString* _mprivateSecretKey;
	
	// 表示经过md5加密的password。
	NSString* _md5Password;
	
	// 表示当前登录用户的状态。
    //RRLoginStatus _loginStatus;
	
	BOOL checkFriendList;
	
	double lastLoginDate;
	
	// 在一次刷新操作中请求的新鲜事条数
	int requestNewsfeedCount;
	
	// 在一次刷新操作中请求的站内信条数
	int requestMessageCount;
	
	// 心跳次数.
	int _heartBeatCount;
	
	// 头像相册ID
	NSString *headAlbumID;
	
	CFURLRef soundFileURLRef;
	
	//SystemSoundID soundFileObject;
	
	BOOL isSavingFriendsList;
	
	//RRLoginModel *_loginModel;
    
    BOOL checkFavourite;
    
    // check信用户完善资料
    BOOL _checkIsNewUser;
    
    /**
     *聊天时所需要的会话ID,登录后可以取得
     */
    NSString *_sessionId;
    
    float _keyboardY;
    BOOL cannotGoProfile;
    BOOL fromNoTudou;
    
}
/**
 * 表示当前登录用户的状态。
 */
//@property RRLoginStatus loginStatus;

/**
 * 表示登录时填写的登录帐号。
 */
@property (copy)NSString* loginAccount;

/**
 * 表示登录时填写的登录密码。
 */
//@property (copy)NSString* loginPassword;

/**
 * 表示人人开放平台的ticket。登录人人开放平台成功后获得。
 */
@property (copy)NSString* ticket;

/**
 * 表示3G手机开放平台的ticket。登录3G手机开放平台成功后获得。
 */
@property (copy)NSString* mticket;

/**
 * 表示人人开放平台的session key。登录人人开放平台成功后获得。
 */
@property (copy)NSString* sessionKey;

/**
 * 表示3G手机开放平台的session key。登录3G手机开放平台成功后获得。
 */
@property (copy)NSString* msessionKey;

/**
 * 表示3G手机开放平台的private secret key。登录3G手机开放平台成功后获得。
 */
@property (copy)NSString* mprivateSecretKey;

@property (copy) NSString* md5Password;

@property (copy) NSString* headAlbumID;

@property double lastLoginDate;

@property BOOL checkFriendList;

@property BOOL checkFavourite;

@property BOOL checkIsNewUser;

@property (copy) NSString *sessionId;

@property (readwrite)	CFURLRef		soundFileURLRef;
//@property (readonly)	SystemSoundID	soundFileObject;
//@property (copy)NSString *fillStageStr;
@property float keyboardY;
@property BOOL cannotGoProfile;
@property BOOL fromNoTudou;
#pragma mark -
#pragma mark Public

/**
 * 持久化存档。
 */
- (void)persist;

/**
 * 创建一个Main User对象.
 * 首先从持久化层.初始化,如果没有的话,那么直接生成新的对象.
 */
+ (RCMainUser*)getInstance;

/**
 * 登出动作，仅修改了MainUser的状态和数值。
 */
- (void)logout;

/**
 * 清空MainUser对象数据。一般在切换登录用户时，或者登出时使用。
 */
- (void) clear;

/**
 * 判断是否为登录用户的id.
 * 
 * @param userId 被判断的用户id
 * @return 如果是登录用户,返回TRUE,否则返回FALSE.
 */
- (BOOL)isMainUserId:(NSNumber*)userId;

//- (void) updateStatus:(NSString*)content;

// users中的元素必须是XNUser的实例
//- (void) sendMultiMessages:(NSString*)theTitle 
//				   content:(NSString*)theContent 
//				   toUsers:(NSArray*)users;

// 后台登录
//- (void) daemonLogin;


- (BOOL) checkLoginInfo;

//- (void) _checkNewXNData;

//- (void) saveDeviceInfoIfNeeded;
//- (void) saveTokenIsSentFlag:(BOOL)isSent;
//
//
//// 保存Token是否发出的标志位
//- (void) saveTokenIsSentFlag:(BOOL)isSent;
//
//- (BOOL)isTokenIsSentToServer;
//
///**
// * 
// */
//- (void)handleMultiLogin;

@end

