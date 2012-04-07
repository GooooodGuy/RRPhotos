//
//  RNPhotosUploadViewControllerViewController.m
//  RRSpring
//
//  Created by yi chen on 12-3-29.
//  Copyright (c) 2012年 RenRen.com. All rights reserved.
//

#import "RNEditPhotoViewController.h"

#import "RCBaseRequest.h"
#import "RCMainUser.h"

#define ALBUM_TABLE_CELL_HEIGHT 20 //相册选择列表的单元高度
#define ALBUM_TABLE_HEIGHT 300 //相册选择列表的高度
#define NAVIGATIONBAR_BACKGROUND @"navigationbar_background.png"
#define MAX_IMAGE_DISPLAY_WIDTH 320 //最大的照片显示宽度

static CGFloat DegreesToRadians(CGFloat degrees) { return degrees * M_PI / 180; };

/**
 *私有方法
 */
@interface RNEditPhotoViewController ()

//网络请求完成
- (void)requestDidSucceed:(NSDictionary *)result ;
//网络请求错误
- (void)requestDidError:(RCError *)error;
//载入图片
-(id)scaleAndRotateImage:(UIImage*) image size:(NSInteger)size  isToLoadHDImage:(BOOL) isToLoadHDImage ;
//旋转图片
- (UIImage *)imageRotated:(UIImage*)img andByDegrees:(CGFloat)degrees;
//展示相册列表
- (void)showAlbumTable;
//隐藏相册列表
- (void)hiddenAlbumTable;

@end


@implementation RNEditPhotoViewController
@synthesize currentImageView = _currentImageView;
@synthesize highQualityImage = _highQualityImage;
@synthesize normalQualityImage = _normalQualityImage;
@synthesize qualityLengthLabel = _qualityLengthLabel;
@synthesize topNavView = _topNavView;
@synthesize slibBarPoiontView = _slibBarPoiontView;
@synthesize hdTextLabel = _hdTextLabel;
@synthesize normalTextLabel = _normalTextLabel;
@synthesize photoTurnLeftButton = _photoTurnLeftButton;
@synthesize toolBarView = _toolBarView;
@synthesize albumSelectBarView = _albumSelectBarView;
@synthesize albumNameTableView = _albumNameTableView;
@synthesize albumID = _albumID;
@synthesize albumNameLabel = _albumNameLabel;
@synthesize arrowView = _arrowView;
@synthesize albumIDArray = _albumIDArray;
@synthesize delegate = _delegate;
@synthesize requestAssistant = _requestAssistant;
@synthesize oldSelectedIndexPath = _oldSelectedIndexPath;


- (void)dealloc{

	self.currentImageView  = nil;
	self.highQualityImage = nil;
	self.normalQualityImage = nil;
	self.qualityLengthLabel = nil;

	self.topNavView = nil;

	self.slibBarPoiontView = nil;
	self.hdTextLabel = nil;
	self.normalTextLabel = nil;
	self.photoTurnLeftButton = nil;
	self.toolBarView = nil;
	self.albumNameTableView = nil;
	self.albumID = nil;
	self.albumSelectBarView = nil;
	self.albumNameLabel = nil;
	self.arrowView = nil;
	self.albumIDArray = nil;
	self.delegate = nil;
	self.requestAssistant = nil;
	[super dealloc];
}

/*
 * 从外部导入要编辑的图片
 */
- (void)loadImageToEdit:(UIImage *)editImage{
	
	//载入高清图片
	self.highQualityImage = [self scaleAndRotateImage:editImage size:1024 isToLoadHDImage:YES];
	_highQualityLength = [UIImageJPEGRepresentation(_highQualityImage, 1.0f) length];

	//载入普通图片
	UIImage* lowimg = [self scaleAndRotateImage:editImage size:600 isToLoadHDImage:NO];
	NSData* data = UIImageJPEGRepresentation(lowimg, 0.98f);
	
	_normalQualityLength = [data length];
	
	
	self.normalQualityImage = [UIImage imageWithData:data];

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
	
		//默认是非全屏浏览模式
		isFullScreenMode = NO;
		
		//默认选用高清图片
		isHDPhoto = YES;
		
		//默认是没有展开相册列表
		isExpand = NO;
		
		//网络请求初始化
		self.requestAssistant = [RCGeneralRequestAssistant requestAssistant];
		self.requestAssistant.onCompletion = ^(NSDictionary* result){
			[self requestDidSucceed:result];
		};
		
		self.requestAssistant.onError = ^(RCError* error) {
			[self requestDidError:error];
		};
				
		//相册列表数组
		_albumIDArray= [[NSMutableArray alloc]initWithCapacity:100];
    }
    return self;
}


