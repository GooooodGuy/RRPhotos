//
//  RCMainUser.m
//  RRSpring
//
//  Created by yusheng.wu on 12-2-20.
//  Copyright (c) 2012年 Renn. All rights reserved.
//

#import "RCMainUser.h"

@interface RCMainUser (Private)

@end

static RCMainUser* _instance = nil;

@implementation RCMainUser

@synthesize loginAccount = _loginAccount;
//@synthesize loginPassword = _loginPassword;
@synthesize ticket = _ticket;
@synthesize mticket = _mticket;
@synthesize sessionKey = _sessionKey;
@synthesize msessionKey = _msessionKey;
@synthesize mprivateSecretKey = _mprivateSecretKey;
@synthesize md5Password = _md5Password;
//@synthesize loginStatus = _loginStatus;
@synthesize checkFriendList;
@synthesize lastLoginDate;

@synthesize headAlbumID;
//@synthesize soundFileObject;
@synthesize soundFileURLRef;
@synthesize checkFavourite;
@synthesize checkIsNewUser = _checkIsNewUser;
@synthesize sessionId = _sessionId;
@synthesize keyboardY = _keyboardY;
@synthesize cannotGoProfile,fromNoTudou;

+ (RCMainUser *) getInstance {
	@synchronized(self) {
        
		if (_instance == nil) {
            // 看是否有最近的登录用户Id
            //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            //NSNumber *userId = [defaults objectForKey:kLastLoginUserId];
            NSNumber *userId = nil;
            //NSString *userIdStr = [userId stringValue];
            if (userId) {
                //_instance = [(RCMainUser *)RR_PERSIST_GETOBJECT_WITH_USER_ID(kLoginUserKey, userId) retain];
                if (!_instance) {
                    [[RCMainUser alloc] init]; // assignment not done here
                    
                }
            } else {
                [[RCMainUser alloc] init];
            }
            
		}
	}
	return _instance;
}

+ (id) allocWithZone:(NSZone*) zone {
	@synchronized(self) {
		if (_instance == nil) {
			_instance = [super allocWithZone:zone];  // assignment and return on first allocation
			return _instance;
		}
	}
	return nil;
}

- (id) copyWithZone:(NSZone*) zone {
	return _instance;
}

- (id) retain {
	return _instance;
}

- (unsigned) retainCount {
	return UINT_MAX;  //denotes an object that cannot be released
}

- (oneway void) release {
	// do nothing
}

- (id) autorelease {
	return self;
}

- (id) init
{
	if (self = [super init]){
        //self.loginStatus = RRLoginStatusNotLogin;
        
        // Get the main bundle for the app
        CFBundleRef mainBundle;
        mainBundle = CFBundleGetMainBundle ();
        
        // Get the URL to the sound file to play
        soundFileURLRef  =	CFBundleCopyResourceURL (
                                                     mainBundle,
                                                     CFSTR ("sub"),
                                                     CFSTR ("caf"),
                                                     NULL
                                                     );
        
        // Create a system sound object representing the sound file
//        AudioServicesCreateSystemSoundID (
//                                          soundFileURLRef,
//                                          &soundFileObject
//                                          );
        
        [self clear];
        self.userId = [NSNumber numberWithInt:0];
        self.keyboardY = 200;
        self.cannotGoProfile = NO;
	}
	return self;
}


- (void) dealloc
{
    TT_RELEASE_SAFELY(_loginAccount);
    //	TT_RELEASE_SAFELY(_loginPassword);
    TT_RELEASE_SAFELY(_ticket);
	TT_RELEASE_SAFELY(_mticket);
    TT_RELEASE_SAFELY(_sessionKey);
    TT_RELEASE_SAFELY(_msessionKey);
    TT_RELEASE_SAFELY(_mprivateSecretKey);
	TT_RELEASE_SAFELY(_md5Password);
	[headAlbumID release];
	//TT_RELEASE_SAFELY(_loginModel);
	
	[super dealloc];
}



- (void) clear
{
	//self.loginStatus = RRLoginStatusNotLogin;
	self.ticket = nil;
    self.mticket = nil;
	
	self.sessionKey = nil;
	self.msessionKey = nil;
	self.mprivateSecretKey = nil;
	
    //	self.loginPassword = nil;
	self.md5Password = nil;
	
	self.headAlbumID = nil;
    
	self.checkFriendList = NO;
	self.lastLoginDate = 0.0;
    // RRUser数据清空
	//self.userId = 0;
    self.userName = nil;
    self.networkName = nil;
    //self.birthday = nil;
    self.tinyurl = nil;
    self.headurl = nil;
	isFirst = YES;
	
	isSavingFriendsList = NO;
    // 清空新用户引导判断
    self.checkIsNewUser = NO;
    // MainUser是被持久化的，如果新添加了成员一定要在注销时干掉它
    self.sessionId = nil;
    
}

