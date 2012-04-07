//
//  RNPickPhotoHelper.h
//  RRSpring
//
//  Created by yi chen on 12-3-31.
//  Copyright (c) 2012年 RenRen.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNEditPhotoViewController.h"

//相册拾取完成回调（已编辑）
//photoInfo 包括拍照的原始附加信息 key ：UIImagePickerControllerMediaMetadata
//photoInfo 包括照片要上传的到哪个的相册名称 关键字为: @"id"
@protocol RNPickPhotoDelegate <NSObject>

- (void)pickPhotoFinished:(UIImage *)imagePicked photoInfoDic: (NSDictionary * )photoInfoDic;

@end

@interface RNPickPhotoHelper : NSObject<UINavigationControllerDelegate, 
					UIImagePickerControllerDelegate ,RNEditPhotoFinishDelegate>
{
	//照片拾取控制器
	UIImagePickerController *_imagePickerController;
	
	//编辑照片页面
	RNEditPhotoViewController *_editPhotoController;

	//照片来源
	UIImagePickerControllerSourceType _sourceType;
	
	//返回的照片数据
	UIImage *_imageToReturn;
	
	//返回的照片附加信息，如照片要上传到的相册名称（关键字@“album_name”） id待加入
	NSDictionary * _photoInfoDic;
	
	id <RNPickPhotoDelegate> _delegate;
}

@property(nonatomic,retain)UIImagePickerController *imagePickerController;

@property(nonatomic,retain)RNEditPhotoViewController *editPhotoController;

@property(nonatomic,assign)UIImagePickerControllerSourceType sourceType;

@property(nonatomic,retain)UIImage *imageToReturn;

@property(nonatomic,retain)NSDictionary *photoInfoDic;

@property(nonatomic,assign)id<RNPickPhotoDelegate> delegate;
/**
 * 获取照片，数据通过回调传回
 */
- (void)pickPhotoWithSoureType:(UIImagePickerControllerSourceType) sourceType;

@end