#pragma -mark 显示照片
//显示当前要编辑的照片
- (void)displayCurrentView{
	
	if(nil == self.highQualityImage){
		return;
	}
	
	
	CGFloat image_w = self.highQualityImage.size.width;
	CGFloat image_h = self.highQualityImage.size.height;
	NSLog(@"原始图片的宽度：%f 高度 %f",image_w,image_h);
	
	CGFloat newImageWidth = image_w ;
	CGFloat newImageHeigth = image_w;

	if (image_w > MAX_IMAGE_DISPLAY_WIDTH) {
		newImageWidth = MAX_IMAGE_DISPLAY_WIDTH;//宽度设为最大的显示
		newImageHeigth = newImageWidth / image_w * image_h; 
	}


	CGRect viewFrame = CGRectMake(160 - newImageWidth / 2, 230 - newImageHeigth / 2,
								   newImageWidth, newImageHeigth);
	_lastDisplayFrame = viewFrame;//记录最近一次的显示矩形框
	
	[self.view removeAllSubviews];//先移除，否则会被覆盖
	
	
	if (self.currentImageView != nil) {
		[self.currentImageView removeGestureRecognizer:_pinchRecognizer];
		[self.currentImageView removeGestureRecognizer:_doubleTapGesture];
		[self.currentImageView removeGestureRecognizer:_singleTapGesture];
	}
	
	self.currentImageView = nil;
	UIImageView *view = [[UIImageView alloc]init];
	view.frame = viewFrame;
	[self.view addSubview: view]; 
	self.currentImageView = view;
	[view release];
	
	
	[self.view addSubview:self.topNavView];
	[self.view addSubview:self.albumNameTableView];
	[self.view addSubview:self.albumSelectBarView];
	[self.view addSubview: self.toolBarView];
	
	self.currentImageView.frame = viewFrame;
	if (isHDPhoto) {
		self.currentImageView.image = self.highQualityImage;//加载高清图片
	}else{
		self.currentImageView.image = self.normalQualityImage;//加载普通图片
	}
	
	
	//加入当前照片的手势
	self.currentImageView.userInteractionEnabled = YES;    //允许用户交互
	[self.currentImageView addGestureRecognizer:_pinchRecognizer];//添加图片点击手势，做全屏浏览处理
	[self.currentImageView addGestureRecognizer:_singleTapGesture];
	[self.currentImageView addGestureRecognizer:_doubleTapGesture]; 

}

- (void)onClickConcelButton{
	//点击取消按钮
//	[self.titleLabel removeFromSuperview];//移除添加的title,否则将会有异常显示
	[self.navigationController popViewControllerAnimated:YES];
}

/*
 * 确认按钮点击，回调传回数据，包括照片数据，选中的相册ID
 */
- (void)onClickConfirmButton{
	
	//传回照片数据
	NSMutableDictionary *photoInfoDic = [NSMutableDictionary dictionaryWithCapacity:5];
		

//	if (self.albumID) {

		[photoInfoDic setObject:self.albumID forKey:@"id"]; //传回选中的相册ID

		if (isHDPhoto) { //传回原始高清图片
			[self.delegate editPhotoFinished:self.highQualityImage photoInfoDic:photoInfoDic];
		}else {
			[self.delegate editPhotoFinished:self.normalQualityImage photoInfoDic:photoInfoDic];
		}
//	}
		
}

/*
 * 旋转照片操作
 */
- (void)onClickTurnLeftButton{
	//点击旋转图片按钮
//	self.currentImageView.image = [self imageRotated:self.currentImageView.image andByDegrees:90];
	self.highQualityImage = [self imageRotated:self.highQualityImage andByDegrees:-90];
	self.normalQualityImage = [self imageRotated:self.normalQualityImage andByDegrees:-90];
	[self displayCurrentView];
//	[self.view layoutIfNeeded];
}

#pragma -mark 切换图片清晰度
/**
 * 切换照片质量
 */