#pragma mark -
#pragma mark Public
- (void)persist {
//	NSNumber *userId = self.userId;
	
//	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//	[defaults setObject:userId forKey:kLastLoginUserId];
//	
//	if (userId) {
//		RR_PERSIST_SETOBJECT_WITH_USER_ID(kLoginUserKey, self, userId);
//	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)login:(NSString*)name password:(NSString*)pwd {
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)logout {
	RCMainUser *mainUser = [RCMainUser getInstance];
    //mainUser.loginStatus = RRLoginStatusNotLogin;
	[mainUser clear];
	[mainUser persist];
    //[mainUser invalidate:YES];
	
	// 删去最后登录用户记录
	//NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	//[defaults removeObjectForKey:kLastLoginUserId];
}

- (BOOL) isMainUser
{
	return YES;
}


- (BOOL)isMainUserId:(NSNumber*)anUserId {
	// 在没有id的情况的, 将默认是mainuser
	if (!anUserId) {
		return TRUE;
	}
	
	if (!self.userId) {
		return FALSE;
	}
	
	return NSOrderedSame == [self.userId compare:anUserId] ? TRUE : FALSE;
}
#pragma mark -
#pragma mark push notification methods
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)openPushNotification{
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeNone|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound];
}

#pragma mark -
#pragma mark NSCoding methods
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super initWithCoder:decoder]) {
        // 设置为未登录状态。
		//self.loginStatus = RRLoginStatusNotLogin;
		
		self.ticket = [decoder decodeObjectForKey:@"ticket"];
		self.mticket = [decoder decodeObjectForKey:@"mticket"];
		
		self.sessionKey = [decoder decodeObjectForKey:@"sessionKey"];
		self.msessionKey = [decoder decodeObjectForKey:@"msessionKey"];
		
		self.mprivateSecretKey = [decoder decodeObjectForKey:@"mprivateSecretKey"];
		
		self.loginAccount = [decoder decodeObjectForKey:@"loginAccount"];
		self.md5Password = [decoder decodeObjectForKey:@"md5Password"];
        //		self.loginPassword = [decoder decodeObjectForKey:@"loginPassword"];
        
        self.checkIsNewUser = [decoder decodeBoolForKey:@"checkIsNewUser"];
	}
	return self;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)encodeWithCoder:(NSCoder*)encoder {
	[super encodeWithCoder:encoder];
    
	[encoder encodeObject:self.loginAccount forKey:@"loginAccount"];
    //	[encoder encodeObject:self.loginPassword forKey:@"loginPassword"];
	[encoder encodeObject:self.md5Password forKey:@"md5Password"];
	
	[encoder encodeObject:self.ticket forKey:@"ticket"];
	[encoder encodeObject:self.mticket forKey:@"mticket"];
	
	[encoder encodeObject:self.sessionKey forKey:@"sessionKey"];
	[encoder encodeObject:self.msessionKey forKey:@"msessionKey"];
	
	[encoder encodeObject:self.mprivateSecretKey forKey:@"mprivateSecretKey"];
    
    [encoder encodeBool:self.checkIsNewUser forKey:@"checkIsNewUser"];
}
#pragma mark -
#pragma mark TTModel methods
///////////////////////////////////////////////////////////////////////////////////////////////////
//- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
//    if (!self.isLoading) {
//        // 准备登录
//        if (RRLoginStatusWillLogin == self.loginStatus) {
//            
//        }
//    }
//    [super load:cachePolicy more:more];
//}
/////////////////////////////////////////////////////////////////////////////////////////////////////
//- (void)requestDidFinishLoad:(TTURLRequest*)request {
//	[super requestDidFinishLoad:request];
//    
//    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//    [nc postNotificationName:NN_USER_INFO_DID_LOAD object:self];
//    
//    // Persist user.
//    RRMainUser *mainUser = self;
//    NSNumber *userId = mainUser.userId;
//    RR_PERSIST_SETOBJECT_WITH_USER_ID(kLoginUserKey, mainUser, userId);
//}


- (BOOL) checkLoginInfo
{
	//double per = fabs([NSDate timeIntervalSinceReferenceDate] - self.lastLoginDate);
	if (self.msessionKey && self.mprivateSecretKey) {
		
		return YES;
	}
	
	return NO;
}


@end
