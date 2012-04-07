//
//  RNPhotosUploadViewControllerViewController.h
//  RRSpring
//
//  Created by yi chen on 12-3-29.
//  Copyright (c) 2012年 RenRen.com. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "RNNavigationViewController.h"
//#import "RNBaseViewController.h"
#import "RNCreateAlbumViewController.h"

/*
  照片编辑完成回调 
  photoInfo 包括照片要上传的到哪个的相册ID 关键字为: @"id"
 */

@protocol RNEditPhotoFinishDelegate <NSObject>

/**
 * 照片编辑完成回调
 */
- (void)editPhotoFinished:(UIImage *) imageEdited photoInfoDic: (NSDictionary * )photoInfoDic;


@end

@interface RNEditPhotoViewController : UIViewController<UIActionSheetDelegate,UIGestureRecognizerDelegate,
	UINavigationControllerDelegate,UIImagePickerControllerDelegate,RNCreateAlbumFinishDelegate,
	UITableViewDelegate,UITableViewDataSource>
{
			
	//存储当前显示在编辑界面的照片
	UIImageView *_currentImageView;
	//缩放手势
	UIPinchGestureRecognizer *_pinchRecognizer;
	//双击手势
    UITapGestureRecognizer *_doubleTapGesture;
	//单击手势
    UITapGestureRecognizer *_singleTapGesture;
	
	//高清图片
	UIImage* _highQualityImage;
	
	//高清图片的大小
	NSInteger _highQualityLength;
	
	//普通图片
	UIImage* _normalQualityImage;
	
	//普通图片的大小
	NSInteger _normalQualityLength;
	
	//显示当前照片的大小
	UILabel* _qualityLengthLabel;
			
	//顶部的导航栏
	UIImageView *_topNavView;
	
	//照片质量切换按钮上面的那个小点
	UIImageView *_slibBarPoiontView;
	
	//普通文字label
	UILabel *_normalTextLabel;
	
	//高清文字label
	UILabel *_hdTextLabel;
	
	UIImageView *_toolBarView;
	
	//相册选择bar
	UIImageView *_albumSelectBarView;
	
	//相册名称列表
	UITableView *_albumNameTableView;
	
	//选中的相册ID
	NSString *_albumID;
	
	//当前选中的相册列表
	UILabel *_albumNameLabel;
	
	//下拉箭头
	UIImageView *_arrowView;
	
	//列表是否展开
	BOOL isExpand;
	
	//是否进入全屏模式
	BOOL isFullScreenMode;
	
	//图片是否高清
	BOOL isHDPhoto;
	
	//记录上一次的显示规模
	CGFloat _lastDisplayScale;
	
	//记录显示矩形框，用于缩放时候的重置位置
	CGRect _lastDisplayFrame;
	
	CGPoint _gestureStartPoint;
		
	//相册列表名称数组
	NSMutableArray *_IDArray;

	//编辑完成回调
	id<RNEditPhotoFinishDelegate> _delegate;
	
	//网络请求
	RCGeneralRequestAssistant *_requestAssistant;
	
	//记录当前选中的是哪个cell
	NSIndexPath* _oldSelectedIndexPath;
}
@property(nonatomic,retain)UIImageView *currentImageView;

@property(nonatomic,retain)UIImage *highQualityImage;

@property(nonatomic,retain)UIImage *normalQualityImage;

@property(nonatomic,retain)UILabel *qualityLengthLabel;

@property(nonatomic,retain)UIImageView *topNavView;

@property(nonatomic,retain)UIImageView *slibBarPoiontView;

@property(nonatomic,retain)UILabel *hdTextLabel;

@property(nonatomic,retain)UILabel *normalTextLabel;

@property(nonatomic,retain)UIButton *photoTurnLeftButton;

@property(nonatomic,retain)UIImageView *toolBarView;

@property(nonatomic,retain)UIImageView *albumSelectBarView;

@property(nonatomic,retain)UITableView *albumNameTableView;

@property(nonatomic,copy)NSString *albumID;

@property(nonatomic,retain)UILabel* albumNameLabel;

@property(nonatomic,retain)UIImageView *arrowView;

@property(nonatomic,retain)NSMutableArray *albumIDArray;

@property(nonatomic,assign)id<RNEditPhotoFinishDelegate> delegate;
 
@property (nonatomic, retain) RCGeneralRequestAssistant *requestAssistant;

@property (nonatomic,retain) NSIndexPath* oldSelectedIndexPath;

/**
 * 设置要编辑的照片
 */
- (void)loadImageToEdit:(UIImage *)editImage;

@end