- (void)onClickSwitchButton{
	isHDPhoto = ! isHDPhoto; //图片质量切换
	if (!isHDPhoto) { 
		[UIView animateWithDuration:0.3 animations:^(){
			self.slibBarPoiontView.frame = CGRectMake(239, 24, _slibBarPoiontView.image.size.width, 
													  _slibBarPoiontView.image.size.height);
		}];
		
		self.normalTextLabel.textColor = RGBCOLOR(222, 222, 222); //设置标签选中颜色
		self.hdTextLabel.textColor = RGBCOLOR(138, 138, 138);
		
		
		
		[UIView animateWithDuration:1 animations:^(){//显示图片大小
			float l = _normalQualityLength / 1024.0;
			if (l > 1024 ) {
				self.qualityLengthLabel.text = [NSString stringWithFormat:@"图片大小：%.2fM",l / 1024]; 
			}else {
				self.qualityLengthLabel.text = [NSString stringWithFormat:@"图片大小：%.2fK",l]; 
			}
			 
			self.qualityLengthLabel.alpha = 1.0f;
			
		} completion:^(BOOL finished){
			if (finished) { //隐藏
				[UIView animateWithDuration:1 animations:^(){
					self.qualityLengthLabel.alpha = 0.0f;
				}];
			}
			
		}];
	}else {
		[UIView animateWithDuration:0.3 animations:^(){
			self.slibBarPoiontView.frame = CGRectMake(289, 24, _slibBarPoiontView.image.size.width, 
													  _slibBarPoiontView.image.size.height);
		}];
		
		self.hdTextLabel.textColor = RGBCOLOR(222, 222, 222); //改变两个标签的颜色，标记选中状态
		self.normalTextLabel.textColor = RGBCOLOR(138, 138, 138);
		
		
		[UIView animateWithDuration:1 animations:^(){//显示图片大小
			float l = _highQualityLength / 1024.0;
			if (l > 1024 ) {
				self.qualityLengthLabel.text = [NSString stringWithFormat:@"图片大小：%.2fM",l / 1024]; 
			}else {
				self.qualityLengthLabel.text = [NSString stringWithFormat:@"图片大小：%.2fK",l]; 
			} 
			self.qualityLengthLabel.alpha = 1.0f;
			
		} completion:^(BOOL finished){
			if (finished) { //隐藏
				[UIView animateWithDuration:1 animations:^(){
					self.qualityLengthLabel.alpha = 0.0f;
				}];
			}
			
		}];
	}
	
	[self displayCurrentView];
	//照片质量切换
}

#pragma -mark view lifecycle

