//
//  RNHotShareContentViewController.m
//  RRPhotos
//
//  Created by yi chen on 12-5-14.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "RNHotShareContentViewController.h"

@interface RNHotShareContentViewController ()

@end

@implementation RNHotShareContentViewController
@synthesize hotShareItem = _hotShareItem;
@synthesize albumIconView = _albumIconView;
@synthesize commentTableView = _commentTableView;
@synthesize miniPublisherView = _miniPublisherView;

- (void)dealloc{
	self.hotShareItem = nil;
	self.albumIconView = nil;
	self.commentTableView = nil;
	self.miniPublisherView = nil;
	[super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithHotShareItem:(RNHotShareItem *)item{
	if (item) {
		self.hotShareItem = item;
	}
	if (self = [super init]) {
		
	}
	return self;
}

/*
	请求照片数据，评论列表等
 */
- (void)requestPhotoData{
	if (!self.hotShareItem) {
		return;
	}
	RCMainUser *mainUser = [RCMainUser getInstance];
	NSMutableDictionary* dics = [NSMutableDictionary dictionary];
	[dics setObject:mainUser.sessionKey forKey:@"session_key"];
	
	if (self.hotShareItem.ownerId) {
		[dics setObject:self.hotShareItem.ownerId forKey:@"uid"];
	}
	if (self.hotShareItem.sourceId) {
		[dics setObject:self.hotShareItem.sourceId forKey:@"aid"];
	}
	
	RCGeneralRequestAssistant *mReqAssistant = [RCGeneralRequestAssistant requestAssistant];
	mReqAssistant.onCompletion = ^(NSDictionary* result){
		NSLog(@"photo ... %@",result);
		if (result) {
			
		}
	};
	mReqAssistant.onError = ^(RCError* error) {
		NSLog(@"req error :%@",error);
	};
//	[mReqAssistant sendQuery:dics withMethod:@"photos/get"]; //获取相册内容
	[mReqAssistant sendQuery:dics withMethod:@"photos/getComments"];

	//获取分享用户的相关信息，如头像地址等
	
}

- (void)loadView{
	[super loadView];
	
	[self requestPhotoData];
	[self.view addSubview:self.albumIconView];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
	self.albumIconView = nil;
	self.commentTableView = nil;
	self.miniPublisherView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/*
	相册的缩略图
 */
- (UIImageView *)albumIconView {
	if (!_albumIconView) {
		_albumIconView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 
																	 PHONE_SCREEN_SIZE.width - 10,
																	  PHONE_SCREEN_SIZE.width - 10)];
		_albumIconView.backgroundColor = [UIColor clearColor];
		_albumIconView.contentMode = UIViewContentModeScaleAspectFill;
		
		if (self.hotShareItem.photoUrl) {
			NSURL *url = [NSURL URLWithString:self.hotShareItem.photoUrl];
			[_albumIconView setImageWithURL:url];

		}
	}
	return _albumIconView;
}

- (RNMiniPublisherView *)miniPublisherView{
	if (!_miniPublisherView) {
		_miniPublisherView = [[RNMiniPublisherView alloc]initWithFrame:CGRectMake(0,
																				 PHONE_SCREEN_SIZE.height - kMiniPublisherHeight, 
																				 PHONE_SCREEN_SIZE.width, 
																				  kMiniPublisherHeight) 
														andCommentType:ECommentAlbumType];
	}
	return _miniPublisherView;
}
@end