- (void)loadView{
	
	[super loadView];
	self.view.backgroundColor = [UIColor blackColor];
	
	//导航栏的背景
	UIImageView *topView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"button_bar.png"]];
	self.topNavView = topView;
	self.topNavView.userInteractionEnabled = YES;
	self.topNavView.frame = CGRectMake(0, 0, 320, 44);
	[topView release];
	
	//返回按键
	UIButton* concelButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[concelButton setImage:[UIImage imageNamed:@"titlebar_cancel.png"]  
				  forState:UIControlStateNormal];
	CGSize buttonSize = [concelButton currentImage].size;
	concelButton.frame = CGRectMake(5, 0, buttonSize.width	,buttonSize.height);
	[concelButton addTarget:self action:@selector(onClickConcelButton) 
		   forControlEvents:UIControlEventTouchUpInside];
	[self.topNavView addSubview:concelButton];
	[self.view addSubview:self.topNavView];
	
	//确认按钮
	UIButton* confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[confirmButton setImage:[UIImage imageNamed:@"titlebar_confirm.png"] 
				   forState:UIControlStateNormal];
	CGSize confirmButtonSize = [confirmButton currentImage].size;
	confirmButton.frame = CGRectMake(270, 0, confirmButtonSize.width, confirmButtonSize.height);
	[confirmButton addTarget:self action:@selector(onClickConfirmButton) 
			forControlEvents:UIControlEventTouchUpInside];
	[self.topNavView addSubview:confirmButton];
	
	//标题栏
	UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(59, 8, 137, 28)];
	[titleLabel setBackgroundColor: [UIColor clearColor]];
	[titleLabel setTextColor:RGBCOLOR(255, 255, 255)];
	[titleLabel setShadowOffset:CGSizeMake(0, -2)]; 
	[titleLabel setShadowColor:RGBACOLOR(0, 0, 0, 0.3)];//阴影颜色及alpha
	[titleLabel setFont:[UIFont fontWithName:MED_HEITI_FONT size:20]];
	[titleLabel setText:@"编辑照片"];
	[self.topNavView addSubview:titleLabel];
	[titleLabel release];
	
	//相册名称选择bar(点击弹出下拉列表)
	_albumSelectBarView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"album_selected_bar.png"]];
	self.albumSelectBarView.frame = CGRectMake(0, CONTENT_NAVIGATIONBAR_HEIGHT, 320, _albumSelectBarView.image.size.height);
	self.albumSelectBarView.userInteractionEnabled = YES;//允许使用手势点击
	UITapGestureRecognizer *albumNameTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self 
																						 action:@selector(tapAlbumSelectBar)];
	[albumNameTapGesture setNumberOfTapsRequired:1];
	[self.albumSelectBarView addGestureRecognizer:(albumNameTapGesture)];//添加图片点击手势，做全屏浏览处理
	[albumNameTapGesture release];
	[self.view addSubview:self.albumSelectBarView];
	
	//下拉箭头
	_arrowView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pull_arrow.png"]];
	self.arrowView.frame = CGRectMake(293, 9, _arrowView.image.size.width,_arrowView.image.size.height);
	[self.albumSelectBarView addSubview:self.arrowView];
	
	
	_albumNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 6, 275, 20)];
	[_albumNameLabel setBackgroundColor:[UIColor clearColor]];
	[_albumNameLabel setTextColor:RGBCOLOR(255, 255, 255)];
	[_albumNameLabel setShadowColor:RGBACOLOR(0, 0, 0, 0.75)];
	[_albumNameLabel setShadowOffset:CGSizeMake(0, 2)];
	[_albumNameLabel setFont:[UIFont fontWithName:MED_HEITI_FONT size:15]];
	[_albumNameLabel setText:@"上传相册:"];
	[self.albumSelectBarView addSubview:self.albumNameLabel];
	
	
	//工具栏
	_toolBarView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"button_bar.png"]]autorelease];
	self.toolBarView.frame = CGRectMake(0, 480 - 44 - 20, 320, 44);
	[self.view addSubview:self.toolBarView];
	self.toolBarView.userInteractionEnabled = YES;
	
	//选择照片按钮
	_photoTurnLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.photoTurnLeftButton setImage:[UIImage imageNamed:@"turn_icon.png" ]
							  forState:UIControlStateNormal];
	self.photoTurnLeftButton.frame = CGRectMake(27, 0, [self.photoTurnLeftButton currentImage].size.width, 
												[self.photoTurnLeftButton currentImage].size.height);
	[self.photoTurnLeftButton addTarget:self action:@selector(onClickTurnLeftButton) //点击旋转图片
					   forControlEvents:UIControlEventTouchUpInside];
	[self.toolBarView addSubview:self.photoTurnLeftButton]; //添加到工具栏
	
	
	//照片质量切换控件
	UIButton *photoQualitySwitchButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[photoQualitySwitchButton setImage:[UIImage imageNamed:@"slid_bar.png"] forState:UIControlStateNormal];
	[photoQualitySwitchButton addTarget:self action:@selector(onClickSwitchButton) 
					   forControlEvents:UIControlEventTouchUpInside];
	photoQualitySwitchButton.frame  = CGRectMake(239, 24, photoQualitySwitchButton.currentImage.size.width,
												 photoQualitySwitchButton.currentImage.size.height);
	[self.toolBarView addSubview:photoQualitySwitchButton];
	
	//质量切换上面的小点
	_slibBarPoiontView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"slid_point.png"]];
	self.slibBarPoiontView.frame = CGRectMake(289, 24, _slibBarPoiontView.image.size.width, 
											  _slibBarPoiontView.image.size.height);
	
	[self.toolBarView addSubview:self.slibBarPoiontView];
	
	//文字 高清
	_hdTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(285, 5, 30, 25)];
	self.hdTextLabel.backgroundColor = [UIColor clearColor];
	self.hdTextLabel.textColor = RGBCOLOR(222, 222, 222);
	self.hdTextLabel.text = @"高清";
	self.hdTextLabel.font = [UIFont fontWithName: LIGHT_HEITI_FONT size:12];
	self.hdTextLabel.shadowColor = RGBACOLOR(0, 0, 0,0.75);
	self.hdTextLabel.shadowOffset = CGSizeMake(0, -2);
	[self.toolBarView addSubview:self.hdTextLabel];
	
	//文字 普通
	_normalTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(235, 5, 30, 25)];
	self.normalTextLabel.backgroundColor = [UIColor clearColor];
	self.normalTextLabel.textColor = RGBCOLOR(138, 138, 138);
	self.normalTextLabel.text = @"普通";
	self.normalTextLabel.font = [UIFont fontWithName: LIGHT_HEITI_FONT size:12];
	self.normalTextLabel.shadowColor = RGBACOLOR(0, 0, 0,0.75);
	self.normalTextLabel.shadowOffset = CGSizeMake(0, -2);
	[self.toolBarView addSubview:self.normalTextLabel];
	
	//图片大小文字
	_qualityLengthLabel = [[UILabel alloc]initWithFrame:CGRectMake(200 , -30, 160, 30)];
	self.qualityLengthLabel.backgroundColor = [UIColor clearColor];
	self.qualityLengthLabel.alpha = 1.0;//开始是显示
	self.qualityLengthLabel.font = [UIFont fontWithName:LIGHT_HEITI_FONT size:12];
	self.qualityLengthLabel.textColor = RGBCOLOR(255, 255, 255);
	if (_highQualityLength / 1024.0 > 1024) { //如果大于1024K 则换算成M
		self.qualityLengthLabel.text = [NSString stringWithFormat:@"图片大小：%.2fM",_highQualityLength / 1024.0 / 1024];
  	}else {
		self.qualityLengthLabel.text = [NSString stringWithFormat:@"图片大小：%.2fK",_highQualityLength / 1024.0];
	}
	
	[self.toolBarView addSubview:self.qualityLengthLabel];
	
	//相册列表 
	_albumNameTableView = [[UITableView alloc]initWithFrame:
						   CGRectMake(0,44 + _albumSelectBarView.frame.size.height	, 320, 0) style:UITableViewStylePlain];
	self.albumNameTableView.showsVerticalScrollIndicator = NO;//隐藏滚动条
	self.albumNameTableView.bounces = NO;//不允许反向拖动
	self.albumNameTableView.separatorStyle = UITableViewCellSeparatorStyleNone;//设置无分割线
	self.albumNameTableView.hidden = NO;
	self.albumNameTableView.delegate  = self;
	self.albumNameTableView.dataSource = self;
	[self.view addSubview:self.albumNameTableView];
	
	//缩放手势
	_pinchRecognizer = [[UIPinchGestureRecognizer alloc]   
                        initWithTarget:self action:@selector(scaleChange:)];  
    [_pinchRecognizer setDelegate:self];  
	
	//双击手势
    _doubleTapGesture = [[UITapGestureRecognizer alloc]
                         initWithTarget:self action:@selector(doubletapCurrentImage)];
    _doubleTapGesture.numberOfTapsRequired = 2;
    [_doubleTapGesture setDelegate:self];
	
	//单机手势
    _singleTapGesture = [[UITapGestureRecognizer alloc]
                         initWithTarget:self action:@selector(tapCurrentImage)];
    _singleTapGesture.numberOfTapsRequired = 1;
    [_singleTapGesture setDelegate:self];
	
	
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
	//在这里隐藏才是真正的隐藏,否则有延迟显示
	[self.navigationController setNavigationBarHidden:YES animated:animated];
	
	[[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];

	[self displayCurrentView];//显示图片
	
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{

	[super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)setImageViewCenter{
    if(self.currentImageView){
        _currentImageView.frame = _lastDisplayFrame;
        if(_lastDisplayScale < 1.0){
            _lastDisplayScale = 1.0; //显示规模至1
            CGAffineTransform currentTransform = self.currentImageView.transform;  
            CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, 1.0, 1.0);  
            [self.currentImageView setTransform:newTransform];  
        }
    }
}
#pragma -mark 图片双击 则重置位置到中心
- (void)doubletapCurrentImage{
	[UIView animateWithDuration:0.5 animations:^(){
		[self setImageViewCenter];

	}];
}

#pragma -mark 图片单击 进入全屏浏览模式
- (void)tapCurrentImage{
	isFullScreenMode = !isFullScreenMode;
	
	[[UIApplication sharedApplication] setStatusBarHidden:isFullScreenMode withAnimation:UIStatusBarAnimationFade];
	
	[UIView beginAnimations:@"aa" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.15];
	if(isFullScreenMode)
	{	//全屏模式则隐藏
		for (UIView *subView in self.view.subviews) {
			if (subView != self.currentImageView) {
				subView.alpha = 0.0;
			}
		}
		self.navigationController.navigationBar.hidden = YES;
	}
	else 
	{
		for (UIView *subView in self.view.subviews) {
			subView.alpha = 1.0;
		}
		self.navigationController.navigationBar.hidden = NO;
	}
	[UIView commitAnimations];
}

#pragma -mark 缩放图片手势
- (void) scaleChange:(UIPinchGestureRecognizer*)gestureRecognizer{
	if([gestureRecognizer state] == UIGestureRecognizerStateEnded) {  
        _lastDisplayScale = 1.0;  
        if(_currentImageView.width < _lastDisplayFrame.size.width){
            _currentImageView.frame = _lastDisplayFrame;
        }
        [self touchesEnded:nil withEvent:nil];
        return;  
    }      
    CGFloat scale = 1.0 - (_lastDisplayScale - [(UIPinchGestureRecognizer*)gestureRecognizer scale]); 
	
    CGAffineTransform currentTransform = self.currentImageView.transform;  
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale); 
	
    if( _currentImageView.width > 2 *_lastDisplayFrame.size.width && scale > 1){ 
        return; //如果放大超过两倍，那么不再放大
    }
	
    if( _currentImageView.width <= _lastDisplayFrame.size.width * 1 && scale <= 1){
        CGAffineTransform currentTransform = self.currentImageView.transform;  
        CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, 1, 1);  
        [self.currentImageView setTransform:newTransform]; 
        _lastDisplayScale = 1; 
        return; 
    }
	
    [self.currentImageView setTransform:newTransform]; 
    _lastDisplayScale = [gestureRecognizer scale];  

}
#pragma -mark 点击展开相册列表
- (void)tapAlbumSelectBar{
	//发送网络请求相册列表
	if (!isExpand && [self.albumIDArray count] == 0) { //如果数据为空，并且没有展开，则发网络请求
		RCMainUser *mainUser = [RCMainUser getInstance];
		NSMutableDictionary *dics = [NSMutableDictionary dictionaryWithCapacity:10];
		if (mainUser.msessionKey) {
			[dics setObject:mainUser.msessionKey forKey:@"session_key"];
			[dics setObject:mainUser.userId forKey:@"uid"];
			[dics setObject:[NSNumber numberWithInt:160] forKey:@"page_size"];
			[self.requestAssistant sendQuery:dics withMethod:@"photos/getAlbums"];
		}
	}else if (!isExpand ) { //如果有数据，直接展示
		[self showAlbumTable];
		
	}else { //如果已经展开，那么直接收缩

		[self hiddenAlbumTable];
	}

}

//显示相册列表
- (void)showAlbumTable{
	[self.albumNameTableView reloadData];
	
	//旋转下拉箭头
	[UIView animateWithDuration:0.5 animations:^(){
		//旋转下拉箭头
		self.arrowView.transform = CGAffineTransformMakeRotation(M_PI);
		
		//下拉列表出现
		self.albumNameTableView.height = ALBUM_TABLE_HEIGHT;
	}];
	
	isExpand = !isExpand;
}

//隐藏相册列表
- (void)hiddenAlbumTable{
	[UIView animateWithDuration:0.5 animations:^(){
		//下拉箭头归位
		self.arrowView.transform = CGAffineTransformIdentity;
		
		//收缩列表
		self.albumNameTableView.height = 0;
	}];
	
	isExpand = !isExpand; 
}


#pragma -mark UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
	
    return cell.frame.size.height;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	
	return [self.albumIDArray count] + 1;//多一行照片添加相册
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	if (indexPath.row == [self.albumIDArray count]) {
		//新建相册操作 待加入
		RNCreateAlbumViewController *rn = [[RNCreateAlbumViewController alloc]init];
		rn.delegate = self;
		[self.navigationController pushViewController:rn animated:YES];
		[rn release];
	}else {

		NSDictionary * dic = (NSDictionary * )[self.albumIDArray objectAtIndex:indexPath.row];//获取相册名称
		self.albumID = [dic objectForKey: @"id"]; //相册ID
		self.albumNameLabel.text = [NSString stringWithFormat:@"上传相册ID：%@",[dic objectForKey: @"title"]];
	}

	self.oldSelectedIndexPath = indexPath; //记录选中行

	[self hiddenAlbumTable];
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *cellIdentifier = @"albumcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	//设置Cell的字体
	UILabel *textLabel = [[[UILabel alloc]initWithFrame:CGRectMake(81, 16, 200, 22)]autorelease];
	textLabel.textAlignment = UITextAlignmentLeft;
	
	[textLabel setFont:[UIFont fontWithName:LIGHT_HEITI_FONT size:15]];
	[textLabel setTextColor:RGBCOLOR(255, 255, 255)];
	[textLabel setShadowColor:RGBACOLOR(0, 0, 0, 0.75)];
	[textLabel setShadowOffset:CGSizeMake(0, 2)];
	[textLabel setBackgroundColor:[UIColor clearColor]];
	if (indexPath.row < [self.albumIDArray count] ) {
		
		if (!cell) {
			cell = [[[UITableViewCell alloc] initWithStyle:
					 UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
					
			
		} 
		[cell.contentView removeAllSubviews];
		[cell.contentView addSubview:textLabel];
		textLabel.text = [NSString stringWithFormat:@"%@",
						  [[_albumIDArray objectAtIndex:indexPath.row] objectForKey:@"title"]];
		
		//如果是选中行的话 打钩钩
		if ([indexPath compare:self.oldSelectedIndexPath] == NSOrderedSame) { 
			UIImageView * addIconView = [[[UIImageView alloc]initWithImage:
										  [UIImage imageNamed:@"hook_icon.png"]]autorelease];
			addIconView.frame = CGRectMake(81, 16, addIconView.image.size.width, addIconView.image.size.height);//设置加号标记
			
			cell.accessoryView = addIconView;
		}else {
			cell.accessoryView = nil;
		}
		
				
	}else if(indexPath.row == [self.albumIDArray count] ){
		if (!cell) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
										   reuseIdentifier:cellIdentifier] autorelease];
			
			
		} 
		
		UIImageView * addIconView = [[[UIImageView alloc]initWithImage:
									  [UIImage imageNamed:@"album_add_icon.png"]]autorelease];
		addIconView.frame = CGRectMake(81, 16, addIconView.frame.size.width, addIconView.frame.size.height);
		//设置加号标记
	
		[cell.contentView removeAllSubviews];
		//缩进文本的位置
		textLabel.frame = CGRectOffset(textLabel.frame, 20 , 0);
		textLabel.text = [NSString stringWithFormat:@"添加新相册"];
		[cell.contentView addSubview:textLabel];	
		[cell.contentView addSubview:addIconView];
	}
	
	//设置Cell背景
	tableView.backgroundColor = [UIColor clearColor];
	cell.textLabel.backgroundColor = [UIColor clearColor];
	cell.detailTextLabel.backgroundColor = [UIColor clearColor];
	[cell setBackgroundColor:[UIColor clearColor]];
	UIImageView *backView = [[[UIImageView alloc]initWithImage:
							  [UIImage imageNamed: @"album_table_cell.png"]]autorelease];
	[cell setBackgroundView:backView]; //设置Cell背景图
	
	UIImageView *backViewSel = [[[UIImageView alloc]initWithImage:
								 [UIImage imageNamed:@"album_table_cell_hl.png"]]autorelease];
	[cell setSelectedBackgroundView:backViewSel]; //设置Cell选中的背景图片

	cell.height = backView.size.height;  //设置高度
	
    return cell;
}


#pragma mark - 网络请求相关
//网络请求成功
- (void)requestDidSucceed:(NSDictionary *)result {


	
    if (result) {
			[self.albumIDArray removeAllObjects];
            [self.albumIDArray addObjectsFromArray:[result objectForKey:@"album_list"]];
    }
	
	
	[self showAlbumTable];//展开下拉列表
	
}

//网络请求失败
- (void)requestDidError:(RCError *)error {
	UIAlertView *view = [[UIAlertView alloc]initWithTitle:nil message:@"获取相册失败" delegate:nil
										cancelButtonTitle:@"取消" otherButtonTitles: nil];
	[view show];
	[view release];
}

#pragma -mark RNCreateAlbumFinishDelegate
- (void)finishCreateAlbum{
	
	[self.albumIDArray removeAllObjects];//清空相册列表，以便重新加载
	[self tapAlbumSelectBar];//强制重载列表
}

#pragma -mark 照片拖动
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event  
{  
    UITouch *touch = [touches anyObject];  
    
    if ([touch view] == self.currentImageView) {   
        _gestureStartPoint=[touch locationInView: self.currentImageView];  
    }          
}  
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event  
{  
    UITouch *touch = [touches anyObject];    
    if ([touch view] == self.currentImageView)    
    {  
        CGPoint curr_point=[touch locationInView: self.currentImageView];  
        
        CGPoint imageCenter = self.currentImageView.center;  
        //直接改变中心坐标
        imageCenter.x += curr_point.x - _gestureStartPoint.x;  
        imageCenter.y += curr_point.y - _gestureStartPoint.y;  
        
        self.currentImageView.center = imageCenter;
        
    }
}  

//返回经过越界调整之后的中心坐标
- (CGPoint)adjustPhotoLocation{


	//显示的最小矩形框高度和宽度
	CGFloat minSize = MIN(_lastDisplayFrame.size.height, _lastDisplayFrame.size.width);
	
	CGRect cutFrame = CGRectMake(160 -  minSize / 2, 230 - minSize / 2, minSize, minSize);
	CGFloat cutLeft = cutFrame.origin.x ;
	CGFloat cutRight = cutFrame.origin.x + cutFrame.size.width;
	CGFloat cutTop = cutFrame.origin.y;
	CGFloat cutButtom = cutFrame.origin.y + cutFrame.size.height;
	
	CGPoint imageCenter = self.currentImageView.center;//当前显示的图片中心，可能已经缩放过
	CGFloat returnX = imageCenter.x;
	CGFloat returnY = imageCenter.y;
	
	if (imageCenter.x + _currentImageView.size.width / 2 < cutRight ) {
		returnX = cutRight - _currentImageView.size.width / 2; //如果右边不越界
	}
	if (imageCenter.x - _currentImageView.size.width / 2 > cutLeft) {
		returnX = cutLeft + _currentImageView.size.width / 2;
	}
	
	if (imageCenter.y + _currentImageView.size.height / 2 < cutButtom) {
		returnY = cutButtom - _currentImageView.size.height / 2;
	}
	if (imageCenter.y - _currentImageView.size.height / 2 > cutTop) {
		returnY = cutTop + _currentImageView.size.height / 2;
	}
	NSLog(@"x= %f y= %f",returnX,returnY);
	
	return CGPointMake(returnX, returnY);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	
	[UIView animateWithDuration:0.3 animations:^(void){
		[self.currentImageView setCenter:[self adjustPhotoLocation]];//限制调整范围

	}];
}

#pragma -mark 照片相关操作
/**
 * 图片加载
 */
-(id)scaleAndRotateImage:(UIImage*) image size:(NSInteger)size  isToLoadHDImage:(BOOL) isToLoadHDImage  
{   
    int kMaxResolution = size; // Or whatever   
	
    CGImageRef imgRef = image.CGImage;   
	
    CGFloat width = CGImageGetWidth(imgRef);   
    CGFloat height = CGImageGetHeight(imgRef);   
	
    CGAffineTransform transform = CGAffineTransformIdentity;   
    CGRect bounds = CGRectMake(0, 0, width, height);   
    if (width > kMaxResolution || height > kMaxResolution) {   
        CGFloat ratio = width/height;   
        if (ratio > 1) {   
            bounds.size.width = kMaxResolution;   
            bounds.size.height = bounds.size.width / ratio;   
        }   
        else {   
            bounds.size.height = kMaxResolution;   
            bounds.size.width = bounds.size.height * ratio;   
        }   
    }   
	
    CGFloat scaleRatio = bounds.size.width / width;   
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));   
    CGFloat boundHeight;   
    UIImageOrientation orient = image.imageOrientation;   
    switch(orient) {   
			
        case UIImageOrientationUp: //EXIF = 1   
            transform = CGAffineTransformIdentity;   
            break;   
			
        case UIImageOrientationUpMirrored: //EXIF = 2   
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);   
            transform = CGAffineTransformScale(transform, -1.0, 1.0);   
            break;   
			
        case UIImageOrientationDown: //EXIF = 3   
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);   
            transform = CGAffineTransformRotate(transform, M_PI);   
            break;   
			
        case UIImageOrientationDownMirrored: //EXIF = 4   
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);   
            transform = CGAffineTransformScale(transform, 1.0, -1.0);   
            break;   
			
        case UIImageOrientationLeftMirrored: //EXIF = 5   
            boundHeight = bounds.size.height;   
            bounds.size.height = bounds.size.width;   
            bounds.size.width = boundHeight;   
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);   
            transform = CGAffineTransformScale(transform, -1.0, 1.0);   
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);   
            break;   
			
        case UIImageOrientationLeft: //EXIF = 6   
            boundHeight = bounds.size.height;   
            bounds.size.height = bounds.size.width;   
            bounds.size.width = boundHeight;   
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);   
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);   
            break;   
			
        case UIImageOrientationRightMirrored: //EXIF = 7   
            boundHeight = bounds.size.height;   
            bounds.size.height = bounds.size.width;   
            bounds.size.width = boundHeight;   
            transform = CGAffineTransformMakeScale(-1.0, 1.0);   
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);   
            break;   
			
        case UIImageOrientationRight: //EXIF = 8   
            boundHeight = bounds.size.height;   
            bounds.size.height = bounds.size.width;   
            bounds.size.width = boundHeight;   
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);   
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);   
            break;   
			
        default:   
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];   
			
    }   
	
    UIGraphicsBeginImageContext(bounds.size);   
	
    CGContextRef context = UIGraphicsGetCurrentContext();   
	
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {   
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);   
        CGContextTranslateCTM(context, -height, 0);   
    }   
    else {   
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);   
        CGContextTranslateCTM(context, 0, -height);   
    }   
	
    CGContextConcatCTM(context, transform);   
	
//    if(isToLoadHDImage){ //是否导入的是高清图片
//        CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);   
//    } else {
        CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width+2, height), imgRef);   
//    }
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();   
    UIGraphicsEndImageContext();   
	
    return imageCopy;   
} 


/*
 * 旋转视图
 */
- (UIImage *)imageRotated:(UIImage*)img andByDegrees:(CGFloat)degrees
{  
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,img.size.width, img.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    [rotatedViewBox release];
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    // Rotate the image context
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-img.size.width / 2, -img.size.height / 2, img.size.width, img.size.height), [img CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
